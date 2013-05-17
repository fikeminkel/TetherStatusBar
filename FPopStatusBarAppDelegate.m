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

@implementation FPopStatusBarAppDelegate

@synthesize window;

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    app = (NSApplication *)aNotification.object;
    [self clearStatus];
    
#ifdef SIMULATE_NETWORK
    connectionPoller = [[[FPopTestConnectionStatusPoller alloc] initWithDelegate:self] retain];
    [connectionPoller startPolling:FPopStatusBarAppDelege_CONNECTION_POLL_INTERVAL];

    batteryPoller = [[[FPopTestBatteryStatusPoller alloc] initWithDelegate:self] retain];
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
    
    [showBatteryUsageItem release];
    showBatteryUsageItem = nil;
    
    [statusItem release];
    statusItem = nil;
}

-(void)awakeFromNib
{
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    //[statusItem setMenu:statusMenu];
    [statusItem setHighlightMode:YES];
    
    showBatteryUsageItem = [[statusMenu itemAtIndex:0] retain];
    [showBatteryUsageItem setState:NSOnState];
    [showBatteryUsageItem setAction:@selector(showHideBatteryUsage)];
    
    NSMenuItem *quitItem = [statusMenu itemAtIndex:1];
    [quitItem setAction:@selector(quitApplication)];
    
    statusView = [[[FPopStatusBarView alloc] init] retain];
    statusView.statusItem = statusItem;
    [statusItem setView:statusView];
    [statusView setMenu:statusMenu];
    [statusView updateConnectionStatus:[FPopConnectionStatus disconnectedStatus].signal];
    [statusView updateBatteryStatus:[FPopBatteryStatus unknownStatus].statusStr];
}

- (void) quitApplication
{
    DLog(@"quitApplication");
    [app terminate:self];
}

-(void) showHideBatteryUsage
{
    NSInteger currentState = [showBatteryUsageItem state];
    if (currentState == NSOffState) {
        [showBatteryUsageItem setState:NSOnState];
        statusView.showBatteryImage = YES;
        [batteryPoller startPolling:FPopStatusBarAppDelege_BATTERY_POLL_INTERVAL];
    } else {
        [showBatteryUsageItem setState:NSOffState];
        statusView.showBatteryImage = NO;
        [batteryPoller stopPolling];
    }
}


-(void) clearStatus
{
    [statusView updateBatteryStatus:[FPopBatteryStatus unknownStatus].statusStr];
    [statusView updateConnectionStatus:[FPopConnectionStatus disconnectedStatus].signal];
}

-(void) connectionStatusUpdated:(FPopConnectionStatus *)connectionStatus
{
    DLog(@"connectionStatus: %@", connectionStatus);
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

-(void) batteryStatusUpdated:(FPopBatteryStatus *)batteryStatus
{
    DLog(@"batteryStatus %@", batteryStatus);
    if (!lastBatteryStatus || ![lastBatteryStatus isEqual:batteryStatus]) {
        [statusView updateBatteryStatus:batteryStatus.statusStr];
        [lastBatteryStatus release];
        lastBatteryStatus = [batteryStatus retain];
    }
}

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
