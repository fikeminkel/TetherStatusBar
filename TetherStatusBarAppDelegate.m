#import "TetherStatusUtils.h"
#import "HardwareNetworkMonitor.h"
#import "TestHardwareNetworkMonitor.h"

#import "TetherStatusBarAppDelegate.h"
#import "FPopBatteryStatusPoller.h"
#import "FPopTestBatteryStatusPoller.h"
#import "FPopBatteryStatus.h"

#import "FPopConnectionStatusPoller.h"
#import "FPopTestConnectionStatusPoller.h"
#import "FPopConnectionStatus.h"
#import "TetherStatusView.h"

#import "MASPreferencesWindowController.h"
#import "GeneralPreferencesViewController.h"
@implementation TetherStatusBarAppDelegate

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    app = (NSApplication *)aNotification.object;

#ifdef SIMULATE_NETWORK
    connectionPoller = [[FPopTestConnectionStatusPoller alloc] initWithDelegate:self];
    batteryPoller = [[FPopTestBatteryStatusPoller alloc] initWithDelegate:self];
    networkMonitor = [[TestHardwareNetworkMonitor alloc] initWithDelegate:self];
#endif
    
#ifndef SIMULATE_NETWORK
    connectionPoller = [[FPopConnectionStatusPoller alloc] initWithDelegate:self];
    batteryPoller = [[FPopBatteryStatusPoller alloc] initWithDelegate:self];
    networkMonitor = [[HardwareNetworkMonitor alloc] initWithDelegate:self];
#endif
    [self stopPolling];

    [networkMonitor startObserving];
    [networkMonitor fireOnLaunch];
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
    
    [currentSSID release];
    currentSSID = nil;
    
    [statusView release];
    statusView = nil;
    
    [statusItem release];
    statusItem = nil;
    
    [prefsController release];
    prefsController = nil;
}

-(void)awakeFromNib
{
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    
    statusView = [[TetherStatusView alloc] init];
    statusView.statusItem = statusItem;
    [statusItem setView:statusView];
    [statusView setMenu:statusMenu];

    // TODO don't directly use FPopConnection/BatteryStatus
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


-(void) showHideBatteryUsage:(BOOL)show
{
    statusView.showBatteryImage = show;
    if (show) {
        [batteryPoller startPolling:FPopStatusBarAppDelege_BATTERY_POLL_INTERVAL];
    } else {
        [batteryPoller stopPolling];
    }
}

-(IBAction)showPreferencesPanel:(id)sender
{
    [prefsController showPreferencesPanel:self];
}


-(void) stopPolling
{
    [connectionPoller stopPolling];
    [batteryPoller stopPolling];

    // TODO don't directly use FPopConnection/BatteryStatus
    [statusView updateBatteryStatus:[FPopBatteryStatus unknownStatus].statusStr];
    [statusView updateConnectionStatus:[FPopConnectionStatus disconnectedStatus].signal];
}

-(void) startPolling
{
    [connectionPoller startPolling:FPopStatusBarAppDelege_CONNECTION_POLL_INTERVAL];
    [batteryPoller startPolling:FPopStatusBarAppDelege_BATTERY_POLL_INTERVAL];   
}

#pragma mark -
#pragma mark TetherConnectionStatusPollerDelegate methods
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
#pragma mark TetherBatteryStatusPollerDelegate methods
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
    DLog(@"ssid: %@, currentSSID: %@", ssid, currentSSID);
    if (currentSSID) {
        // if new pref setting is empty always poll
        if (!ssid || [ssid isEqual:currentSSID]) {
            [self startPolling];
        } else {
            [self stopPolling];
        }
    }
}

#pragma mark -
#pragma mark HardwareNetworkMonitorDelegate methods

-(void) ethernetConnected:(NSString *)interfaceName description:(NSString *)description {
    DLog(@"ethernetConnected:%@, %@", interfaceName, description);
}

-(void) ethernetDisconnected: (NSString *)interfaceName {
    DLog(@"ethernetDisconnected:%@", interfaceName);
}

-(void) wifiConnected:(NSString *)ssid {
    DLog(@"wifiConnected: %@", ssid);
    // this should handle if an ssid pref is set and the wifi network changes
    if (!currentSSID || ![ssid isEqual:currentSSID]) {
        [currentSSID release];
        currentSSID = [ssid retain];
        // if there isn't a preferred ssid, always poll
        if (!prefsController.ssid) {
            DLog(@"no preferred ssid, start polling");
            [self startPolling];
        } else if ([prefsController.ssid isEqual:currentSSID]) {
            DLog(@"'%@' matches '%@', start polling", ssid, prefsController.ssid);
            [self startPolling];
        } else {
            DLog(@"'%@' doesn't match '%@', stop polling", ssid, prefsController.ssid);
            [self stopPolling];
        }
    }
}

-(void) wifiDisconnected:(NSString *)ssid {
    DLog(@"wifiDisconnected: %@", ssid);
    [currentSSID release];
    currentSSID = nil;
    
    [self stopPolling];
}

-(void) ipAddressUpdated:(NSString *)ipAddress {
    DLog(@"ipAddressUpdated: %@", ipAddress);
}


@end
