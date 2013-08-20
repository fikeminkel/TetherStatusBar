#import <Foundation/Foundation.h>

@interface FPopStatusPoller : NSObject <NSURLConnectionDelegate> {
    NSTimer* statusTimer;
    NSMutableData *responseData;
}

@property (retain) NSURL *statusURL;

-(void) startPolling:(NSTimeInterval)interval;
-(void) stopPolling;

@end
