#import <Foundation/Foundation.h>
#import "FPopStatus.h"

@protocol FPopStatusPollerDelegate <NSObject>
@required
- (void) statusUpdated:(FPopStatus *)status;
@end

@interface FPopStatusPoller : NSObject <NSURLConnectionDelegate> {
    id <FPopStatusPollerDelegate> delegate;
    NSTimer* statusTimer;
    NSMutableData *responseData;

}

@property (retain) id <FPopStatusPollerDelegate> delegate;

-(FPopStatusPoller *) initWithDelegate:(id <FPopStatusPollerDelegate>) theDelegate;
-(void) pollStatus:(NSTimeInterval)interval;
-(void) stopPolling;
@end


