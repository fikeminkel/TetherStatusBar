#import <Cocoa/Cocoa.h>

@interface TetherStatusView : NSView <NSMenuDelegate> {
    NSRect frameWithBattery;
    NSRect frameWithoutBattery;
    NSImage* connectionImage;
    NSImage* batteryImage;
    NSStatusItem* statusItem;
    BOOL isHighlighted;
    BOOL _showBatteryImage;
}

@property (retain) NSStatusItem* statusItem;
@property (nonatomic) BOOL showBatteryImage;
-(id) init;
-(void) updateBatteryStatus: (NSString *) battery;
-(void) updateConnectionStatus: (NSString *) signal;
@end
