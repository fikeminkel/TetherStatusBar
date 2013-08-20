#import "FPopBatteryStatus.h"
#import "TetherBatteryStatus.h"

@implementation FPopBatteryStatus

static FPopBatteryStatus *unknown = [FPopBatteryStatus statusWithData:
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"unknown", @"STATUS", @"unknown", @"LEVEL", nil]];

+(FPopBatteryStatus *) statusWithData:(NSDictionary *)data
{
    FPopBatteryStatus *status = [[[FPopBatteryStatus alloc] init] autorelease];
    status.status = [data objectForKey:@"STATUS"];
    NSInteger levelInt =  [(NSString *)[data objectForKey:@"LEVEL"] intValue];
    if (!status.status) {
        levelInt = kTetherBatteryStatusLevelType_UNKNOWN;
        status.status = @"unknown";
    }
    status.level =  [TetherBatteryStatus stringFromLevelType:(TetherBatteryStatusLevelType) levelInt];
    status.statusStr = [NSString stringWithFormat:@"%@-%@", status.level, status.status];
    return status;
}
+(FPopBatteryStatus *) unknownStatus
{
    return unknown;
}

-(BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    }
    FPopBatteryStatus *oStatus = (FPopBatteryStatus *)other;
    if (![(id) [self status] isEqual:[oStatus status]]) {
        return NO;
    }
    if (![(id) [self level] isEqual:[oStatus level]]) {
        return NO;
    }
    return YES;
}
@end
