#import "TetherApiPoller.h"
#import "TetherStatusUtils.h"

@implementation TetherApiPoller

@synthesize delegate;
@synthesize status;


-(TetherApiPoller *) initWithDelegate:(id<TetherStatusPollerDelegate>) theDelegate
                             status:(TetherStatus *)theStatus
{
    self = [self init];
    if (self) {
        delegate = [theDelegate retain];
        status = [theStatus retain];
    }
    return self;
}

-(void) startPolling:(NSTimeInterval)interval
{
    DLog(@"startPolling: %f", interval);
    if (!statusTimer) {
        [self performSelector:@selector(checkStatus)];
        statusTimer = [[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(checkStatus) userInfo:nil repeats:YES] retain];
    }
}

-(void) checkStatus
{
    DLog(@"connectionStatus");
    NSURLRequest *request = [NSURLRequest requestWithURL:self.statusURL];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!connection) {
        DLog(@"Connection failed!");
    }
}


-(void) stopPolling
{
    if (statusTimer) {
        [statusTimer invalidate];
        [statusTimer release];
        statusTimer = nil;
    }
}

-(void) statusUpdated
{
    [delegate statusUpdated:[status copy]];
}

#pragma mark -
#pragma mark "abstract" methods
-(void) updateStatus:(NSDictionary *)data
{
    mustOverride();
}

#pragma mark -
#pragma mark NSURLConnectionDelegate methods
-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    DLog(@"didReceiveResponse");
    responseData = [[[NSMutableData alloc] init] retain];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    return request;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *myError = nil;
    NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
//    jsonObj = [jsonObj objectForKey:@"data"];
    [self updateStatus:jsonObj];
    [responseData release];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DLog(@"connection didFailWithError %@", error);
}

-(void) dealloc
{
    [delegate release];
    delegate = nil;
    
    [status release];
    status = nil;
    
    [super dealloc];
}
@end
