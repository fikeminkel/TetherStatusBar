#import "FPopBatteryStatusPoller.h"

@implementation FPopBatteryStatusPoller

@synthesize delegate;

-(FPopBatteryStatusPoller *) initWithDelegate:(id<FPopBatteryStatusPollerDelegate>)theDelegate
{
    self = [self init];
    if (self) {
        self.delegate = theDelegate;
        self.statusURL = [NSURL URLWithString:@"http://192.168.1.1/cgi-bin/webmain.cgi?act=act_battery_status&TYPE=BISCUIT"];
    }
    return self;
}
-(void) updateStatus:(NSDictionary *) data {
    [delegate batteryStatusUpdated:[FPopBatteryStatus FPopBatteryStatusWithData:data]];
}
@end
