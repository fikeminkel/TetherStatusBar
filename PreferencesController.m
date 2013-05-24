#import "PreferencesController.h"
#import "GeneralPreferencesViewController.h"
#import "MASPreferencesWindowController.h"
#import "FPopStatusUtils.h"

@implementation PreferencesController

@synthesize showBatteryUsage = _showBatteryUsage;
@synthesize showSignalStrength = _showSignalStrength;
@synthesize ssid = _ssid;
@synthesize delegate = _delegate;

-(id) initWithDelegate:(id<PreferencesControllerDelegate>)delegate {
    self = [super init];
    if (self) {
        userDefaults = [[NSUserDefaults standardUserDefaults] retain];
        [userDefaults addObserver:self forKeyPath:GENERAL_PREFS_SHOW_BATTERY_USAGE options:NSKeyValueObservingOptionNew context:NULL];
        [userDefaults addObserver:self forKeyPath:GENERAL_PREFS_SHOW_SIGNAL_STRENGTH options:NSKeyValueObservingOptionNew context:NULL];
        [userDefaults addObserver:self forKeyPath:GENERAL_PREFS_DEVICE_SSID options:NSKeyValueObservingOptionNew context:NULL];
        self.delegate = delegate;
    }
    return self;
}

-(void)showPreferencesPanel:(id)sender {
    if (!preferencesWindow) {
        GeneralPreferencesViewController *generalViewController = [[GeneralPreferencesViewController alloc] initWithPrefsController:self];
        NSArray *views = [NSArray arrayWithObjects:generalViewController, nil];
        preferencesWindow = [[MASPreferencesWindowController alloc] initWithViewControllers:views title:@"Preferences"];
        preferencesWindow.window.level = NSModalPanelWindowLevel;
    }
    [preferencesWindow showWindow:self];
}

-(BOOL) showBatteryUsage
{
    return [userDefaults boolForKey:GENERAL_PREFS_SHOW_BATTERY_USAGE];
}

-(void) setShowBatteryUsage:(BOOL)showBatteryUsage
{
    [userDefaults setBool:showBatteryUsage forKey:GENERAL_PREFS_SHOW_BATTERY_USAGE];
}

-(BOOL) showSignalStrength
{
    return [userDefaults boolForKey:GENERAL_PREFS_SHOW_SIGNAL_STRENGTH];
}

-(void) setShowSignalStrength:(BOOL)showSignalStrength
{
    [userDefaults setBool:showSignalStrength forKey:GENERAL_PREFS_SHOW_SIGNAL_STRENGTH];
}

-(NSString *)ssid
{
    return [userDefaults stringForKey:GENERAL_PREFS_DEVICE_SSID];
}

-(void) setSsid:(NSString *)ssid
{
    [userDefaults setValue:ssid forKey:GENERAL_PREFS_DEVICE_SSID];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DLog(@"keyPath: %@", keyPath);
    if ([keyPath isEqual:GENERAL_PREFS_SHOW_SIGNAL_STRENGTH]) {
        [_delegate showSignalStrengthChanged:self.showSignalStrength];
    }
    if ([keyPath isEqual:GENERAL_PREFS_SHOW_BATTERY_USAGE]) {
        [_delegate showBatteryUsageChanged:self.showBatteryUsage];
    }
    if ([keyPath isEqual:GENERAL_PREFS_DEVICE_SSID]) {
        [_delegate deviceSSIDChanged:self.ssid];
    }
}

-(void)dealloc
{
    [_ssid release];
    _ssid = nil;
    [userDefaults release];
    userDefaults = nil;
    
    [preferencesWindow release];
    preferencesWindow = nil;
    
    [super dealloc];
}

@end
