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
    state = FadingIn;
    imageIndex = 0;
    images = [[[NSMutableArray alloc] init] retain];
    
    if (self) {
        [self setAnimationTimeInterval:1/framesPerSecond];
        NSBundle* saverBundle = [NSBundle bundleForClass:
                                 [self class]];
        NSLog(@"SCREENSAVER resourcePath: %@", [saverBundle resourcePath]);
        NSString* imagePath = [saverBundle pathForResource:@"placeholder.jpg"
                                                    ofType: nil];        
        NSLog(@"SCREENSAVER imagePath: %@", imagePath);
        placeholder = [[NSImage alloc]
                           initWithContentsOfFile:imagePath];
        [images addObject:[[NSImage alloc]
                           initWithContentsOfURL:[NSURL URLWithString:@"http://media.threadless.com/imgs/products/1001/636x460design_01.jpg"]]];
        [images addObject:[[NSImage alloc]
                           initWithContentsOfURL:[NSURL URLWithString:@"http://media.threadless.com/imgs/products/1000/636x460design_01.jpg"]]];

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
    if (state == FadingIn) {
        alpha = MIN(seconds / fadeInSeconds, 1.0);
    }
    else if (state == Normal) {
        alpha = 1.0;
    }
    else if (state == FadingOut) {
        alpha = MAX(1.0 - (seconds / fadeInSeconds), 0);
    }
    [[images objectAtIndex:imageIndex] drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:alpha];
}

- (void)animateOneFrame
{
    if (state == 0 && seconds > fadeInSeconds) {
        tick = 0;
        state = Normal;
    }
    else if (state == 1 && seconds > secondsPerDesign) {
        tick = 0;
        state = FadingOut;
    }
    else if (state == 2 && seconds > fadeInSeconds) {
        tick = 0;
        state = FadingIn;
        imageIndex = (imageIndex + 1) % images.count;
    }
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
