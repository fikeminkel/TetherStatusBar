#import "TetherBatteryStatus.h"

@implementation TetherBatteryStatus
@synthesize status;
@synthesize level;
@synthesize statusStr;

static NSArray *TetherBatteryStatusLevelTypeArray = [[NSArray alloc] initWithObjects:kTetherBatteryStatusLevelTypeNamesArray];

+(NSString *) stringFromLevelType:(TetherBatteryStatusLevelType) type
{
    return [TetherBatteryStatusLevelTypeArray objectAtIndex:type];
}

+(TetherBatteryStatusLevelType) levelTypeFromString:(NSString *) s
{
    NSUInteger n = [TetherBatteryStatusLevelTypeArray indexOfObject:s];
    check (n != NSNotFound);
    if (n == NSNotFound) {
        n = kTetherBatteryStatusLevelType_DEFAULT;
    }
    return (TetherBatteryStatusLevelType) n;
}


@end
