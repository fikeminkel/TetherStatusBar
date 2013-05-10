#import <Cocoa/Cocoa.h>
#import "FPopStatusPoller.h"
#import "FPopStatusNetworkMonitor.h"

#define FPopStatusBarAppDelege_POLL_INTERVAL 2.0

@interface FPopStatusBarAppDelegate : NSObject <NSApplicationDelegate, FPopStatusPollerDelegate, FPopStatusNetworkMonitorDelegate> {
    NSApplication *app;
    NSWindow *window;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    FPopStatusPoller *poller;
    FPopStatusNetworkMonitor *networkMonitor;
    
    NSMutableDictionary *statusImages;
    NSDictionary *currentConnectionData;
}

@property (assign) IBOutlet NSWindow *window;


-(void) statusUpdated:(FPopStatus *)status;

-(void) ethernetConnected:(NSString *)interfaceName description:(NSString *)description;
-(void) ethernetDisconnected: (NSString *)interfaceName;
-(void) wifiConnected:(NSString *)networkName;
-(void) wifiDisconnected:(NSString *)networkName;
-(void) ipAddressUpdated:(NSString *)ipAddress;

@end
