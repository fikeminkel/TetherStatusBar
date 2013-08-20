#import "FPopConnectionStatus.h"

@implementation FPopConnectionStatus

static FPopConnectionStatus* disconnected = [FPopConnectionStatus statusWithData:
    [NSDictionary dictionaryWithObjectsAndKeys:@"N/A", @"ID_WIMAX_CINR", @"UNKNOWN", @"ID_WIMAX_STATUS", @"N/A", @"ID_WIMAX_RSSI", @"0", @"ID_WIMAX_CONN_TIME", @"0.0.0.0", @"ID_WIMAX_IP_ADDR", nil]];

static NSArray *signalLevels = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:6],
                                [NSNumber numberWithInt:12],
                                [NSNumber numberWithInt:18],
                                [NSNumber numberWithInt:23], nil];

+ (int) calcSignalLevel:(int) level
{
    for (NSInteger i = 0; i < [signalLevels count]; i++) {
        if (level < [(NSNumber *) [signalLevels objectAtIndex:i] intValue]) {
            return i;
        }
    }
    return 4;
}

+(FPopConnectionStatus *) statusWithData:(NSDictionary *)data {
    FPopConnectionStatus *status = [[[FPopConnectionStatus alloc] init] autorelease];
    status.status = [data valueForKey:@"ID_WIMAX_STATUS"];
    NSString* cinr = (NSString *)[data valueForKey:@"ID_WIMAX_CINR"];
    status.signalStr = [NSString stringWithFormat:@"RSSI:%@, CINR:%@",
                        (NSString *)[data valueForKey:@"ID_WIMAX_RSSI"],
                        cinr];
    status.uptime = (NSString *)[data valueForKey:@"ID_WIMAX_CONN_TIME"];
    status.ipAddress = (NSString *)[data valueForKey:@"ID_WIMAX_IP_ADDR"];

    if (!cinr || [cinr isEqualToString: @"N/A"]) {
        status.signal = @"disconnected";
    } else {
        int signalInt = [self calcSignalLevel:[cinr intValue]];
        status.signal = [TetherConnectionStatus stringFromSignalType:(TetherConnectionStatusSignalType) signalInt];
    }    
    return status;
}

+(FPopConnectionStatus *) disconnectedStatus
{
    return disconnected;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"FPopConnectionStatus: { status: %@, signalStr: %@, uptime: %@, signal: %@, ipAddress: %@}", status, signalStr, uptime, signal, ipAddress];
}

@end
