#import <Foundation/Foundation.h>
#import "TetherApiPoller.h"
#import "TetherStatusPoller.h"
#import "TetherStatus.h"

@interface FPopBatteryStatusPoller : TetherApiPoller

-(FPopBatteryStatusPoller *) initWithDelegate:(id <TetherStatusPollerDelegate>) theDelegate
                                       status:(TetherStatus *) theStatus;
-(void) updateStatus:(NSDictionary *) data;

@end
