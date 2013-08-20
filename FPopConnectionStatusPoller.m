#import "FPopConnectionStatusPoller.h"
#import "FPopConnectionStatus.h"

@implementation FPopConnectionStatusPoller

-(FPopConnectionStatusPoller *) initWithDelegate:(id<TetherConnectionStatusPollerDelegate>)theDelegate
{
    self = [super initWithDelegate:theDelegate];
    if (self) {
        self.statusURL = [NSURL URLWithString:@"http://192.168.1.1/cgi-bin/webmain.cgi?act=act_summary"];
    }
    return self;
}

-(void) updateStatus:(NSDictionary *) data
{
    [delegate connectionStatusUpdated:[FPopConnectionStatus statusWithData:data]];
}


@end
