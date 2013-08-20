#import "TetherStatusPoller.h"
#import "FPopConnectionStatusPoller.h"
#import "FPopBatteryStatusPoller.h"

@interface FPopStatusPoller : TetherStatusPoller {
    FPopConnectionStatusPoller* connectionPoller;
    FPopBatteryStatusPoller* batteryPoller;
}

-(FPopStatusPoller *) initWithDelegate:(id <TetherStatusPollerDelegate>) theDelegate;

@end
