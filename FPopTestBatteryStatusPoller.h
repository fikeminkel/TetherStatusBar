#import "FPopBatteryStatusPoller.h"

@interface FPopTestBatteryStatusPoller : FPopBatteryStatusPoller {
    NSMutableDictionary *testdata;
    NSArray *testdataOptions;
    NSUInteger testdataCurrentOption;
    
    NSString *testdataCurrentStatus;

}

@end
