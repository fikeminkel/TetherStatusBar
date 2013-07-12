#import <Cocoa/Cocoa.h>
#import "PreferencesController.h"

@interface TestPreferencesViewController : NSViewController
{
    PreferencesController *_prefsController;
    IBOutlet NSTextField *ssidField;
}

@property (retain) PreferencesController *prefsController;

-(id) initWithPrefsController:(PreferencesController *) prefsController;
@end
