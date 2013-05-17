#import "FPopStatusBarView.h"
#import "FPopStatusUtils.h"

@implementation FPopStatusBarView

static NSMutableDictionary *statusImages;
static NSMutableDictionary *batteryImages;

@synthesize statusItem;

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
        connectionImage = [statusImages objectForKey:signal];
        // TODO: do I need to make another dictionary mapping status to images?
        batteryImage = [self resizedImageNamed:[NSString stringWithFormat:@"battery-%@.png",battery] size:16];
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
-(void) drawRect:(NSRect)rect
{
    DLog(@"drawing images: %@, %@", connectionImage, batteryImage);
    [connectionImage drawAtPoint: NSMakePoint(0, 2) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    [batteryImage drawAtPoint:NSMakePoint(18, 2) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
//    BOOL isHighlighted = [[self enclosingMenuItem] isHighlighted];
//    DLog(@"isHighlighted: %c", isHighlighted);
//    if (isHighlighted) {
//        [[NSColor selectedMenuItemColor] set];
//        [NSBezierPath fillRect:dirtyRect];
//    } else {
//        [super drawRect:dirtyRect];
//    }
    
}

-(void) updateBatteryStatus:(NSString *)battery
{
    [batteryImage release];
    batteryImage = [[self resizedImageNamed:[NSString stringWithFormat:@"battery-%@.png",battery] size:16] retain];
    [self setNeedsDisplay:YES];

}

-(void) updateConnectionStatus:(NSString *)signal
{
    [connectionImage release];
    connectionImage = [[statusImages objectForKey:signal] retain];
    [self setNeedsDisplay:YES];
}

-(void)dealloc
{
    [statusImages release];
    statusImages = nil;
    [batteryImages release];
    batteryImages = nil;

    [connectionImage release];
    connectionImage = nil;
    [batteryImage release];
    batteryImage = nil;
    [super dealloc];
}

@end
