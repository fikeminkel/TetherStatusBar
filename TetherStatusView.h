#import <Cocoa/Cocoa.h>

@interface TetherStatusView : NSView <NSMenuDelegate> {
    NSRect frameWithBattery;
    NSRect frameWithoutBattery;
    NSImage* connectionImage;
    NSImage* batteryImage;
    NSString* networkType;
    
    NSStatusItem* statusItem;
    BOOL isHighlighted;
    BOOL _showBatteryImage;
}

@property (retain) NSStatusItem* statusItem;
@property (nonatomic) BOOL showBatteryImage;
-(id) init;
-(void) updateBatteryStatus:(NSString *)batteryStatus level:(NSString *)batteryLevel;
-(void) updateConnectionStatus:(NSString *)signal networkType:(NSString *)networkType;
@end
