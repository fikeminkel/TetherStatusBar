#import <Cocoa/Cocoa.h>

@interface FPopStatusBarView : NSView {    
    NSImageView* connectionView;
    NSImageView* batteryView;
}

-(id) initWithFrame:(NSRect)frameRect signal:(NSString *) signal battery:(NSString *) battery;
@end
