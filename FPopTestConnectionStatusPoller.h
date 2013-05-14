#import "FPopConnectionStatusPoller.h"

@interface FPopTestConnectionStatusPoller : FPopConnectionStatusPoller {
    NSMutableDictionary *testdata;
    NSArray *testdataOptions;
    NSUInteger testdataCurrentOption;
}

@end
