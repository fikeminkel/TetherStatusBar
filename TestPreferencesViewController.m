#import "TestPreferencesViewController.h"
#import "PreferencesController.h"
#import "TetherStatusUtils.h"

@implementation TestPreferencesViewController

@synthesize prefsController = _prefsController;

-(id) initWithPrefsController:(PreferencesController *)prefsController
{
    self = [self initWithNibName:@"TestPreferencesViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _prefsController = prefsController;
    }
    return self;
}

-(void) viewWillAppear
{
    DLog(@"TestPreferencesViewController viewWillAppear");
}

-(NSString *) identifier
{
    return @"Test";
}

-(NSImage *) toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

-(NSString *) toolbarItemLabel
{
    return @"Test";
}

-(BOOL) commitEditing
{
    DLog(@"TestPreferencesViewController commitEditing: %@", [ssidField stringValue]);
    [[NSUserDefaults standardUserDefaults] setObject:[ssidField stringValue] forKey:TEST_PREFS_SSID];
    return YES;
}

@end
