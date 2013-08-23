#import "VerizonStatusPoller.h"
#import "VerizonTestIndicatorsStatusPoller.h"
#import "VerizonTestStatisticsStatusPoller.h"
#import "TetherStatusUtils.h"

@implementation VerizonStatusPoller

-(VerizonStatusPoller *) initWithDelegate:(id<TetherStatusPollerDelegate>)theDelegate
{
    
    self = [super initWithDelegate:theDelegate];
    if (self) {
#ifdef SIMULATE_NETWORK
        indicatorsPoller = [[VerizonTestIndicatorsStatusPoller alloc] initWithDelegate:theDelegate status:status];
        statsPoller = [[VerizonTestStatisticsStatusPoller alloc] initWithDelegate:theDelegate status:status];
#endif
#ifndef SIMULATE_NETWORK
        indicatorsPoller = [[VerizonIndicatorsStatusPoller alloc] initWithDelegate:theDelegate status:status];
        statsPoller = [[VerizonStatisticsStatusPoller alloc] initWithDelegate:theDelegate status:status];
#endif
    }
    return self;
}

-(void) startPolling:(NSTimeInterval)interval;
{
    [indicatorsPoller startPolling:interval];
    [statsPoller startPolling:interval];
}

-(void) stopPolling
{
    [indicatorsPoller stopPolling];
    [statsPoller stopPolling];
}

-(void) dealloc
{
    [indicatorsPoller release];
    indicatorsPoller = nil;
    
    [statsPoller release];
    statsPoller = nil;
    
    [super dealloc];
}

@end
