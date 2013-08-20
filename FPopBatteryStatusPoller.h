#import <Foundation/Foundation.h>
#import "TetherPoller.h"
#import "TetherStatusPoller.h"
#import "TetherStatus.h"

@interface FPopBatteryStatusPoller : TetherPoller {
    id <TetherStatusPollerDelegate> delegate;
    TetherStatus *status;
}

-(FPopBatteryStatusPoller *) initWithDelegate:(id <TetherStatusPollerDelegate>) theDelegate
                                       status:(TetherStatus *) theStatus;
-(void) updateStatus:(NSDictionary *) data;

@end
