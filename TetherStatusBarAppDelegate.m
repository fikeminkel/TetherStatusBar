#import "TetherStatusUtils.h"
#import "HardwareNetworkMonitor.h"
#import "TestHardwareNetworkMonitor.h"

#import "TetherStatusBarAppDelegate.h"

#import "VerizonStatusPoller.h"
#import "FPopStatusPoller.h"
#import "FPopTestConnectionStatusPoller.h"
#import "TetherStatus.h"
#import "TetherStatusView.h"

#import "MASPreferencesWindowController.h"
#import "GeneralPreferencesViewController.h"
@implementation TetherStatusBarAppDelegate

-(void) loadUserDefaults
{
    NSString *defaultsPath = [[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"];
    NSDictionary *defaultsDict = [NSDictionary dictionaryWithContentsOfFile:defaultsPath];
    DLog(@"%@", defaultsDict);
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDict];
}


-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    app = (NSApplication *)aNotification.object;

#ifdef SIMULATE_NETWORK
    networkMonitor = [[TestHardwareNetworkMonitor alloc] initWithDelegate:self];
#endif
    
#ifndef SIMULATE_NETWORK
    networkMonitor = [[HardwareNetworkMonitor alloc] initWithDelegate:self];
#endif
    [self stopPolling];

    [networkMonitor startObserving];
    [networkMonitor fireOnLaunch];
}

-(void)applicationWillTerminate:(NSNotification *)notification {
    DLog(@"applicationWillTerminate");
    [statusPoller stopPolling];
    [statusPoller release];
    statusPoller = nil;


    [networkMonitor release];
    networkMonitor = nil;
    
    [lastStatus release];
    lastStatus = nil;
    
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
    [self loadUserDefaults];

    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    
    statusView = [[TetherStatusView alloc] init];
    statusView.statusItem = statusItem;
    [statusItem setView:statusView];
    [statusView setMenu:statusMenu];

    TetherStatus *disconnectedStatus = [TetherStatus disconnectedStatus];
    [statusView updateConnectionStatus:disconnectedStatus.signal networkType:disconnectedStatus.networkType];
    [statusView updateBatteryStatus:disconnectedStatus.batteryStatus level:disconnectedStatus.batteryLevel];

    prefsController = [[PreferencesController alloc] initWithDelegate:self];
    
    [self createStatusPoller:[prefsController deviceType]];
    [self showHideBatteryUsage:prefsController.showBatteryUsage];
}

-(IBAction)quitApplication:(id)sender
{
    DLog(@"quitApplication");
    [app terminate:self];
}

-(void) createStatusPoller:(NSString *)deviceType
{
    DLog(@"%@", deviceType);
    if ([deviceType isEqual:@"Verizon Wireless"]) {
        statusPoller = [[VerizonStatusPoller alloc] initWithDelegate:self];
    } else {
        statusPoller = [[FPopStatusPoller alloc] initWithDelegate:self];
    }
}

-(void) showHideBatteryUsage:(BOOL)show
{
    statusView.showBatteryImage = show;
}

-(IBAction)showPreferencesPanel:(id)sender
{
    [prefsController showPreferencesPanel:self];
}


-(void) stopPolling
{
    [statusPoller stopPolling];
    TetherStatus *disconnectedStatus = [TetherStatus disconnectedStatus];
    [statusView updateConnectionStatus:disconnectedStatus.signal networkType:disconnectedStatus.networkType];
    [statusView updateBatteryStatus:disconnectedStatus.batteryStatus level:disconnectedStatus.batteryLevel];
}

-(void) startPolling
{
    [statusPoller startPolling:TetherStatusBarAppDelege_POLL_INTERVAL];
}

#pragma mark -
#pragma mark TetherStatusPollerDelegate methods
-(void) statusUpdated:(TetherStatus *)status
{
    DLog(@"%@", status);
    NSString *statusTxt = [NSString stringWithFormat:@"Status:%@\nNetwork:%@\nSignal:%@\nUptime:%@\nIP Address:%@",
                           status.status,
                           status.networkType,
                           status.signalStr,
                           status.uptime,
                           status.ipAddress];
    if (!lastStatus || ![lastStatus.signal isEqual:status.signal]) {
        NSString *networkType = ([status.signal isEqualToString:@"disconnected"]) ? @"" : status.networkType;
        [statusView updateConnectionStatus:status.signal networkType:networkType];
        [statusView updateBatteryStatus:status.batteryStatus level:status.batteryLevel];
        [lastStatus release];
        lastStatus = [status retain];
    }
    [statusView setToolTip:statusTxt];
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

-(void) deviceTypeChanged:(NSString *)deviceType
{
    [self stopPolling];
    [statusPoller release];
    statusPoller = nil;
    
    [self createStatusPoller:deviceType];
    [self startPolling];
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
