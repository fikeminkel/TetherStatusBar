#import <Cocoa/Cocoa.h>

@interface FPopStatusBarView : NSView {
    NSImage* connectionImage;
    NSImage* batteryImage;
    NSStatusItem* statusItem;
}

@property (retain) NSStatusItem* statusItem;

-(id) initWithFrame:(NSRect)frameRect signal:(NSString *) signal battery:(NSString *) battery;
-(void) updateBatteryStatus: (NSString *) battery;
-(void) updateConnectionStatus: (NSString *) signal;
@end
