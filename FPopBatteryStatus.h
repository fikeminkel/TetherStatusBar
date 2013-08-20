#import <Foundation/Foundation.h>
#import "TetherBatteryStatus.h"

@interface FPopBatteryStatus : TetherBatteryStatus

+(FPopBatteryStatus *) statusWithData:(NSDictionary *)data;
+(FPopBatteryStatus *) unknownStatus;


@end

