#import "FPopConnectionStatusPoller.h"
#import "FPopConnectionStatus.h"

@implementation FPopConnectionStatusPoller

@synthesize delegate;

-(FPopConnectionStatusPoller *) initWithDelegate:(id<FPopConnectionStatusPollerDelegate>)theDelegate
{
    self = [self init];
    if (self) {
        self.delegate = theDelegate;
        self.statusURL = [NSURL URLWithString:@"http://192.168.1.1/cgi-bin/webmain.cgi?act=act_summary"];
    }
    return self;
}

-(void) updateStatus:(NSDictionary *) data
{
    [delegate connectionStatusUpdated:[FPopConnectionStatus FPopConnectionStatusWithData:data]];
}


@end
