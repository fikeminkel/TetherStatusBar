#import <Foundation/Foundation.h>
#import "FPopStatusUtils.h"
#import "FPopStatusPoller.h"
#import "FPopBatteryStatus.h"

@protocol FPopBatteryStatusPollerDelegate <NSObject>
@required
- (void) batteryStatusUpdated:(FPopBatteryStatus *)status;
@end

@interface FPopBatteryStatusPoller : FPopStatusPoller {
    id <FPopBatteryStatusPollerDelegate> delegate;
}
@property (retain) id <FPopBatteryStatusPollerDelegate> delegate;

-(FPopBatteryStatusPoller *) initWithDelegate:(id <FPopBatteryStatusPollerDelegate>) theDelegate;
-(void) updateStatus:(NSDictionary *) data;

@end
