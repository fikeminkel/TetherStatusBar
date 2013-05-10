#import "FPopStatusPoller.h"

@interface FPopTestStatusPoller : FPopStatusPoller {
    NSMutableDictionary *testdata;
    NSArray *testdataOptions;
    NSUInteger testdataCurrentOption;
}

@end
