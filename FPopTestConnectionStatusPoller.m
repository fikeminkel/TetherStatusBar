#import "FPopTestConnectionStatusPoller.h"
#import "TetherStatusUtils.h"

@implementation FPopTestConnectionStatusPoller

- (id) init
{
    self = [super init];
    if (self) {
        signalStrengths = [[TestDataList alloc] initWithArray:[[[NSArray alloc] initWithObjects:@"N/A", @"0", @"5", @"10", @"15", @"20", @"25", @"30", nil] autorelease]];
    }
    return self;
}

-(void) checkStatus
{
    NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
    [data setValue:@"CONNECTED" forKey:@"ID_WIMAX_STATUS"];
    [data setValue:@"00:22:47" forKey:@"ID_WIMAX_CONN_TIME"];
    [data setValue:@"127.0.0.1" forKey:@"ID_WIMAX_IP_ADDR"];
    [data setValue:@"-72" forKey:@"ID_WIMAX_RSSI"];
    [data setValue:[signalStrengths next] forKey:@"ID_WIMAX_CINR"];
    [self updateStatus:data];
}

-(void) dealloc
{
    [signalStrengths release];
    signalStrengths = nil;
    [super dealloc];
}

@end
