#import "FPopStatusBarView.h"

@implementation FPopStatusBarView

static NSMutableDictionary *statusImages;
static NSMutableDictionary *batteryImages;

-(NSImage *) resizedImageNamed:(NSString *) name size:(NSInteger) size
{
    NSImage *image = [NSImage imageNamed:name];
    if (image) {
        NSSize imageSize = [image size];
        imageSize.width = size;
        imageSize.height = size;
        [image setSize:imageSize];
    }
    return image;
}

- (id)initWithFrame:(NSRect)frame signal:(NSString*) signal battery:(NSString*) battery
{
    self = [self initWithFrame:frame];
    if (self) {
        [self initStatusImages];
        NSLog(@"FPopStatusBar initWithFrame: signal: %@ battery:%@", signal, battery);
        connectionView = [[[NSImageView alloc] initWithFrame:NSMakeRect(0, 2, 18, 18)] retain];
        [connectionView setImage:[statusImages objectForKey:signal]];
        [self addSubview:connectionView];
        batteryView = [[[NSImageView alloc] initWithFrame:NSMakeRect(18, 2, 16, 16)] retain];
        // TODO: do I need to make another dictionary mapping status to images?
        [batteryView setImage:[self resizedImageNamed:[NSString stringWithFormat:@"battery-%@.png",battery] size:16]];
        [self addSubview:batteryView];
    }
    return self;
}

-(void) initStatusImages {
    if (!statusImages) {
        statusImages = [[[NSMutableDictionary alloc] init] retain];
        [statusImages setObject:[self resizedImageNamed:@"network-gsm-full_18.png" size:18] forKey:@"full"];
        [statusImages setObject:[self resizedImageNamed:@"network-gsm-high_18.png" size:18] forKey:@"high"];
        [statusImages setObject:[self resizedImageNamed:@"network-gsm-medium_18.png" size:18] forKey:@"medium"];
        [statusImages setObject:[self resizedImageNamed:@"network-gsm-low_18.png" size:18] forKey:@"low"];
        [statusImages setObject:[self resizedImageNamed:@"network-gsm-none_18.png" size:18] forKey:@"none"];
        [statusImages setObject:[self resizedImageNamed:@"network-wireless-disconnected_18.png" size:18] forKey:@"disconnected"];
    }
}

-(void)dealloc
{
    [statusImages release];
    statusImages = nil;
    [batteryImages release];
    batteryImages = nil;

    [connectionView release];
    connectionView = nil;
    [batteryView release];
    batteryView = nil;
    [super dealloc];
}

@end
