#import "VerizonIndicatorsStatusPoller.h"
#import "TestDataList.h"

@interface VerizonTestIndicatorsStatusPoller : VerizonIndicatorsStatusPoller
{
    TestDataList *networkTypes;
    TestDataList *signalStrengths;
    TestDataList *batteryMeters;
    TestDataList *batteryChargingStates;
}

@end
