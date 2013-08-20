#import <Foundation/Foundation.h>
#import "TetherPoller.h"
#import "TetherStatusPoller.h"

@interface FPopConnectionStatusPoller : TetherPoller {
    id <TetherStatusPollerDelegate> delegate;
    TetherStatus *status;
}

-(FPopConnectionStatusPoller *) initWithDelegate:(id <TetherStatusPollerDelegate>) theDelegate
                                          status:(TetherStatus*) status;
-(void) updateStatus:(NSDictionary *) data;
-(int) calcSignalLevel:(int) level;

@end


