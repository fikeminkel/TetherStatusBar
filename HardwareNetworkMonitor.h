#import <SystemConfiguration/SystemConfiguration.h>
#import <Foundation/Foundation.h>

@protocol HardwareNetworkMonitorDelegate <NSObject>
@required
-(void) ipAddressUpdated:(NSString *)ipAddress;
-(void) ethernetConnected:(NSString *)interfaceName description:(NSString *)description;
-(void) ethernetDisconnected: (NSString *)interfaceName;
-(void) wifiConnected:(NSString *)networkName;
-(void) wifiDisconnected:(NSString *)networkName;
@end

@interface HardwareNetworkMonitor : NSObject {
    SCDynamicStoreRef dynStore;
    CFRunLoopSourceRef rlSrc;
    NSMutableDictionary *networkInterfaceStates;
    NSString *previousIPCombined;
    id <HardwareNetworkMonitorDelegate> delegate;
}

@property (nonatomic, assign) SCDynamicStoreRef dynStore;
@property (nonatomic, assign) CFRunLoopSourceRef rlSrc;

@property (nonatomic, retain) NSMutableDictionary *networkInterfaceStates;
@property (nonatomic, retain) NSString *previousIPCombined;

@property (retain) id <HardwareNetworkMonitorDelegate> delegate;

-(id)initWithDelegate:(id) theDelegate;
-(id)startObserving;
-(void)fireOnLaunch;
@end
