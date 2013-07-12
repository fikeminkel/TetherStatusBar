#import <Foundation/Foundation.h>
#import "HardwareNetworkMonitor.h"

@interface TestHardwareNetworkMonitor : HardwareNetworkMonitor
{
    id <HardwareNetworkMonitorDelegate> _delegate;    
    NSUserDefaults *userDefaults;
    
}

@property (retain) id <HardwareNetworkMonitorDelegate> delegate;

-(id)initWithDelegate:(id) delegate;
-(void)fireOnLaunch;


@end
