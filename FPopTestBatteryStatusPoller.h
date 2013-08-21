#import "FPopBatteryStatusPoller.h"
#import "TestDataList.h"

@interface FPopTestBatteryStatusPoller : FPopBatteryStatusPoller {
    TestDataList *batteryMeters;
    TestDataList *chargingStatus;
}

@end
