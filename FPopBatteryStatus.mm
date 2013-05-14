#import "FPopBatteryStatus.h"

@implementation FPopBatteryStatus
@synthesize status;
@synthesize level;
@synthesize statusStr;

static NSArray *FPopBatteryStatusLevelTypeArray = [[NSArray alloc] initWithObjects:kFPopBatteryStatusLevelTypeNamesArray];

+(NSString *) stringFromLevelType:(FPopBatteryStatusLevelType) type
{
    return [FPopBatteryStatusLevelTypeArray objectAtIndex:type];
}

+(FPopBatteryStatusLevelType) levelTypeFromString:(NSString *) s {
    NSUInteger n = [FPopBatteryStatusLevelTypeArray indexOfObject:s];
    check (n != NSNotFound);
    if (n == NSNotFound) {
        n = kFPopBatteryStatusLevelType_DEFAULT;
    }
    return (FPopBatteryStatusLevelType) n;
}


+(FPopBatteryStatus *) FPopBatteryStatusWithData:(NSDictionary *)data
{
    FPopBatteryStatus *status = [[[FPopBatteryStatus alloc] init] autorelease];
    //LEVEL: "3"
    //STATUS: "normal"
    status.status = [data objectForKey:@"STATUS"];
    NSInteger levelInt =  [(NSString *)[data objectForKey:@"LEVEL"] intValue];
    if (!status.status) {
        levelInt = kFPopBatteryStatusLevelType_UNKNOWN;
        status.status = @"unknown";
    }
    status.level =  [FPopBatteryStatus stringFromLevelType:(FPopBatteryStatusLevelType) levelInt];
    status.statusStr = [NSString stringWithFormat:@"%@-%@", status.level, status.status];
    return status;
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
