#import "TestHardwareNetworkMonitor.h"
#import "TetherStatusUtils.h"
#import "PreferencesController.h"

@implementation TestHardwareNetworkMonitor

@synthesize delegate = _delegate;

-(id)initWithDelegate:(id) theDelegate
{
    self = [super init];
    if (self) {
        self.delegate = theDelegate;
        userDefaults = [[NSUserDefaults standardUserDefaults] retain];
    }
    return self;
}

-(id) startObserving
{
    [userDefaults addObserver:self forKeyPath:TEST_PREFS_SSID options:NSKeyValueObservingOptionNew context:NULL];
    [userDefaults addObserver:self forKeyPath:TEST_PREFS_WIRELESS_CONNECTED options:NSKeyValueObservingOptionNew context:NULL];
    return self;
}

-(void) fireOnLaunch
{
    [self observeValueForKeyPath:TEST_PREFS_WIRELESS_CONNECTED ofObject:nil change:nil context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    BOOL wirelessConnected = [userDefaults boolForKey:TEST_PREFS_WIRELESS_CONNECTED];
    NSString *ssid = [userDefaults stringForKey:TEST_PREFS_SSID];
    
    DLog(@"keyPath: %@", keyPath);
    if ([keyPath isEqual:TEST_PREFS_SSID]) {
        if (wirelessConnected) {
            [_delegate wifiConnected:ssid];
        }
    }
    if ([keyPath isEqual:TEST_PREFS_WIRELESS_CONNECTED]) {
        if (wirelessConnected) {
            [_delegate wifiConnected:ssid];
        } else {
            [_delegate wifiDisconnected:ssid];
        }
    }
}

-(void) dealloc
{
    [userDefaults release];
    userDefaults = nil;
    
    [delegate release];
    delegate = nil;
    
    [super dealloc];
}

@end
