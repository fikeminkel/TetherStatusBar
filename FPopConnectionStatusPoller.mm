#import "FPopConnectionStatusPoller.h"
#import "TetherStatus.h"

@implementation FPopConnectionStatusPoller

static NSArray *signalLevels = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:6],
                                [NSNumber numberWithInt:12],
                                [NSNumber numberWithInt:18],
                                [NSNumber numberWithInt:23], nil];

-(FPopConnectionStatusPoller *) initWithDelegate:(id<TetherStatusPollerDelegate>)theDelegate
                                          status:(TetherStatus*) theStatus

{
    self = [super initWithDelegate:theDelegate status:theStatus];
    if (self) {
        self.statusURL = [NSURL URLWithString:@"http://192.168.1.1/cgi-bin/webmain.cgi?act=act_summary"];
    }
    return self;
}


- (int) calcSignalLevel:(int) level
{
    for (NSInteger i = 0; i < [signalLevels count]; i++) {
        if (level < [(NSNumber *) [signalLevels objectAtIndex:i] intValue]) {
            return i;
        }
    }
    return 4;
}

-(void) updateStatus:(NSDictionary *) data
{

    status.status = [data valueForKey:@"ID_WIMAX_STATUS"];
    NSString* cinr = (NSString *)[data valueForKey:@"ID_WIMAX_CINR"];
    status.signalStr = [NSString stringWithFormat:@"RSSI:%@, CINR:%@",
                        (NSString *)[data valueForKey:@"ID_WIMAX_RSSI"],
                        cinr];
    status.uptime = (NSString *)[data valueForKey:@"ID_WIMAX_CONN_TIME"];
    status.ipAddress = (NSString *)[data valueForKey:@"ID_WIMAX_IP_ADDR"];
    
    if (!cinr || [cinr isEqualToString: @"N/A"]) {
        status.signal = @"disconnected";
        status.networkType = NULL;
    } else {
        int signalInt = [self calcSignalLevel:[cinr intValue]];
        status.signal = [TetherStatus stringFromSignalType:(TetherConnectionStatusSignalType) signalInt];
        status.networkType = @"4G";
    }

    [self statusUpdated];
}

@end
