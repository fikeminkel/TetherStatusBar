#import "TetherConnectionStatusPoller.h"

@implementation TetherConnectionStatusPoller

@synthesize delegate;

-(TetherConnectionStatusPoller *) initWithDelegate:(id<TetherConnectionStatusPollerDelegate>)theDelegate
{
    self = [self init];
    if (self) {
        self.delegate = theDelegate;
    }
    return self;
}

@end
