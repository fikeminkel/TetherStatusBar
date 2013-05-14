#import <Foundation/Foundation.h>

typedef enum {
    kFPopBatteryStatusLevelType_NONE,
    kFPopBatteryStatusLevelType_LOW,
    kFPopBatteryStatusLevelType_MEDIUM,
    kFPopBatteryStatusLevelType_FULL,
    kFPopBatteryStatusLevelType_DEFAULT = kFPopBatteryStatusLevelType_FULL
} FPopBatteryStatusLevelType;
#define kFPopBatteryStatusLevelTypeNamesArray @"none", @"low", @"medium", @"full", nil

@interface FPopBatteryStatus : NSObject {
    NSString *status;
    NSString *level;
}

@property (retain) NSString *status;
@property (retain) NSString *level;
@property (retain) NSString *statusStr;

+(FPopBatteryStatus *) FPopBatteryStatusWithData:(NSDictionary *)data;


@end

