#import "FPopConnectionStatus.h"

@implementation FPopConnectionStatus

@synthesize signal;
@synthesize uptime;
@synthesize signalStr;
@synthesize status;
@synthesize ipAddress;

static NSArray *FPopConnectionStatusSignalTypeArray = [[NSArray alloc] initWithObjects:kFPopConnectionStatusSignalTypeNamesArray];

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

+(FPopConnectionStatus *) FPopConnectionStatusWithData:(NSDictionary *)data {
    FPopConnectionStatus *status = [[[FPopConnectionStatus alloc] init] autorelease];
    status.status = [data valueForKey:@"ID_WIMAX_STATUS"];
    NSString* cinr = (NSString *)[data valueForKey:@"ID_WIMAX_CINR"];
    status.signalStr = [NSString stringWithFormat:@"RSSI:%@, CINR:%@",
                        (NSString *)[data valueForKey:@"ID_WIMAX_RSSI"],
                        cinr];
    status.uptime = (NSString *)[data valueForKey:@"ID_WIMAX_CONN_TIME"];
    status.ipAddress = (NSString *)[data valueForKey:@"ID_WIMAX_IP_ADDR"];
    
//    NSLog(@"Current Signal Strength %@", cinr);
    if ([cinr isEqualToString: @"N/A"]) {
        status.signal = @"disconnected";
    } else {
        NSUInteger signalInt = [cinr intValue];
        signalInt = (int) signalInt/6;
//        NSLog(@"Current converted strength: %d", (int) signalInt);
        status.signal = [FPopConnectionStatus stringFromSignalType:(FPopConnectionStatusSignalType) signalInt];
    }
//    NSLog(@"Converted Signal Strength %@", status.signal);
    
    return status;
}

@end
