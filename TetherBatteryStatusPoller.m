#import "TetherBatteryStatusPoller.h"

@implementation TetherBatteryStatusPoller

@synthesize delegate;

-(TetherBatteryStatusPoller *) initWithDelegate:(id<TetherBatteryStatusPollerDelegate>)theDelegate
{
    self = [self init];
    if (self) {
        self.delegate = theDelegate;
    }
    return self;
}

@end
