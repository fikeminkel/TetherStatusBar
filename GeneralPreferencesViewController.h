#import <Cocoa/Cocoa.h>
#import "PreferencesController.h"
#import "MASPreferencesViewController.h"

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController>
{
    PreferencesController *_prefsController;
    IBOutlet NSButton *batteryUsageButton;
    IBOutlet NSButton *signalStrengthButton;
    IBOutlet NSComboBox *ssidField;
}

@property (retain) PreferencesController *prefsController;

-(id) initWithPrefsController:(PreferencesController *) prefsController;

@end
