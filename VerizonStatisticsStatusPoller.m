#import "VerizonStatisticsStatusPoller.h"

@implementation VerizonStatisticsStatusPoller

-(VerizonStatisticsStatusPoller *) initWithDelegate:(id <TetherStatusPollerDelegate>) theDelegate
                                             status:(TetherStatus*) theStatus
{
    self = [super initWithDelegate:theDelegate status:theStatus];
    if (self) {
        self.statusURL = [NSURL URLWithString:@"http://192.168.1.1/v1/statistics"];
    }
    return self;
}
-(void) updateStatus:(NSDictionary *) data
{
    status.uptime = [data valueForKey:@"duration"];
    status.ipAddress = [data valueForKey:@"IPv4Address"];
    NSString *txRate = [(NSDictionary *)[data valueForKey:@"TX"] valueForKey:@"rate"];
    NSString *rxRate = [(NSDictionary *)[data valueForKey:@"TX"] valueForKey:@"rate"];
    status.signalStr = [NSString stringWithFormat:@"TX: %@ RX: %@", txRate, rxRate];
    [self statusUpdated];
}

@end
