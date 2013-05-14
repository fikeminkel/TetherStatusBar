#import <Foundation/Foundation.h>
#import "FPopConnectionStatus.h"

@protocol FPopConnectionStatusPollerDelegate <NSObject>
@required
- (void) connectionStatusUpdated:(FPopConnectionStatus *)status;
@end

@interface FPopConnectionStatusPoller : NSObject <NSURLConnectionDelegate> {
    id <FPopConnectionStatusPollerDelegate> delegate;
    NSTimer* statusTimer;
    NSMutableData *responseData;

}

@property (retain) id <FPopConnectionStatusPollerDelegate> delegate;

-(FPopConnectionStatusPoller *) initWithDelegate:(id <FPopConnectionStatusPollerDelegate>) theDelegate;
-(void) pollStatus:(NSTimeInterval)interval;
-(void) stopPolling;
@end


