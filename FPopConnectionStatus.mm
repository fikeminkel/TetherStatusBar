//
//  FPopStatus.m
//  StatusBarApp
//
//  Created by Finkel, Mike on 5/8/13.
//
//

#import "FPopStatus.h"

@implementation FPopStatus

@synthesize signal;
@synthesize uptime;
@synthesize signalStr;
@synthesize connectionStatus;
@synthesize ipAddress;

static NSArray *FPopStatusSignalTypeArray = [[NSArray alloc] initWithObjects:kFPopStatusSignalTypeNamesArray];

+(NSString *) stringFromSignalType:(FPopStatusSignalType) type
{
    return [FPopStatusSignalTypeArray objectAtIndex:type];
}

+(FPopStatusSignalType) signalTypeFromString:(NSString *) s {
    NSUInteger n = [FPopStatusSignalTypeArray indexOfObject:s];
    check (n != NSNotFound);
    if (n == NSNotFound) {
        n = kFPopStatusSignalType_DEFAULT;
    }
    return (FPopStatusSignalType) n;
}

+(FPopStatus *) FPopStatusWithData:(NSDictionary *)data {
    FPopStatus *status = [[[FPopStatus alloc] init] autorelease];
    status.connectionStatus = [data valueForKey:@"ID_WIMAX_STATUS"];
    NSString* cinr = (NSString *)[data valueForKey:@"ID_WIMAX_CINR"];
    status.signalStr = [NSString stringWithFormat:@"RSSI:%@, CINR:%@",
                        (NSString *)[data valueForKey:@"ID_WIMAX_RSSI"],
                        cinr];
    status.uptime = (NSString *)[data valueForKey:@"ID_WIMAX_CONN_TIME"];
    status.ipAddress = (NSString *)[data valueForKey:@"ID_WIMAX_IP_ADDR"];
    
    NSLog(@"Current Signal Strength %@", cinr);
    if ([cinr isEqualToString: @"N/A"]) {
        status.signal = @"disconnected";
    } else {
        NSUInteger signalInt = [cinr intValue];
        signalInt = (int) signalInt/6;
        NSLog(@"Current converted strength: %d", (int) signalInt);
        status.signal = [FPopStatus stringFromSignalType:(FPopStatusSignalType) signalInt];
    }
    NSLog(@"Converted Signal Strength %@", status.signal);
    
    return status;
}

@end
