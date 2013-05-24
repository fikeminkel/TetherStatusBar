#import "GeneralPreferencesViewController.h"
#import "FPopStatusUtils.h"
#import "WifiNetworkInfo.h"

@implementation GeneralPreferencesViewController

@synthesize prefsController = _prefsController;

-(id) initWithPrefsController:(PreferencesController *) prefsController {
    self = [self initWithNibName:@"GeneralPreferencesViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _prefsController = prefsController;
    }
    return self;
}

-(void) viewWillAppear
{
    [ssidField addItemsWithObjectValues:[WifiNetworkInfo allKnownNetworks]];
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

-(BOOL) commitEditing
{
    _prefsController.ssid = [ssidField stringValue];
    return YES;
}

-(void) dealloc
{
    [_prefsController release];
    _prefsController = nil;
    
    [super dealloc];
}
@end
