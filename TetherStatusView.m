#import "FPopStatusBarView.h"
#import "FPopStatusUtils.h"

@implementation FPopStatusBarView

static NSMutableDictionary *statusImages;
static NSMutableDictionary *batteryImages;



@synthesize statusItem;
@synthesize showBatteryImage = _showBatteryImage;

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

- (id)init {
    frameWithBattery = NSMakeRect(0, 0, 36, 20);
    frameWithoutBattery = NSMakeRect(0, 0, 22, 20);
    self = [super initWithFrame:frameWithBattery];
    if (self) {
        [self initStatusImages];
        isHighlighted = NO;
        _showBatteryImage = YES;
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
    [statusItem drawStatusBarBackgroundInRect:[self bounds] withHighlight:isHighlighted];
    [connectionImage drawAtPoint: NSMakePoint(2, 2) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    if (_showBatteryImage) {
        [batteryImage drawAtPoint:NSMakePoint(20, 2) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }
}

- (void)mouseDown:(NSEvent *)event
{
    DLog(@"event: %@", event);
    [[self menu] setDelegate:self];
    [statusItem popUpStatusItemMenu:[self menu]];
    [self setNeedsDisplay:YES];
}

- (void)rightMouseDown:(NSEvent *)event
{
    [self mouseDown:event];
}

- (void)menuWillOpen:(NSMenu *)menu
{
    DLog(@"menu: %@", menu);
    isHighlighted = YES;
    [self setNeedsDisplay:YES];
}

- (void)menuDidClose:(NSMenu *)menu
{
    isHighlighted = NO;
    [[self menu] setDelegate:nil];
    [self setNeedsDisplay:YES];
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

-(void) setShowBatteryImage:(BOOL)showBatteryImage {
    _showBatteryImage = showBatteryImage;
    if (_showBatteryImage) {
        [self setFrame:frameWithBattery];
    } else {
        [self setFrame:frameWithoutBattery];
    }
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
