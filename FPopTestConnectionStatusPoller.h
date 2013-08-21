#import "FPopConnectionStatusPoller.h"
#import "TestDataList.h"

@interface FPopTestConnectionStatusPoller : FPopConnectionStatusPoller {
    TestDataList *signalStrengths;
}

@end
