#import "FPopStatusPoller.h"
#import "FPopStatus.h"

@implementation FPopStatusPoller

@synthesize delegate;

-(FPopStatusPoller *) initWithDelegate:(id<FPopStatusPollerDelegate>)theDelegate
{
    self = [self init];
    if (self) {
        self.delegate = theDelegate;
    }
    return self;
}

-(void) pollStatus:(NSTimeInterval)interval
{
    NSLog(@"pollStatus: %f", interval);
    if (!statusTimer) {
        statusTimer = [[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(connectionStatus) userInfo:nil repeats:YES] retain];
    }
}

-(void) connectionStatus
{
    NSLog(@"connectionStatus");
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.1/cgi-bin/webmain.cgi?act=act_summary"]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!connection) {
        NSLog(@"Connection failed!");
    }
}


-(void) stopPolling
{
    if (statusTimer) {
        [statusTimer invalidate];
        [statusTimer release];
    }
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    responseData = [[[NSMutableData alloc] init] retain];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    [responseData appendData:data];
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    return request;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %ld bytes of data", (unsigned long)[responseData length]);
    NSError *myError = nil;
    NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
    jsonObj = [jsonObj objectForKey:@"data"];
    [delegate statusUpdated:[FPopStatus FPopStatusWithData:jsonObj]];
    [responseData release];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection didFailWithError %@", error);
}

@end
