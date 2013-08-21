#import "TetherApiPoller.h"
#import "TetherStatusPoller.h"

@interface VerizonIndicatorsStatusPoller : TetherApiPoller

-(VerizonIndicatorsStatusPoller *) initWithDelegate:(id <TetherStatusPollerDelegate>) theDelegate
                                             status:(TetherStatus*) theStatus;
-(void) updateStatus:(NSDictionary *) data;

@end
