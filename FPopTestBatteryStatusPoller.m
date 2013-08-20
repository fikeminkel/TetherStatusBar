#import "FPopTestBatteryStatusPoller.h"
#import "FPopBatteryStatus.h"
#import "TetherStatusUtils.h"

@implementation FPopTestBatteryStatusPoller

- (id) init
{
    self = [super init];
    if (self) {
        testdata = [[NSMutableDictionary alloc] init];
        testdataOptions = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", nil];
        testdataCurrentOption = 0;
    }
    return self;
}

-(void) checkStatus
{
    NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
    [data setValue:[testdataOptions objectAtIndex:testdataCurrentOption] forKey:@"LEVEL"];
    testdataCurrentStatus = [testdataCurrentStatus isEqual:@"normal"] ? @"charging" : @"normal";
    [data setValue:testdataCurrentStatus forKey:@"STATUS"];
    testdataCurrentOption = (testdataCurrentOption >= testdataOptions.count-1) ? 0 : testdataCurrentOption + 1;
    [delegate batteryStatusUpdated:[FPopBatteryStatus statusWithData:data]];
}

-(void) dealloc
{
    [testdata release];
    testdata = nil;
    [testdataOptions release];
    testdata = nil;
    [super dealloc];
}


@end
