#import "FPopStatusBarAppDelegate.h"
#import "FPopStatusPoller.h"
#import "FPopTestStatusPoller.h"
#import "FPopStatus.h"
#import "FPopStatusNetworkMonitor.h"

//#define SIMULATE_NETWORK 1

@implementation FPopStatusBarAppDelegate

@synthesize window;

-(NSImage *) resizedImageNamed:(NSString *) name {
    NSImage *image = [NSImage imageNamed:name];
    if (image) {
        NSSize imageSize = [image size];
        imageSize.width = 18;
        imageSize.height = 18;
        [image setSize:imageSize];
    }
    return image;
}
-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"applicationDidFinishLaunching");
    app = (NSApplication *)aNotification.object;

    statusImages = [[[NSMutableDictionary alloc] init] retain];
    [statusImages setObject:[self resizedImageNamed:@"network-gsm-full_18.png" ] forKey:@"full"];
    [statusImages setObject:[self resizedImageNamed:@"network-gsm-high_18.png" ] forKey:@"high"];
    [statusImages setObject:[self resizedImageNamed:@"network-gsm-medium_18.png" ] forKey:@"medium"];
    [statusImages setObject:[self resizedImageNamed:@"network-gsm-low_18.png" ] forKey:@"low"];
    [statusImages setObject:[self resizedImageNamed:@"network-gsm-none_18.png" ] forKey:@"none"];
    [statusImages setObject:[self resizedImageNamed:@"network-wireless-disconnected_18.png" ] forKey:@"disconnected"];

    
    [self clearStatus];
#ifdef SIMULATE_NETWORK
    poller = [[[FPopTestStatusPoller alloc] initWithDelegate:self] retain];
    [poller pollStatus:2.0];
#endif
    
#ifndef SIMULATE_NETWORK
    poller = [[[FPopStatusPoller alloc] initWithDelegate:self] retain];
    networkMonitor = [[[FPopStatusNetworkMonitor alloc] initWithDelegate:self] retain];
    [networkMonitor fireOnLaunch];
#endif
}

-(void)applicationWillTerminate:(NSNotification *)notification {
    NSLog(@"applicationWillTerminate");
    [poller stopPolling];
    [poller release];
    poller = nil;
    
    [networkMonitor release];
    networkMonitor = nil;
    
    [statusImages release];
    statusImages = nil;
}

-(void)awakeFromNib
{
    NSLog(@"awakeFromNib");
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"FP"];
    [statusItem setHighlightMode:YES];
    
    NSMenuItem *quitItem = [statusMenu itemAtIndex:0];
    [quitItem setAction:@selector(quitApplication)];
    
}

- (void) quitApplication
{
    NSLog(@"quitApplication");
    [app terminate:self];
}

-(void) clearStatus
{
    [statusItem setTitle:@""];
    [statusItem setToolTip:@""];
    [statusItem setImage:[statusImages objectForKey:@"disconnected"]];
}

-(void) statusUpdated:(FPopStatus *)status
{
    NSLog(@"updateConnectionStatus %@", status);
    
    NSImage* statusImage = [statusImages objectForKey:status.signal];
    [statusItem setImage:statusImage];
    
    NSString *statusTxt = [NSString stringWithFormat:@"Status:%@\nSignal:%@\nUptime:%@\nIP Address:%@",
                           status.connectionStatus,
                           status.signalStr,
                           status.uptime,
                           status.ipAddress];
    [statusItem setToolTip:statusTxt];
}

-(void) ethernetConnected:(NSString *)interfaceName description:(NSString *)description {
    NSLog(@"ethernetConnected:%@, %@", interfaceName, description);
}

-(void) ethernetDisconnected: (NSString *)interfaceName {
    NSLog(@"ethernetDisconnected:%@", interfaceName);
}

-(void) wifiConnected:(NSString *)networkName {
    NSLog(@"wifiConnected: %@", networkName);
    [poller pollStatus:FPopStatusBarAppDelege_POLL_INTERVAL];
}

-(void) wifiDisconnected:(NSString *)networkName {
    NSLog(@"wifiDisconnected: %@", networkName);
    [poller stopPolling];
    [self clearStatus];
}

-(void) ipAddressUpdated:(NSString *)ipAddress {
    NSLog(@"ipAddressUpdated: %@", ipAddress);
}


@end
