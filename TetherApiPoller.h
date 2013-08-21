#import <Foundation/Foundation.h>
#import "TetherStatusPoller.h"

@interface TetherApiPoller : NSObject <NSURLConnectionDelegate> {
    NSTimer* statusTimer;
    NSMutableData *responseData;
    id <TetherStatusPollerDelegate> delegate;
    TetherStatus *status;
}

@property (retain) NSURL *statusURL;
@property (retain) id<TetherStatusPollerDelegate> delegate;
@property (retain) TetherStatus *status;

-(TetherApiPoller *) initWithDelegate:(id <TetherStatusPollerDelegate>) theDelegate
                               status:(TetherStatus*) theStatus;

-(void) startPolling:(NSTimeInterval)interval;
-(void) stopPolling;

@end
