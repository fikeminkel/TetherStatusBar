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

@interface TetherConnectionStatus : NSObject {
    NSString *status;
    NSString *signalStr;
    NSString *uptime;
    NSString *signal;
    NSString *ipAddress;
}

@property (retain) NSString *status;
@property (retain) NSString *signalStr;
@property (retain) NSString *uptime;
@property (retain) NSString *signal;
@property (retain) NSString *ipAddress;

+(NSString *) stringFromSignalType:(TetherConnectionStatusSignalType) type;
+(TetherConnectionStatusSignalType) signalTypeFromString:(NSString *) s;

@end
