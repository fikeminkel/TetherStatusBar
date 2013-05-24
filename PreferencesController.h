#import <Foundation/Foundation.h>

#define GENERAL_PREFS_SHOW_BATTERY_USAGE @"showBatteryUsage"
#define GENERAL_PREFS_SHOW_SIGNAL_STRENGTH @"showSignalStrength"

// TODO: add protocol for notifying AppDelegate of prefs changes
@protocol PreferencesControllerDelegate
-(void) showBatteryUsageChanged:(BOOL)show;
-(void) showSignalStrengthChanged:(BOOL)show;
@end

@interface PreferencesController : NSObject
{
    BOOL _showBatteryUsage;
    BOOL _showSignalStrength;
    NSString *_ssid;
    id <PreferencesControllerDelegate> _delegate;
    
    NSUserDefaults *userDefaults;
    NSWindowController *preferencesWindow;
}

-(id)initWithDelegate:(id <PreferencesControllerDelegate>) delegate;
-(void)showPreferencesPanel:(id)sender;

@property (assign, nonatomic) BOOL showBatteryUsage;
@property (assign, nonatomic) BOOL showSignalStrength;
@property (retain) NSString *ssid;
@property (retain) id <PreferencesControllerDelegate> delegate;

@end
