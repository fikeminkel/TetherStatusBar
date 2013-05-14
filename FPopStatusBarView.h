//
//  FPopStatusBarView.h
//  FPopStatusBar
//
//  Created by Finkel, Mike on 5/10/13.
//
//

#import <Cocoa/Cocoa.h>

@interface FPopStatusBarView : NSView {    
    NSImageView* connectionView;
    NSImageView* batteryView;
}

-(id) initWithFrame:(NSRect)frameRect signal:(NSString *) signal battery:(NSString *) battery;
@end
