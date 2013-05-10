

#import "FPopTestStatusPoller.h"

@implementation FPopTestStatusPoller

- (id) init
{
    self = [super init];
    if (self) {
        testdata = [[[NSMutableDictionary alloc] init] retain];
        testdataOptions = [[[NSArray alloc] initWithObjects:@"N/A", @"0", @"5", @"10", @"15", @"20", @"25", nil] retain];
        testdataCurrentOption = 0;

    }
    return self;
}

-(void) connectionStatus
{
    NSLog(@"connectionStatus");
    NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
    [data setValue:@"CONNECTED" forKey:@"ID_WIMAX_STATUS"];
    [data setValue:@"00:22:47" forKey:@"ID_WIMAX_CONN_TIME"];
    [data setValue:@"127.0.0.1" forKey:@"ID_WIMAX_IP_ADDR"];
    [data setValue:@"-72" forKey:@"ID_WIMAX_RSSI"];
    [data setValue:[testdataOptions objectAtIndex:testdataCurrentOption] forKey:@"ID_WIMAX_CINR"];
    NSLog(@"connectionStatus testdata %ld %ld", (unsigned long)testdataCurrentOption, (unsigned long)testdataOptions.count);
    testdataCurrentOption = (testdataCurrentOption >= testdataOptions.count-1) ? 0 : testdataCurrentOption + 1;
    [delegate statusUpdated:[FPopStatus FPopStatusWithData:data]];
}

-(void) dealloc
{
    [testdata release];
    testdata = nil;
    [testdataOptions release];
    testdata = nil;
    [super dealloc];
}

@end
