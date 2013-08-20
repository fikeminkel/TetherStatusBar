#import <Foundation/Foundation.h>

typedef enum {
    kTetherBatteryStatusLevelType_UNKNOWN,
    kTetherBatteryStatusLevelType_LOW,
    kTetherBatteryStatusLevelType_MEDIUM,
    kTetherBatteryStatusLevelType_FULL,
    kTetherBatteryStatusLevelType_DEFAULT = kTetherBatteryStatusLevelType_FULL
} TetherBatteryStatusLevelType;
#define kTetherBatteryStatusLevelTypeNamesArray @"unknown", @"low", @"medium", @"full", nil

@interface TetherBatteryStatus : NSObject {
    NSString *status;
    NSString *level;
}

@property (retain) NSString *status;
@property (retain) NSString *level;
@property (retain) NSString *statusStr;

+(NSString *) stringFromLevelType:(TetherBatteryStatusLevelType) type;
+(TetherBatteryStatusLevelType) levelTypeFromString:(NSString *) s;

@end
