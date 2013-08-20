#import <Foundation/Foundation.h>
#import "TetherConnectionStatus.h"
#import "TetherStatusPoller.h"

@protocol TetherConnectionStatusPollerDelegate <NSObject>
@required
- (void) connectionStatusUpdated:(TetherConnectionStatus *)status;
@end

@interface TetherConnectionStatusPoller : TetherStatusPoller {
    id <TetherConnectionStatusPollerDelegate> delegate;
}

@property (retain) id <TetherConnectionStatusPollerDelegate> delegate;

-(TetherConnectionStatusPoller *) initWithDelegate:(id <TetherConnectionStatusPollerDelegate>) theDelegate;

@end


