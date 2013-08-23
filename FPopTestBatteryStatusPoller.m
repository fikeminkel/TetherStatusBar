#import "FPopTestBatteryStatusPoller.h"
#import "TetherStatusUtils.h"

@implementation FPopTestBatteryStatusPoller

- (id) init
{
    self = [super init];
    if (self) {
        batteryMeters = [[TestDataList alloc] initWithObjects:@"1", @"2", @"3", nil];
        chargingStatus = [[TestDataList alloc] initWithObjects:@"charging", @"normal", nil];
    }
    return self;
}

-(void) checkStatus
{
    NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
    [data setValue:[batteryMeters next] forKey:@"LEVEL"];
    [data setValue:[chargingStatus next] forKey:@"STATUS"];
    [self updateStatus:data];
}

-(void) dealloc
{
    [batteryMeters release];
    batteryMeters = nil;
    [chargingStatus release];
    chargingStatus = nil;
    [super dealloc];
}


@end
