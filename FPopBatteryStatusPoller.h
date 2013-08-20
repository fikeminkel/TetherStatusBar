#import <Foundation/Foundation.h>
#import "TetherBatteryStatusPoller.h"

@interface FPopBatteryStatusPoller : TetherBatteryStatusPoller

-(FPopBatteryStatusPoller *) initWithDelegate:(id <TetherBatteryStatusPollerDelegate>) theDelegate;
-(void) updateStatus:(NSDictionary *) data;

@end
