#import "VerizonTestIndicatorsStatusPoller.h"

@implementation VerizonTestIndicatorsStatusPoller

-(id) init
{
    self = [super init];
    if (self) {
        networkTypes = [[TestDataList alloc] initWithArray:[[[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", nil] autorelease]];
        signalStrengths = [[TestDataList alloc] initWithArray:[[[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil] autorelease]];
        batteryMeters = [[TestDataList alloc] initWithArray:[[[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", nil] autorelease]];
        batteryChargingStates = [[TestDataList alloc] initWithArray:[[[NSArray alloc] initWithObjects:@"0", @"1", nil] autorelease]];
    }
    return self;
}

-(void) checkStatus
{
    NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
    [data setObject:[networkTypes next] forKey:@"networkType"];
    [data setObject:[signalStrengths next] forKey:@"signalStrengthMeter"];
    [data setObject:[batteryMeters next] forKey:@"batteryMeter"];
    [data setObject:[batteryChargingStates next] forKey:@"batteryChargingState"];
    [self updateStatus:data];
}
@end
