#import <Foundation/Foundation.h>
#import "TetherConnectionStatus.h"

@interface FPopConnectionStatus : TetherConnectionStatus

+(FPopConnectionStatus *) statusWithData:(NSDictionary *)data;
+(FPopConnectionStatus *) disconnectedStatus;

@end
