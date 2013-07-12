#import <Cocoa/Cocoa.h>
#import "HardwareNetworkMonitor.h"
#import "FPopConnectionStatusPoller.h"
#import "FPopBatteryStatusPoller.h"
#import "FPopStatusBarView.h"
#import "PreferencesController.h"

#define FPopStatusBarAppDelege_CONNECTION_POLL_INTERVAL 2.0
#define FPopStatusBarAppDelege_BATTERY_POLL_INTERVAL 30.0

@interface FPopStatusBarAppDelegate : NSObject <NSApplicationDelegate, FPopConnectionStatusPollerDelegate, FPopBatteryStatusPollerDelegate, HardwareNetworkMonitorDelegate, PreferencesControllerDelegate> {
    NSApplication *app;
    NSStatusItem *statusItem;
    IBOutlet NSMenu *statusMenu;
    PreferencesController *prefsController;

    FPopStatusBarView *statusView;
    FPopConnectionStatusPoller *connectionPoller;
    FPopConnectionStatus *lastConnectionStatus;
    FPopBatteryStatusPoller *batteryPoller;
    FPopBatteryStatus *lastBatteryStatus;
    HardwareNetworkMonitor *networkMonitor;
    
    NSString *currentSSID;
}

-(IBAction)showPreferencesPanel:(id)sender;
-(IBAction)quitApplication:(id)sender;
//-(IBAction)showHideBatteryUsageAction:(id)sender;


-(void) connectionStatusUpdated:(FPopConnectionStatus *)status;
-(void) batteryStatusUpdated:(FPopBatteryStatus *)status;

-(void) ethernetConnected:(NSString *)interfaceName description:(NSString *)description;
-(void) ethernetDisconnected: (NSString *)interfaceName;
-(void) wifiConnected:(NSString *)networkName;
-(void) wifiDisconnected:(NSString *)networkName;
-(void) ipAddressUpdated:(NSString *)ipAddress;

@end
