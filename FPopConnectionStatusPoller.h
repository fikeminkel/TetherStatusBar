#import <Foundation/Foundation.h>
#import "TetherApiPoller.h"
#import "TetherStatusPoller.h"

@interface FPopConnectionStatusPoller : TetherApiPoller;

-(FPopConnectionStatusPoller *) initWithDelegate:(id <TetherStatusPollerDelegate>) theDelegate
                                          status:(TetherStatus*) theStatus;
-(void) updateStatus:(NSDictionary *) data;
-(int) calcSignalLevel:(int) level;

@end


