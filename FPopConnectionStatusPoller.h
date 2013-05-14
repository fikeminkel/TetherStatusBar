#import <Foundation/Foundation.h>
#import "FPopStatusPoller.h"
#import "FPopConnectionStatus.h"

@protocol FPopConnectionStatusPollerDelegate <NSObject>
@required
- (void) connectionStatusUpdated:(FPopConnectionStatus *)status;
@end

@interface FPopConnectionStatusPoller : FPopStatusPoller {
    id <FPopConnectionStatusPollerDelegate> delegate;
}

@property (retain) id <FPopConnectionStatusPollerDelegate> delegate;

-(FPopConnectionStatusPoller *) initWithDelegate:(id <FPopConnectionStatusPollerDelegate>) theDelegate;
-(void) updateStatus:(NSDictionary *) data;

@end


