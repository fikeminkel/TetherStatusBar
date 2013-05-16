#import "FPopConnectionStatus.h"

@implementation FPopConnectionStatus

@synthesize signal;
@synthesize uptime;
@synthesize signalStr;
@synthesize status;
@synthesize ipAddress;

static NSArray *FPopConnectionStatusSignalTypeArray = [[NSArray alloc] initWithObjects:kFPopConnectionStatusSignalTypeNamesArray];
static NSDictionary *disconnectedData = [NSDictionary dictionaryWithObjectsAndKeys:@"N/A", @"ID_WIMAX_CINR", @"UNKNOWN", @"ID_WIMAX_STATUS", @"N/A", @"ID_WIMAX_RSSI", @"0", @"ID_WIMAX_CONN_TIME", @"0.0.0.0", @"ID_WIMAX_IP_ADDR", nil];

static NSArray *signalLevels = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:6],
                                [NSNumber numberWithInt:12],
                                [NSNumber numberWithInt:18],
                                [NSNumber numberWithInt:23], nil];

+(NSString *) stringFromSignalType:(FPopConnectionStatusSignalType) type
{
    return [FPopConnectionStatusSignalTypeArray objectAtIndex:type];
}

+(FPopConnectionStatusSignalType) signalTypeFromString:(NSString *) s {
    NSUInteger n = [FPopConnectionStatusSignalTypeArray indexOfObject:s];
    check (n != NSNotFound);
    if (n == NSNotFound) {
        n = kFPopConnectionStatusSignalType_DEFAULT;
    }
    return (FPopConnectionStatusSignalType) n;
}

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
        status.signal = [FPopConnectionStatus stringFromSignalType:(FPopConnectionStatusSignalType) signalInt];
    }    
    return status;
}

+(FPopConnectionStatus *) disconnectedStatus
{
    return [FPopConnectionStatus statusWithData:disconnectedData];
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"FPopConnectionStatus: { status: %@, signalStr: %@, uptime: %@, signal: %@, ipAddress: %@}", status, signalStr, uptime, signal, ipAddress];
}

@end
