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

    fadeInSeconds = 1.0;
    framesPerSecond = 30.0;
    secondsPerDesign = 2.0;
    blankSeconds = 1.0;
    tick = 0;
    alpha = 0;
    state = FadingIn;
    imageIndex = 0;
    images = [[[NSMutableArray alloc] init] retain];
    placeholders = [[[NSMutableArray alloc] init] retain];
    
    NSArray *placeholder_names = [NSArray arrayWithObjects: @"1000.jpg", @"1001.jpg", @"1004.jpg", @"1005.jpg",                @"1010.jpg", @"1354.jpg", @"1362.jpg", @"2005.jpg", @"2011.jpg", @"3003.jpg", @"3005.jpg", @"3006.jpg", @"3007.jpg", @"3500.jpg", @"3501.jpg", nil];
    
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
        /*
         [images addObject:[[NSImage alloc]
                           initWithContentsOfURL:[NSURL URLWithString:@"http://media.threadless.com/imgs/products/1001/636x460design_01.jpg"]]];
        [images addObject:[[NSImage alloc]
                           initWithContentsOfURL:[NSURL URLWithString:@"http://media.threadless.com/imgs/products/1000/636x460design_01.jpg"]]];
         */
        
        for (NSString *name in placeholder_names)
        {
            imagePath = [saverBundle pathForResource:name ofType: nil];
            NSImage *image = [[[NSImage alloc] initWithContentsOfFile:imagePath] autorelease];
            if (image != nil) {
                NSLog(@"Loading image %@: %@", imagePath, image);
                [placeholders addObject:image];
            }
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
    if (state == FadingIn) {
        alpha = MIN(seconds / fadeInSeconds, 1.0);
    }
    else if (state == Normal) {
        alpha = 1.0;
    }
    else if (state == FadingOut) {
        alpha = MAX(1.0 - (seconds / fadeInSeconds), 0);
    }
    [[placeholders objectAtIndex:imageIndex] drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:alpha];
}

- (void)animateOneFrame
{
    if (state == FadingIn && seconds > fadeInSeconds) {
        tick = 0;
        state = Normal;
    }
    else if (state == Normal && seconds > secondsPerDesign) {
        tick = 0;
        state = FadingOut;
    }
    else if (state == FadingOut && seconds > fadeInSeconds) {
        tick = 0;
        state = FadingIn;
        imageIndex = (imageIndex + 1) % placeholders.count;
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
