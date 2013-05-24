#import "FPopStatusUtils.h"
#import "HardwareNetworkMonitor.h"

#import "FPopStatusBarAppDelegate.h"
#import "FPopBatteryStatusPoller.h"
#import "FPopTestBatteryStatusPoller.h"
#import "FPopBatteryStatus.h"

#import "FPopConnectionStatusPoller.h"
#import "FPopTestConnectionStatusPoller.h"
#import "FPopConnectionStatus.h"
#import "FPopStatusBarView.h"

#import "MASPreferencesWindowController.h"
#import "GeneralPreferencesViewController.h"

@implementation FPopStatusBarAppDelegate

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    app = (NSApplication *)aNotification.object;
    [self clearStatus];
    
#ifdef SIMULATE_NETWORK
    connectionPoller = [[FPopTestConnectionStatusPoller alloc] initWithDelegate:self];
    [connectionPoller startPolling:FPopStatusBarAppDelege_CONNECTION_POLL_INTERVAL];
    
    batteryPoller = [[FPopTestBatteryStatusPoller alloc] initWithDelegate:self];
    [batteryPoller startPolling:FPopStatusBarAppDelege_BATTERY_POLL_INTERVAL];
#endif
    
#ifndef SIMULATE_NETWORK
    connectionPoller = [[[FPopConnectionStatusPoller alloc] initWithDelegate:self] retain];
    batteryPoller = [[[FPopBatteryStatusPoller alloc] initWithDelegate:self] retain];
    networkMonitor = [[[HardwareNetworkMonitor alloc] initWithDelegate:self] retain];
    [networkMonitor fireOnLaunch];
#endif
}

-(void)applicationWillTerminate:(NSNotification *)notification {
    DLog(@"applicationWillTerminate");
    [connectionPoller stopPolling];
    [connectionPoller release];
    connectionPoller = nil;

    [batteryPoller stopPolling];
    [batteryPoller release];
    batteryPoller = nil;

    [networkMonitor release];
    networkMonitor = nil;

    [lastConnectionStatus release];
    lastConnectionStatus = nil;
    
    [lastBatteryStatus release];
    lastBatteryStatus = nil;
    
    [statusView release];
    statusView = nil;
    
//    [showBatteryUsageItem release];
//    showBatteryUsageItem = nil;
    
    [statusItem release];
    statusItem = nil;
    
    [prefsController release];
    prefsController = nil;
}

-(void)awakeFromNib
{
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    
    statusView = [[FPopStatusBarView alloc] init];
    statusView.statusItem = statusItem;
    [statusItem setView:statusView];
    [statusView setMenu:statusMenu];

    [statusView updateConnectionStatus:[FPopConnectionStatus disconnectedStatus].signal];
    [statusView updateBatteryStatus:[FPopBatteryStatus unknownStatus].statusStr];

    prefsController = [[PreferencesController alloc] initWithDelegate:self];
    [self showHideBatteryUsage:prefsController.showBatteryUsage];
}

-(IBAction)quitApplication:(id)sender
{
    DLog(@"quitApplication");
    [app terminate:self];
}

//-(IBAction)showHideBatteryUsageAction:(id)sender
//{
//    prefsController.showBatteryUsage = !prefsController.showBatteryUsage;
//    [self showHideBatteryUsage:prefsController.showBatteryUsage];
//}

-(void) showHideBatteryUsage:(BOOL)show
{
    if (show) {
//        [showBatteryUsageItem setState:NSOnState];
        statusView.showBatteryImage = YES;
        [batteryPoller startPolling:FPopStatusBarAppDelege_BATTERY_POLL_INTERVAL];
    } else {
//        [showBatteryUsageItem setState:NSOffState];
        statusView.showBatteryImage = NO;
        [batteryPoller stopPolling];
    }
}

-(IBAction)showPreferencesPanel:(id)sender
{
    [prefsController showPreferencesPanel:self];
}


-(void) clearStatus
{
    [statusView updateBatteryStatus:[FPopBatteryStatus unknownStatus].statusStr];
    [statusView updateConnectionStatus:[FPopConnectionStatus disconnectedStatus].signal];
}

#pragma mark -
#pragma mark FPopConnectionStatusPollerDelegate methods
-(void) connectionStatusUpdated:(FPopConnectionStatus *)connectionStatus
{
    NSString *statusTxt = [NSString stringWithFormat:@"Status:%@\nSignal:%@\nUptime:%@\nIP Address:%@",
                           connectionStatus.status,
                           connectionStatus.signalStr,
                           connectionStatus.uptime,
                           connectionStatus.ipAddress];    
    if (!lastConnectionStatus || ![lastConnectionStatus.signal isEqual:connectionStatus.signal]) {
        [statusView updateConnectionStatus:connectionStatus.signal];
        [lastConnectionStatus release];
        lastConnectionStatus = [connectionStatus retain];
    }
    [statusView setToolTip:statusTxt];
}

#pragma mark -
#pragma mark FPopBatteryStatusPollerDelegate methods
-(void) batteryStatusUpdated:(FPopBatteryStatus *)batteryStatus
{
    if (!lastBatteryStatus || ![lastBatteryStatus isEqual:batteryStatus]) {
        [statusView updateBatteryStatus:batteryStatus.statusStr];
        [lastBatteryStatus release];
        lastBatteryStatus = [batteryStatus retain];
    }
}



#pragma mark -
#pragma mark PreferencesControllerDelegate methods
-(void) showBatteryUsageChanged:(BOOL)show
{
    [self showHideBatteryUsage:show];
}

-(void) showSignalStrengthChanged:(BOOL)show
{

}

-(void) deviceSSIDChanged:(NSString *)ssid
{
    DLog(@"ssid: %@", ssid);
}

#pragma mark -
#pragma mark HardwareNetworkMonitorDelegate methods

-(void) ethernetConnected:(NSString *)interfaceName description:(NSString *)description {
    DLog(@"ethernetConnected:%@, %@", interfaceName, description);
}

-(void) ethernetDisconnected: (NSString *)interfaceName {
    DLog(@"ethernetDisconnected:%@", interfaceName);
}

-(void) wifiConnected:(NSString *)networkName {
    DLog(@"wifiConnected: %@", networkName);
    [connectionPoller startPolling:FPopStatusBarAppDelege_CONNECTION_POLL_INTERVAL];
    [batteryPoller startPolling:FPopStatusBarAppDelege_BATTERY_POLL_INTERVAL];
}

-(void) wifiDisconnected:(NSString *)networkName {
    DLog(@"wifiDisconnected: %@", networkName);
    [connectionPoller stopPolling];
    [batteryPoller stopPolling];
    [self clearStatus];
}

-(void) ipAddressUpdated:(NSString *)ipAddress {
    DLog(@"ipAddressUpdated: %@", ipAddress);
}


@end
