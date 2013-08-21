#import "TetherStatusPoller.h"
#import "VerizonIndicatorsStatusPoller.h"
#import "VerizonStatisticsStatusPoller.h"
@interface VerizonStatusPoller : TetherStatusPoller
{
    VerizonIndicatorsStatusPoller *indicatorsPoller;
    VerizonStatisticsStatusPoller *statsPoller;
}

-(VerizonStatusPoller *) initWithDelegate:(id <TetherStatusPollerDelegate>) theDelegate;

@end
