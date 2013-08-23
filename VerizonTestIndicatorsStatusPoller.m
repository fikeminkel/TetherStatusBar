#import "VerizonTestIndicatorsStatusPoller.h"
#import "TetherStatusUtils.h"

@implementation VerizonTestIndicatorsStatusPoller

-(id) init
{
    DLog(@"init");
    self = [super init];
    if (self) {
        networkTypes = [[TestDataList alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", nil];
        signalStrengths = [[TestDataList alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil];
        batteryMeters = [[TestDataList alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", nil];
        batteryChargingStates = [[TestDataList alloc] initWithObjects:@"0", @"1", nil];
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
    DLog(@"%@", data);
    [super updateStatus:data];
}
@end
