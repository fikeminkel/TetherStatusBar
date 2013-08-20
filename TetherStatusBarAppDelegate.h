#import <Cocoa/Cocoa.h>
#import "HardwareNetworkMonitor.h"
#import "TetherStatusView.h"
#import "TetherStatusPoller.h"
#import "PreferencesController.h"

#define TetherStatusBarAppDelege_POLL_INTERVAL 2.0

@interface TetherStatusBarAppDelegate : NSObject <NSApplicationDelegate, TetherStatusPollerDelegate,
    HardwareNetworkMonitorDelegate, PreferencesControllerDelegate> {
    NSApplication *app;
    NSStatusItem *statusItem;
    IBOutlet NSMenu *statusMenu;
    PreferencesController *prefsController;

    TetherStatusView *statusView;
    TetherStatusPoller *statusPoller;
    TetherStatus *lastStatus;
    HardwareNetworkMonitor *networkMonitor;
    
    NSString *currentSSID;
}

-(IBAction)showPreferencesPanel:(id)sender;
-(IBAction)quitApplication:(id)sender;
//-(IBAction)showHideBatteryUsageAction:(id)sender;


-(void) statusUpdated:(TetherStatus *)status;

-(void) ethernetConnected:(NSString *)interfaceName description:(NSString *)description;
-(void) ethernetDisconnected: (NSString *)interfaceName;
-(void) wifiConnected:(NSString *)networkName;
-(void) wifiDisconnected:(NSString *)networkName;
-(void) ipAddressUpdated:(NSString *)ipAddress;

@end
