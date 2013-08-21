#import "VerizonStatusPoller.h"

@implementation VerizonStatusPoller

-(VerizonStatusPoller *) initWithDelegate:(id<TetherStatusPollerDelegate>)theDelegate
{
    self = [super initWithDelegate:theDelegate];
    if (self) {
        //TODO finish this.  Possibly refactor common API poller code into TetherPoller
        indicatorsPoller = [[VerizonIndicatorsStatusPoller alloc] initWithDelegate:theDelegate status:status];
        statsPoller = [[VerizonStatisticsStatusPoller alloc] initWithDelegate:theDelegate status:status];
    }
    return self;
}

@end
