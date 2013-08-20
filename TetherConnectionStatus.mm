
#import "TetherConnectionStatus.h"

@implementation TetherConnectionStatus

@synthesize signal;
@synthesize uptime;
@synthesize signalStr;
@synthesize status;
@synthesize ipAddress;

static NSArray *TetherConnectionStatusSignalTypeArray = [[NSArray alloc] initWithObjects:kTetherConnectionStatusSignalTypeNamesArray];

+(NSString *) stringFromSignalType:(TetherConnectionStatusSignalType) type
{
    return [TetherConnectionStatusSignalTypeArray objectAtIndex:type];
}

+(TetherConnectionStatusSignalType) signalTypeFromString:(NSString *) s
{
    NSUInteger n = [TetherConnectionStatusSignalTypeArray indexOfObject:s];
    check (n != NSNotFound);
    if (n == NSNotFound) {
        n = kTetherConnectionStatusSignalType_DEFAULT;
    }
    return (TetherConnectionStatusSignalType) n;
}

@end
