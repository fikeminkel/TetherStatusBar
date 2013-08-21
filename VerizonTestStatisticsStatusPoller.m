#import "VerizonTestStatisticsStatusPoller.h"

@implementation VerizonTestStatisticsStatusPoller

-(void) checkStatus
{
    NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
    [data setObject:@"127.0.0.1" forKey:@"IPv4Address"];
    [data setObject:@"0:23:42" forKey:@"duration"];
    [self updateStatus:data];
}

@end
