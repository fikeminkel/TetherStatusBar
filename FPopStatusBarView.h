#import <Cocoa/Cocoa.h>

@interface FPopStatusBarView : NSView <NSMenuDelegate> {
    NSImage* connectionImage;
    NSImage* batteryImage;
    NSStatusItem* statusItem;
    BOOL isHighlighted;
}

@property (retain) NSStatusItem* statusItem;

-(id) initWithFrame:(NSRect)frameRect;
-(void) updateBatteryStatus: (NSString *) battery;
-(void) updateConnectionStatus: (NSString *) signal;
@end
