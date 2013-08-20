#import <Cocoa/Cocoa.h>
#import "HardwareNetworkMonitor.h"
#import "TetherStatusView.h"
#import "FPopConnectionStatusPoller.h"
#import "FPopBatteryStatusPoller.h"
#import "PreferencesController.h"

#define FPopStatusBarAppDelege_CONNECTION_POLL_INTERVAL 2.0
#define FPopStatusBarAppDelege_BATTERY_POLL_INTERVAL 30.0

@interface FPopStatusBarAppDelegate : NSObject <NSApplicationDelegate, TetherConnectionStatusPollerDelegate, TetherBatteryStatusPollerDelegate, HardwareNetworkMonitorDelegate, PreferencesControllerDelegate> {
    NSApplication *app;
    NSStatusItem *statusItem;
    IBOutlet NSMenu *statusMenu;
    PreferencesController *prefsController;

    TetherStatusView *statusView;
    TetherConnectionStatusPoller *connectionPoller;
    TetherConnectionStatus *lastConnectionStatus;
    TetherBatteryStatusPoller *batteryPoller;
    TetherBatteryStatus *lastBatteryStatus;
    HardwareNetworkMonitor *networkMonitor;
    
    NSString *currentSSID;
}

-(IBAction)showPreferencesPanel:(id)sender;
-(IBAction)quitApplication:(id)sender;
//-(IBAction)showHideBatteryUsageAction:(id)sender;


-(void) connectionStatusUpdated:(TetherConnectionStatus *)status;
-(void) batteryStatusUpdated:(TetherBatteryStatus *)status;

-(void) ethernetConnected:(NSString *)interfaceName description:(NSString *)description;
-(void) ethernetDisconnected: (NSString *)interfaceName;
-(void) wifiConnected:(NSString *)networkName;
-(void) wifiDisconnected:(NSString *)networkName;
-(void) ipAddressUpdated:(NSString *)ipAddress;

@end
