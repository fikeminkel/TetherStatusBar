#import "HardwareNetworkMonitor.h"

#import "FPopStatusBarAppDelegate.h"
#import "FPopConnectionStatusPoller.h"
#import "FPopTestConnectionStatusPoller.h"
#import "FPopConnectionStatus.h"
#import "FPopStatusBarView.h"

//#define SIMULATE_NETWORK 1

@implementation FPopStatusBarAppDelegate

@synthesize window;

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"applicationDidFinishLaunching");
    app = (NSApplication *)aNotification.object;

    statusView = [[FPopStatusBarView alloc] initWithFrame:NSZeroRect];
    
    [self clearStatus];
#ifdef SIMULATE_NETWORK
    poller = [[[FPopTestConnectionStatusPoller alloc] initWithDelegate:self] retain];
    [poller pollStatus:2.0];
#endif
    
#ifndef SIMULATE_NETWORK
    poller = [[[FPopConnectionStatusPoller alloc] initWithDelegate:self] retain];
    networkMonitor = [[[HardwareNetworkMonitor alloc] initWithDelegate:self] retain];
    [networkMonitor fireOnLaunch];
#endif
}

-(void)applicationWillTerminate:(NSNotification *)notification {
    NSLog(@"applicationWillTerminate");
    [poller stopPolling];
    [poller release];
    poller = nil;
    
    [networkMonitor release];
    networkMonitor = nil;
    
    [statusView release];
    statusView = nil;
}

-(void)awakeFromNib
{
    NSLog(@"awakeFromNib");
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setMenu:statusMenu];
    [statusItem setHighlightMode:YES];
    
    statusView = [[[FPopStatusBarView alloc] initWithFrame:NSMakeRect(0, 0, 40, 20)] retain];

    [statusItem setView:statusView];
    
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
    [statusView setToolTip:@""];
}

-(void) connectionStatusUpdated:(FPopConnectionStatus *)status
{
    NSLog(@"connectionStatusUpdated %@", status);

    [statusItem setView:nil];
    [statusView release];
    // TODO add battery poller
    statusView = [[[FPopStatusBarView alloc] initWithFrame:NSMakeRect(0, 0, 40, 20) signal:status.signal battery:@"battery"] retain];
    NSString *statusTxt = [NSString stringWithFormat:@"Status:%@\nSignal:%@\nUptime:%@\nIP Address:%@",
                           status.status,
                           status.signalStr,
                           status.uptime,
                           status.ipAddress];
    [statusView setToolTip:statusTxt];
    [statusItem setView:statusView];
}

-(void) ethernetConnected:(NSString *)interfaceName description:(NSString *)description {
    NSLog(@"ethernetConnected:%@, %@", interfaceName, description);
}

-(void) ethernetDisconnected: (NSString *)interfaceName {
    NSLog(@"ethernetDisconnected:%@", interfaceName);
}

-(void) wifiConnected:(NSString *)networkName {
    NSLog(@"wifiConnected: %@", networkName);
    [poller pollStatus:FPopStatusBarAppDelege_POLL_INTERVAL];
}

-(void) wifiDisconnected:(NSString *)networkName {
    NSLog(@"wifiDisconnected: %@", networkName);
    [poller stopPolling];
    [self clearStatus];
}

-(void) ipAddressUpdated:(NSString *)ipAddress {
    NSLog(@"ipAddressUpdated: %@", ipAddress);
}


@end
