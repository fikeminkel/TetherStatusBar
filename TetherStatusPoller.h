#import <Foundation/Foundation.h>
#import "TetherStatus.h"
#import "TetherStatusPoller.h"

@protocol TetherStatusPollerDelegate <NSObject>
@required
- (void) statusUpdated:(TetherStatus *)status;
@end

@interface TetherStatusPoller : NSObject {
    id <TetherStatusPollerDelegate> delegate;
    TetherStatus *status;
}

@property (retain) id <TetherStatusPollerDelegate> delegate;
@property (retain) TetherStatus *status;

-(TetherStatusPoller *) initWithDelegate:(id <TetherStatusPollerDelegate>) theDelegate;
-(void) startPolling:(NSTimeInterval)interval;
-(void) stopPolling;

@end


