#import "FPopStatusPoller.h"
#import "FPopTestConnectionStatusPoller.h"
#import "FPopTestBatteryStatusPoller.h"


@implementation FPopStatusPoller

-(FPopStatusPoller *) initWithDelegate:(id <TetherStatusPollerDelegate>) theDelegate
{
    self = [super initWithDelegate:theDelegate];
    if (self) {
#ifdef SIMULATE_NETWORK
        connectionPoller = [[FPopTestConnectionStatusPoller alloc] initWithDelegate:theDelegate status:status];
        batteryPoller = [[FPopTestBatteryStatusPoller alloc] initWithDelegate:theDelegate status:status];
#endif
        
#ifndef SIMULATE_NETWORK
        connectionPoller = [[FPopConnectionStatusPoller alloc] initWithDelegate:theDelegate status:status];
        batteryPoller = [[FPopBatteryStatusPoller alloc] initWithDelegate:theDelegate status:status];
#endif
    }
    return self;
}

-(void) startPolling:(NSTimeInterval)interval;
{
    [connectionPoller startPolling:interval];
    [batteryPoller startPolling:interval];
}

-(void) stopPolling
{
    [connectionPoller stopPolling];
    [batteryPoller stopPolling];
}

-(void) dealloc
{
    [connectionPoller release];
    connectionPoller = nil;
    
    [batteryPoller release];
    batteryPoller = nil;
    
    [super dealloc];
}
@end
