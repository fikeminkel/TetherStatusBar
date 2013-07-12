#import "TestPreferencesViewController.h"
#import "PreferencesController.h"

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
    [[NSUserDefaults standardUserDefaults] setObject:[ssidField stringValue] forKey:TEST_PREFS_SSID];
    return YES;
}

@end
