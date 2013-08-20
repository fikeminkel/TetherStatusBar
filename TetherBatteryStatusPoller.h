#import <Foundation/Foundation.h>
#import "TetherBatteryStatus.h"
#import "TetherStatusPoller.h"


@protocol TetherBatteryStatusPollerDelegate <NSObject>
@required
- (void) batteryStatusUpdated:(TetherBatteryStatus *)status;
@end

@interface TetherBatteryStatusPoller : TetherStatusPoller {
    id <TetherBatteryStatusPollerDelegate> delegate;
}
@property (retain) id <TetherBatteryStatusPollerDelegate> delegate;

-(TetherBatteryStatusPoller *) initWithDelegate:(id <TetherBatteryStatusPollerDelegate>) theDelegate;


@end

