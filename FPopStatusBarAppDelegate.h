#import <Cocoa/Cocoa.h>
#import "HardwareNetworkMonitor.h"
#import "FPopConnectionStatusPoller.h"
#import "FPopStatusBarView.h"

#define FPopStatusBarAppDelege_POLL_INTERVAL 2.0

@interface FPopStatusBarAppDelegate : NSObject <NSApplicationDelegate, FPopConnectionStatusPollerDelegate, HardwareNetworkMonitorDelegate> {
    NSApplication *app;
    NSWindow *window;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    FPopConnectionStatusPoller *poller;
    HardwareNetworkMonitor *networkMonitor;
    FPopStatusBarView *statusView;
}

@property (assign) IBOutlet NSWindow *window;


-(void) connectionStatusUpdated:(FPopConnectionStatus *)status;

-(void) ethernetConnected:(NSString *)interfaceName description:(NSString *)description;
-(void) ethernetDisconnected: (NSString *)interfaceName;
-(void) wifiConnected:(NSString *)networkName;
-(void) wifiDisconnected:(NSString *)networkName;
-(void) ipAddressUpdated:(NSString *)ipAddress;

@end
