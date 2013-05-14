#import <Foundation/Foundation.h>

typedef enum {
    kFPopConnectionStatusSignalType_NONE,
    kFPopConnectionStatusSignalType_LOW,
    kFPopConnectionStatusSignalType_MEDIUM,
    kFPopConnectionStatusSignalType_HIGH,
    kFPopConnectionStatusSignalType_FULL,
    kFPopConnectionStatusSignalType_DEFAULT = kFPopConnectionStatusSignalType_NONE
} FPopConnectionStatusSignalType;
#define kFPopConnectionStatusSignalTypeNamesArray @"none", @"low", @"medium", @"high", @"full", nil

@interface FPopConnectionStatus : NSObject {
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

+(FPopConnectionStatus *) FPopConnectionStatusWithData:(NSDictionary *)data;

@end
