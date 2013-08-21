#import "VerizonIndicatorsStatusPoller.h"

@implementation VerizonIndicatorsStatusPoller

-(VerizonIndicatorsStatusPoller *) initWithDelegate:(id <TetherStatusPollerDelegate>) theDelegate
                                             status:(TetherStatus*) theStatus
{
    self = [super initWithDelegate:theDelegate status:theStatus];
    if (self) {
        self.statusURL = [NSURL URLWithString:@"http://192.168.1.1/v1/indicators"];
    }
    return self;
}

// crude mapping of 6 levels to 5
-(int) calcSignalLevel:(int) level
{
    if (level == 4) {
        return 3;
    }
    if (level == 5) {
        return 4;
    }
    return level;
}

// crude mapping of 5 levels to 4
-(int) calcBatteryLevel:(int) level
{
    if (level == 3) {
        return 2;
    }
    if (level == 4) {
        return 3;
    }
    return level;
}

-(NSString *) calcNetworkType:(int) type
{
    if (type == 1) {
        return @"1X";
    }
    if (type == 3) {
        return @"3G";
    }
    if (type == 4) {
        return @"4G";
    }
    return NULL;
}

-(void) updateStatus:(NSDictionary *) data
{
    NSInteger networkType = [[data valueForKey:@"networkType"] intValue];
    status.networkType = [self calcNetworkType:networkType];
    if (networkType == 0) {
        status.status = @"DISCONNECTED";
        status.signal = @"disconnected";
    } else {
        status.status = @"CONNECTED";
        NSInteger signalInt = [[data valueForKey:@"signalStrengthMeter"] intValue];
        signalInt = [self calcSignalLevel:signalInt];
        status.signal = [TetherStatus stringFromSignalType:(TetherConnectionStatusSignalType) signalInt];
    }
    NSInteger batteryStatus = [[data valueForKey:@"batteryChargingState"] intValue];
    status.batteryStatus = (batteryStatus == 1) ? @"charging" : @"normal";
    NSInteger batteryLevel = [[data valueForKey:@"batteryMeter"] intValue];
    batteryLevel = [self calcBatteryLevel:batteryLevel];
    status.batteryLevel = [TetherStatus stringFromLevelType:(TetherBatteryStatusLevelType) batteryLevel];
    
    [delegate statusUpdated:status];
}

@end
