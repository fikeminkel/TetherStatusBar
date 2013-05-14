#include <sys/socket.h>
#include <sys/sockio.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <net/if_media.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import "HardwareNetworkMonitor.h"

/* @"Link Status" == 1 seems to mean disconnected */
#define AIRPORT_DISCONNECTED 1

static struct ifmedia_description ifm_subtype_ethernet_descriptions[] = IFM_SUBTYPE_ETHERNET_DESCRIPTIONS;
static struct ifmedia_description ifm_shared_option_descriptions[] = IFM_SHARED_OPTION_DESCRIPTIONS;

typedef enum {
    FPopAirPortInterface,
    FPopEthernetInterface,
} NetworkInterfaceType;

@interface HardwareNetworkInterfaceStatus : NSObject {
    NSString *interface;
    NSDictionary *status;
    NetworkInterfaceType type;
}

@property (nonatomic, retain) NSString *interface;
@property (nonatomic, retain) NSDictionary *status;
@property (nonatomic, assign) NetworkInterfaceType type;

-(id)initForInterface:(NSString*)anInterface ofType:(NetworkInterfaceType)aType withStatus:(NSDictionary*)theStatus;

@end

@implementation HardwareNetworkInterfaceStatus

@synthesize interface;
@synthesize status;
@synthesize type;

-(id)initForInterface:(NSString *)anInterface
               ofType:(NetworkInterfaceType)aType
           withStatus:(NSDictionary *)theStatus
{
    if((self = [super init])){
        self.interface = anInterface;
        self.type = aType;
        self.status = theStatus;
    }
    return self;
}

- (void)dealloc
{
    [interface release];
    interface = nil;
    
    [status release];
    status = nil;
    
    [super dealloc];
}
@end

@implementation HardwareNetworkMonitor


@synthesize rlSrc;
@synthesize dynStore;
@synthesize networkInterfaceStates;
@synthesize previousIPCombined;
@synthesize delegate;


-(id)init {
    if((self = [super init])){
        self.previousIPCombined = nil;
        self.networkInterfaceStates = [NSMutableDictionary dictionary];
        
        [self startObserving];
    }
    return self;
}

-(id)initWithDelegate:(id) theDelegate {
    if (self = [self init]) {
        self.delegate = theDelegate;
    }
    return self;
}

-(void)dealloc {
    if (rlSrc) {
        CFRunLoopRemoveSource(CFRunLoopGetMain(), rlSrc, kCFRunLoopDefaultMode);
    }
    if (dynStore) {
        CFRelease(dynStore);
    }
    [networkInterfaceStates release];
    networkInterfaceStates = nil;
    
    [previousIPCombined release];
    previousIPCombined = nil;
    
    [super dealloc];
}

-(void)fireOnLaunch {
    NSLog(@"fireOnLaunch");
    [self interateInterfaces];
}

-(void)setupDynamicStore
{
    if (dynStore != NULL) {
        return;
    }
    
    SCDynamicStoreContext context = {0, self, NULL, NULL, NULL};
    
    dynStore = SCDynamicStoreCreate(kCFAllocatorDefault,
                                    CFBundleGetIdentifier(CFBundleGetMainBundle()),
                                    scCallback,
                                    &context);
    if (!dynStore) {
        NSLog(@"SCDynamicStoreCreate() failed: %s", SCErrorString(SCError()));
    }
    
    rlSrc = SCDynamicStoreCreateRunLoopSource(kCFAllocatorDefault, dynStore, 0);
    CFRunLoopAddSource(CFRunLoopGetMain(), rlSrc, kCFRunLoopDefaultMode);
    CFRelease(rlSrc);
}

-(void)startObserving
{
    [self setupDynamicStore];
    
    NSArray *watchedKeys = [NSArray arrayWithObjects:@"State:/Network/Interface/.*/Link", @"State:/Network/Interface/.*/AirPort", @"State:/Network/Global/IPv4", @"State:/Network/Global/IPv6", nil];
    if (!SCDynamicStoreSetNotificationKeys(dynStore,
                                           NULL,
                                           (CFArrayRef)watchedKeys)) {
        NSLog(@"SCDynamicStoreSetNotificationKeys() failed: %s", SCErrorString(SCError()));
        CFRelease(dynStore);
        dynStore = NULL;
    }
}

-(void)updateInterface:(NSString*)interface forType:(NetworkInterfaceType)type withStatus:(NSDictionary*)status {
    HardwareNetworkInterfaceStatus *new = [[[HardwareNetworkInterfaceStatus alloc] initForInterface:interface
                                                                                           ofType:type
                                                                                       withStatus:status] autorelease];
    if (type == FPopAirPortInterface) {
        [self updateAirportWithInterface:new];
    } else if (type == FPopEthernetInterface) {
        [self updateLinkWithInterface:new];
    }
    [networkInterfaceStates setObject:new forKey:interface];
}

-(void)updateAirportWithInterface:(HardwareNetworkInterfaceStatus*)interface {
    NSString *interfaceString = [interface interface];
    NSDictionary *newValue = [interface status];
    NSDictionary *existing = [(HardwareNetworkInterfaceStatus *)[networkInterfaceStates objectForKey:interfaceString] status];
    
    NSData *newBSSID = nil;
    if (newValue) {
        newBSSID = [newValue objectForKey:@"BSSID"];
    }
    NSData *oldBSSID = nil;
    if (existing) {
        oldBSSID = [existing objectForKey:@"BSSID"];
    }
    if (newValue && ![oldBSSID isEqualToData:newBSSID] && !(newBSSID && oldBSSID && CFEqual(oldBSSID, newBSSID))) {
        NSNumber *linkStatus = [newValue objectForKey:@"Link Status"];
        NSNumber *powerStatus = [newValue objectForKey:@"Power Status"];
        if (linkStatus || powerStatus) {
            int status = 0;
            if (linkStatus) {
                status = [linkStatus intValue];
            } else if (powerStatus) {
                status = [powerStatus intValue];
                status = !status;
            }
            NSString *networkName = nil;
            if (status == AIRPORT_DISCONNECTED) {
                networkName = [existing objectForKey:@"SSID_STR"];
                if (!networkName)
                    networkName = [existing objectForKey:@"SSID"];
                if(networkName)
                    [self airportDisconnected:networkName];
            } else {
                networkName = [newValue objectForKey:@"SSID_STR"];
                if (!networkName)
                    networkName = [newValue objectForKey:@"SSID"];
                if(networkName && newBSSID){
                    [self airportConnected:networkName bssid:newBSSID];
                }
            }
        }
    }
}

-(void)airportDisconnected:(NSString*)networkName {
    [delegate wifiDisconnected:networkName];
}

-(void)airportConnected:(NSString*)networkName bssid:(NSData*)data {
    [delegate wifiConnected:networkName];
}

-(void)updateLinkWithInterface:(HardwareNetworkInterfaceStatus*)interface {
    NSString *interfaceString = [interface interface];
    NSDictionary *newValue = [interface status];
    NSDictionary *existing = [(HardwareNetworkInterfaceStatus*)[networkInterfaceStates objectForKey:interfaceString] status];
    int newActive = [[newValue objectForKey:@"Active"] intValue];
    int oldActive = [[existing objectForKey:@"Active"] intValue];
    
    if (newActive && !oldActive) {
        [delegate ethernetConnected:interfaceString description:[self getMediaForInterface:interfaceString]];
    } else if (!newActive && oldActive) {
        [delegate ethernetDisconnected:interfaceString];
    }
}

/* TO DO: REWRITE ME WITH BETTER METHODS OF GETTING INFO */
- (NSString *)getMediaForInterface:(NSString*)interfaceString {
    // This is all made by looking through Darwin's src/network_cmds/ifconfig.tproj.
    // There's no pretty way to get media stuff; I've stripped it down to the essentials
    // for what I'm doing.
    
    const char *interface = [interfaceString UTF8String];
    size_t length = strlen(interface);
    if (length >= IFNAMSIZ)
        NSLog(@"Interface name too long");
    
    int s = socket(AF_INET, SOCK_DGRAM, 0);
    if (s < 0) {
        NSLog(@"Can't open datagram socket");
        return NULL;
    }
    struct ifmediareq ifmr;
    memset(&ifmr, 0, sizeof(ifmr));
    strncpy(ifmr.ifm_name, interface, sizeof(ifmr.ifm_name));
    
    if (ioctl(s, SIOCGIFMEDIA, (caddr_t)&ifmr) < 0) {
        // Media not supported.
        close(s);
        return NULL;
    }
    
    close(s);
    
    // Now ifmr.ifm_current holds the selected type (probably auto-select)
    // ifmr.ifm_active holds details (100baseT <full-duplex> or similar)
    // We only want the ifm_active bit.
    
    const char *type = "Unknown";
    
    // We'll only look in the Ethernet list. I don't care about anything else.
    struct ifmedia_description *desc;
    for (desc = ifm_subtype_ethernet_descriptions; desc->ifmt_string; ++desc) {
        if (IFM_SUBTYPE(ifmr.ifm_active) == desc->ifmt_word) {
            type = desc->ifmt_string;
            break;
        }
    }
    
    NSMutableString *options = nil;
    
    // And fill in the duplex settings.
    for (desc = ifm_shared_option_descriptions; desc->ifmt_string; desc++) {
        if (ifmr.ifm_active & desc->ifmt_word) {
            if (options) {
                [options appendFormat:@",%s", desc->ifmt_string];
            } else {
                options = [NSMutableString stringWithUTF8String:desc->ifmt_string];
            }
        }
    }
    
    NSString *media;
    if (options) {
        media = [NSString stringWithFormat:@"%s <%@>",
                 type,
                 options];
    } else {
        media = [NSString stringWithUTF8String:type];
    }
    
    return media;
}

-(void)updateIP {
    
    NSHost *currentHost = [NSHost currentHost];
    NSLog(@"updateIP addresses:%@, %@", [currentHost addresses], [currentHost names]);
//    
//    // TODO what does this do?
//    NSArray *routable = [GrowlNetworkUtilities routableIPAddresses];
//    NSString *combined = [routable componentsJoinedByString:@"\n"];
//    if([combined isEqualTo:previousIPCombined])
//        return;

//    self.previousIPCombined = combined;

    //[delegate ipAddressUpdated:newIpAddress];
}

- (void) interateInterfaces
{
    __block NSMutableArray *keys = [NSMutableArray array];
    //process the currently standing interfaces and fire off notifications for those
    CFDictionaryRef interfaces = SCDynamicStoreCopyValue(dynStore, CFSTR("State:/Network/Interface"));
    NSArray *interfaceNames = [(NSDictionary*)interfaces objectForKey:@"Interfaces"];
    
    [interfaceNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj hasPrefix:@"en"] || [obj length] < 3 || !isdigit([obj characterAtIndex:2])) {
            return;
        }
        
        //Check against airport first
        NSString *key = [NSString stringWithFormat:@"State:/Network/Interface/%@/AirPort", obj];
        CFDictionaryRef status = SCDynamicStoreCopyValue(dynStore, (CFStringRef)key);
        if(status)
        {
            [keys addObject:key];
            CFRelease(status);
        }
        else
        {
            key = [NSString stringWithFormat:@"State:/Network/Interface/%@/Link", obj];
            status = SCDynamicStoreCopyValue(dynStore, (CFStringRef)key);
            if(status)
            {
                [keys addObject:key];
                CFRelease(status);
            }
        }
    }];
    if(interfaces)
        CFRelease(interfaces);
    
    //fire off IPv4 and IPv6 notifications
    [keys addObject:@"State:/Network/Global/IPv4"];
    [keys addObject:@"State:/Network/Global/IPv6"];
    
    scCallback(dynStore, (CFArrayRef)keys, self);
}

static void scCallback(SCDynamicStoreRef store, CFArrayRef changedKeys, void *info) {
    @autoreleasepool {
        HardwareNetworkMonitor *observer = info;
        
        [(NSArray*)changedKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            if([key hasPrefix:@"State:/Network/Global"])
                [observer updateIP];
            else if([key hasPrefix:@"State:/Network/Interface"]) {
            //if([key hasPrefix:@"State:/Network/Interface"]) {
                NSArray *notification = [key componentsSeparatedByString:@"/"];
                NSString *interface = [notification objectAtIndex:[notification count]-2];
                
                //Check against airport first
                if ([key hasSuffix:@"AirPort"]) {
                    CFDictionaryRef status = SCDynamicStoreCopyValue(store, (CFStringRef)key);
                    if (status) {
                        [observer updateInterface:interface forType:FPopAirPortInterface withStatus:(NSDictionary*)status];
                        CFRelease(status);
                    }
                } else if ([key hasSuffix:@"Link"]) {
                    NSString *isAnAirportConnection = [key stringByReplacingOccurrencesOfString:@"Link" withString:@"AirPort"];
                    CFDictionaryRef status = SCDynamicStoreCopyValue(store, (CFStringRef)isAnAirportConnection);
                    if (!status) {
                        status = SCDynamicStoreCopyValue(store, (CFStringRef)key);
                        if (status) {
                            [observer updateInterface:interface forType:FPopEthernetInterface withStatus:(NSDictionary*)status];
                            CFRelease(status);
                        }
                    }
                    else {
                        CFRelease(status);
                    }
                } else {
                    NSLog(@"Invalid Notification: %@", key);
                }
            }
        }];
    }
}

@end
