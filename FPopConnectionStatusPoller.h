#import <Foundation/Foundation.h>
#import "TetherConnectionStatusPoller.h"

@interface FPopConnectionStatusPoller : TetherConnectionStatusPoller

-(FPopConnectionStatusPoller *) initWithDelegate:(id <TetherConnectionStatusPollerDelegate>) theDelegate;
-(void) updateStatus:(NSDictionary *) data;

@end


