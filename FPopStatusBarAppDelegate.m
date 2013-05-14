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
    [connectionPoller startPolling:FPopStatusBarAppDelege_POLL_INTERVAL];

    batteryPoller = [[[FPopTestBatteryStatusPoller alloc] initWithDelegate:self] retain];
    [batteryPoller startPolling:FPopStatusBarAppDelege_POLL_INTERVAL];
#endif
    
#ifndef SIMULATE_NETWORK
    connectionPoller = [[[FPopConnectionStatusPoller alloc] initWithDelegate:self] retain];
    batteryPoller = [[[FPopBatteryStatusPoller alloc] initWithDelegate:self] retain];
    networkMonitor = [[[HardwareNetworkMonitor alloc] initWithDelegate:self] retain];
    [networkMonitor fireOnLaunch];
#endif
}

-(void)applicationWillTerminate:(NSNotification *)notification {
    NSLog(@"applicationWillTerminate");
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
}

-(void)awakeFromNib
{
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setMenu:statusMenu];
    [statusItem setHighlightMode:YES];
        
    NSMenuItem *quitItem = [statusMenu itemAtIndex:0];
    [quitItem setAction:@selector(quitApplication)];
    
}

- (void) quitApplication
{
    NSLog(@"quitApplication");
    [app terminate:self];
}

-(void) clearStatus
{
    // TODO: [self statusUpdated: disconnected batteryStatus:unknown];
}

-(void) statusUpdated:(FPopConnectionStatus *)connectionStatus batteryStatus:(FPopBatteryStatus *)batteryStatus
{
    if (connectionStatus && batteryStatus) {
        [statusItem setView:nil];
        DLog(@"batteryStatus statusStr:%@", batteryStatus.statusStr);
        DLog(@"connectionStatus signal:%@", connectionStatus);
        
        FPopStatusBarView *statusView = [[FPopStatusBarView alloc] initWithFrame:NSMakeRect(0, 0, 32, 20) signal:connectionStatus.signal battery:batteryStatus.statusStr];
        [statusItem setView:statusView];
    }
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
        [self statusUpdated:connectionStatus batteryStatus:lastBatteryStatus];
        [lastConnectionStatus release];
        lastConnectionStatus = [connectionStatus retain];
    }
    [[statusItem view] setToolTip:statusTxt];
}

-(void) batteryStatusUpdated:(FPopBatteryStatus *)batteryStatus
{
    DLog(@"batteryStatus %@", batteryStatus);
    if (!lastBatteryStatus || ![lastBatteryStatus isEqual:batteryStatus]) {
        [self statusUpdated:lastConnectionStatus batteryStatus:batteryStatus];
        [lastBatteryStatus release];
        lastBatteryStatus = [batteryStatus retain];
    }
}

-(void) ethernetConnected:(NSString *)interfaceName description:(NSString *)description {
    NSLog(@"ethernetConnected:%@, %@", interfaceName, description);
}

-(void) ethernetDisconnected: (NSString *)interfaceName {
    NSLog(@"ethernetDisconnected:%@", interfaceName);
}

-(void) wifiConnected:(NSString *)networkName {
    NSLog(@"wifiConnected: %@", networkName);
    [connectionPoller startPolling:FPopStatusBarAppDelege_POLL_INTERVAL];
    [batteryPoller startPolling:FPopStatusBarAppDelege_POLL_INTERVAL];
}

-(void) wifiDisconnected:(NSString *)networkName {
    NSLog(@"wifiDisconnected: %@", networkName);
    [connectionPoller stopPolling];
    [batteryPoller stopPolling];
    [self clearStatus];
}

-(void) ipAddressUpdated:(NSString *)ipAddress {
    NSLog(@"ipAddressUpdated: %@", ipAddress);
}


@end
