#import <Foundation/Foundation.h>

typedef enum {
    kFPopStatusSignalType_NONE,
    kFPopStatusSignalType_LOW,
    kFPopStatusSignalType_MEDIUM,
    kFPopStatusSignalType_HIGH,
    kFPopStatusSignalType_FULL,
    kFPopStatusSignalType_DEFAULT = kFPopStatusSignalType_NONE
} FPopStatusSignalType;
#define kFPopStatusSignalTypeNamesArray @"none", @"low", @"medium", @"high", @"full", nil

@interface FPopStatus : NSObject {
    NSString *connectionStatus;
    NSString *signalStr;
    NSString *uptime;
    NSString *signal;
    NSString *ipAddress;
}

@property (retain) NSString *connectionStatus;
@property (retain) NSString *signalStr;
@property (retain) NSString *uptime;
@property (retain) NSString *signal;
@property (retain) NSString *ipAddress;

+(FPopStatus *) FPopStatusWithData:(NSDictionary *)data;

@end
