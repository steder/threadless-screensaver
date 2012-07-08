//
//  DesignSlideshowScreensaverView.m
//  DesignSlideshowScreensaver
//
//  Created by Michael Steder on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DesignSlideshowScreensaverView.h"



@implementation DesignSlideshowScreensaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];

    interval = 1;
    fadeInSeconds = 1.0;
    framesPerSecond = 30.0;
    secondsPerDesign = 2.0;
    blankSeconds = 1.0;
    tick = 0;
    alpha = 0;
    state = 0;
    
    if (self) {
        [self setAnimationTimeInterval:1/framesPerSecond];
        NSBundle* saverBundle = [NSBundle bundleForClass:
                                 [self class]];
        NSLog(@"SCREENSAVER resourcePath: %@", [saverBundle resourcePath]);

        NSString* imagePath = [saverBundle pathForResource:@"placeholder.jpg"
                                                    ofType: nil];

        NSLog(@"SCREENSAVER imagePath: %@", imagePath);

        placeholder = [[NSImage alloc]
         initWithContentsOfURL:[NSURL URLWithString:@"http://media.threadless.com/imgs/products/0/636x460design_01.jpg"]];
        if (placeholder == nil) {
            placeholder = [[NSImage alloc]
                           initWithContentsOfFile:imagePath];
        }
            
        NSLog(@"Placeholder: %@", placeholder);  
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{    
    NSLog(@"seconds=%f, alpha=%f, state=%li", seconds, alpha, state);
    if (state == 0) {
        // fading in:
        alpha = MIN(seconds / fadeInSeconds, 1.0);
        [placeholder drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:alpha];        
    }
    else if (state == 1) {
        alpha = 1.0;
        [placeholder drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:alpha];        
    }
    else if (state == 2) {
        // fading out:
        alpha = MAX(1.0 - (seconds / fadeInSeconds), 0);
        [placeholder drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:alpha];        
    }
    else {
        // blank
        alpha = MIN(seconds / blankSeconds, 1.0);
        [[NSColor blackColor] setFill];
        NSRectFillUsingOperation(rect, NSCompositeSourceOver);
    }
}

- (void)animateOneFrame
{
    /*NSLog(@"animate frame...");
    NSImage *placeholder = [[NSImage alloc] initWithContentsOfFile:@"636x460design_01.jpg"];
    [placeholder drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeDestinationOver fraction:1.0];
     */
    
    // states:
    //  0 - fade in
    //  1 - normal
    //  2 - fading out
    //  3 - blank
        
    if (state == 0 && seconds > fadeInSeconds) {
        tick = 0;
        state += 1;
    }
    else if (state == 1 && seconds > secondsPerDesign) {
        tick = 0;
        state += 1;
    }
    else if (state == 2 && seconds > fadeInSeconds) {
        tick = 0;
        state = 0;
    }
/* 
    else if (state == 3 && seconds > blankSeconds) {
        tick = 0;
        state = 0;
    }
 */
    
    seconds = tick / framesPerSecond;
    
    tick += 1;
    [self setNeedsDisplay:YES];
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
