#import <Foundation/Foundation.h>

typedef enum {
    kFPopBatteryStatusLevelType_UNKNOWN,
    kFPopBatteryStatusLevelType_LOW,
    kFPopBatteryStatusLevelType_MEDIUM,
    kFPopBatteryStatusLevelType_FULL,
    kFPopBatteryStatusLevelType_DEFAULT = kFPopBatteryStatusLevelType_FULL
} FPopBatteryStatusLevelType;
#define kFPopBatteryStatusLevelTypeNamesArray @"unknown", @"low", @"medium", @"full", nil

@interface FPopBatteryStatus : NSObject {
    NSString *status;
    NSString *level;
}

@property (retain) NSString *status;
@property (retain) NSString *level;
@property (retain) NSString *statusStr;

+(FPopBatteryStatus *) statusWithData:(NSDictionary *)data;
+(FPopBatteryStatus *) unknownStatus;


@end

