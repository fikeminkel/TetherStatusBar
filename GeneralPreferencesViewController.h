#import <Cocoa/Cocoa.h>
#import "PreferencesController.h"
#import "MASPreferencesViewController.h"

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController>
{
    PreferencesController *_prefsController;
    IBOutlet NSButton *batteryUsageButton;
    IBOutlet NSButton *signalStrengthButton;
}

@property (retain) PreferencesController *prefsController;

@property (retain) IBOutlet NSButton *batteryUsageButton;
@property (retain) IBOutlet NSButton *signalStrengthButton;

-(id) initWithPrefsController:(PreferencesController *) prefsController;
//-(IBAction)showHideBatteryUsage:(id)sender;
//-(IBAction)showHideSignalStrength:(id)sender;

@end
