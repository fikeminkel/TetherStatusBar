#import <Cocoa/Cocoa.h>
#import "HardwareNetworkMonitor.h"
#import "FPopConnectionStatusPoller.h"
#import "FPopBatteryStatusPoller.h"
#import "FPopStatusBarView.h"

#define FPopStatusBarAppDelege_CONNECTION_POLL_INTERVAL 2.0
#define FPopStatusBarAppDelege_BATTERY_POLL_INTERVAL 30.0

@interface FPopStatusBarAppDelegate : NSObject <NSApplicationDelegate, FPopConnectionStatusPollerDelegate, FPopBatteryStatusPollerDelegate, HardwareNetworkMonitorDelegate> {
    NSApplication *app;
    NSWindow *window;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    FPopConnectionStatusPoller *connectionPoller;
    FPopConnectionStatus *lastConnectionStatus;
    FPopBatteryStatusPoller *batteryPoller;
    FPopBatteryStatus *lastBatteryStatus;
    HardwareNetworkMonitor *networkMonitor;
}

@property (assign) IBOutlet NSWindow *window;


-(void) connectionStatusUpdated:(FPopConnectionStatus *)status;
-(void) batteryStatusUpdated:(FPopBatteryStatus *)status;

-(void) ethernetConnected:(NSString *)interfaceName description:(NSString *)description;
-(void) ethernetDisconnected: (NSString *)interfaceName;
-(void) wifiConnected:(NSString *)networkName;
-(void) wifiDisconnected:(NSString *)networkName;
-(void) ipAddressUpdated:(NSString *)ipAddress;

@end
