#import "FPopBatteryStatusPoller.h"
#import "FPopBatteryStatus.h"

@implementation FPopBatteryStatusPoller

-(FPopBatteryStatusPoller *) initWithDelegate:(id<TetherBatteryStatusPollerDelegate>)theDelegate
{
    self = [super initWithDelegate:theDelegate];
    if (self) {
        self.statusURL = [NSURL URLWithString:@"http://192.168.1.1/cgi-bin/webmain.cgi?act=act_battery_status&TYPE=BISCUIT"];
    }
    return self;
}
-(void) updateStatus:(NSDictionary *) data {
    [delegate batteryStatusUpdated:[FPopBatteryStatus statusWithData:data]];
}
@end
