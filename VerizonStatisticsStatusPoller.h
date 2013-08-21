#import "TetherApiPoller.h"
#import "TetherStatusPoller.h"

@interface VerizonStatisticsStatusPoller : TetherApiPoller

-(VerizonStatisticsStatusPoller *) initWithDelegate:(id <TetherStatusPollerDelegate>) theDelegate
                                             status:(TetherStatus*) theStatus;
-(void) updateStatus:(NSDictionary *) data;


@end
