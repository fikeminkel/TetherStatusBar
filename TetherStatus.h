#import <Foundation/Foundation.h>

typedef enum {
    kTetherConnectionStatusSignalType_NONE,
    kTetherConnectionStatusSignalType_LOW,
    kTetherConnectionStatusSignalType_MEDIUM,
    kTetherConnectionStatusSignalType_HIGH,
    kTetherConnectionStatusSignalType_FULL,
    kTetherConnectionStatusSignalType_DEFAULT = kTetherConnectionStatusSignalType_NONE
} TetherConnectionStatusSignalType;
#define kTetherConnectionStatusSignalTypeNamesArray @"none", @"low", @"medium", @"high", @"full", nil

typedef enum {
    kTetherBatteryStatusLevelType_UNKNOWN,
    kTetherBatteryStatusLevelType_LOW,
    kTetherBatteryStatusLevelType_MEDIUM,
    kTetherBatteryStatusLevelType_FULL,
    kTetherBatteryStatusLevelType_DEFAULT = kTetherBatteryStatusLevelType_FULL
} TetherBatteryStatusLevelType;
#define kTetherBatteryStatusLevelTypeNamesArray @"unknown", @"low", @"medium", @"full", nil

@interface TetherStatus : NSObject {
    NSString *connectionStatus;
    NSString *networkType;
    NSString *signalStr;
    NSString *uptime;
    NSString *signal;
    NSString *ipAddress;
    NSString *batteryStatus;
    NSString *batteryLevel;
}

@property (retain) NSString *status;
@property (retain) NSString *networkType;
@property (retain) NSString *signalStr;
@property (retain) NSString *uptime;
@property (retain) NSString *signal;
@property (retain) NSString *ipAddress;
@property (retain) NSString *batteryStatus;
@property (retain) NSString *batteryLevel;

+(NSString *) stringFromSignalType:(TetherConnectionStatusSignalType) type;
+(TetherConnectionStatusSignalType) signalTypeFromString:(NSString *) s;

+(NSString *) stringFromLevelType:(TetherBatteryStatusLevelType) type;
+(TetherBatteryStatusLevelType) levelTypeFromString:(NSString *) s;

+(TetherStatus *) disconnectedStatus;

-(NSString *) description;

@end
