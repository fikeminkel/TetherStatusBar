#import <CoreWLAN/CoreWLAN.h>
#import "WifiNetworkInfo.h"
#import "FPopStatusUtils.h"

@implementation WifiNetworkInfo

+(NSArray *) allKnownNetworks
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:50];
    CWInterface *interface = [CWInterface interface];
    DLog(@"interface: %@", interface);
    NSEnumerator *profiles = [interface.configuration.networkProfiles objectEnumerator];
    CWNetworkProfile *profile;
    while (profile = [profiles nextObject]) {
        [result addObject:profile.ssid];
    }
    return result;
}

@end
