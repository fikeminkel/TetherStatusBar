#import "GeneralPreferencesViewController.h"
#import "FPopStatusUtils.h"

@implementation GeneralPreferencesViewController

@synthesize prefsController = _prefsController;
@synthesize batteryUsageButton;
@synthesize signalStrengthButton;

-(id) initWithPrefsController:(PreferencesController *) prefsController {
    self = [self initWithNibName:@"GeneralPreferencesViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _prefsController = prefsController;
    }
    return self;
}

// TODO: only fires the first time the MASPreferencesWindow is displayed
// .state needs to be updated every time it's reopened
-(void) viewWillAppear
{
    DLog(@"prefsController %@", _prefsController);
    batteryUsageButton.state = _prefsController.showBatteryUsage;
    signalStrengthButton.state = _prefsController.showSignalStrength;
}

-(NSString *) identifier
{
    return @"General";
}

-(NSImage *) toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

-(NSString *) toolbarItemLabel
{
    return @"General";
}

//-(IBAction)showHideBatteryUsage:(id)sender
//{
//    NSInteger state = ((NSButton *) sender).state;
//    DLog(@"button state:%ld", (long)state);
//    _prefsController.showBatteryUsage = state;
//}
//
//-(IBAction)showHideSignalStrength:(id)sender
//{
//    NSInteger state = ((NSButton *) sender).state;
//    DLog(@"button state:%ld", (long)state);
//    _prefsController.showSignalStrength = state;
//}

-(void) dealloc
{
    [_prefsController release];
    _prefsController = nil;
    
    [super dealloc];
}
@end
