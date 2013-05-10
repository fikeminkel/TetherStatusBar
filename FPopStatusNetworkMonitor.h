#import <SystemConfiguration/SystemConfiguration.h>
#import <Foundation/Foundation.h>

@protocol FPopStatusNetworkMonitorDelegate <NSObject>
@required
-(void) ipAddressUpdated:(NSString *)ipAddress;
-(void) ethernetConnected:(NSString *)interfaceName description:(NSString *)description;
-(void) ethernetDisconnected: (NSString *)interfaceName;
-(void) wifiConnected:(NSString *)networkName;
-(void) wifiDisconnected:(NSString *)networkName;
@end

@interface FPopStatusNetworkMonitor : NSObject {
    SCDynamicStoreRef dynStore;
    CFRunLoopSourceRef rlSrc;
    NSMutableDictionary *networkInterfaceStates;
    NSString *previousIPCombined;
    id <FPopStatusNetworkMonitorDelegate> delegate;
}

@property (nonatomic, assign) SCDynamicStoreRef dynStore;
@property (nonatomic, assign) CFRunLoopSourceRef rlSrc;

@property (nonatomic, retain) NSMutableDictionary *networkInterfaceStates;
@property (nonatomic, retain) NSString *previousIPCombined;

@property (retain) id <FPopStatusNetworkMonitorDelegate> delegate;

-(id)initWithDelegate:(id) theDelegate;
-(void)fireOnLaunch;
@end
