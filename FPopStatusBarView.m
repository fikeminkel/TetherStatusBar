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
    self = [super initWithFrame:frame];
    if (self) {
        [self initStatusImages];
        connectionView = [[[NSImageView alloc] initWithFrame:NSMakeRect(0, 2, 18, 18)] retain];
        [connectionView setImage:[statusImages objectForKey:signal]];
        [self addSubview:connectionView];
        batteryView = [[[NSImageView alloc] initWithFrame:NSMakeRect(20, 2, 16, 16)] retain];
        [batteryView setImage:[self resizedImageNamed:battery size:16]];
        [self addSubview:batteryView];
    }
    return self;
}

-(void) initStatusImages {
    NSLog(@"initStatusImages");
    if (!statusImages) {
        statusImages = [[[NSMutableDictionary alloc] init] retain];
        [statusImages setObject:[self resizedImageNamed:@"network-gsm-full_18.png" size:18] forKey:@"full"];
        [statusImages setObject:[self resizedImageNamed:@"network-gsm-high_18.png" size:18] forKey:@"high"];
        [statusImages setObject:[self resizedImageNamed:@"network-gsm-medium_18.png" size:18] forKey:@"medium"];
        [statusImages setObject:[self resizedImageNamed:@"network-gsm-low_18.png" size:18] forKey:@"low"];
        [statusImages setObject:[self resizedImageNamed:@"network-gsm-none_18.png" size:18] forKey:@"none"];
        [statusImages setObject:[self resizedImageNamed:@"network-wireless-disconnected_18.png" size:18] forKey:@"disconnected"];
    }
    if (!batteryImages) {
        batteryImages = [[[NSMutableDictionary alloc] init] retain];
        [batteryImages setObject:[self resizedImageNamed:@"battery-030.png" size:18] forKey:@"battery"];
        // TODO add other battery images

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
