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

    if (self) {
        [self setAnimationTimeInterval:1];
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
    NSLog(@"drawRect called...");
    [placeholder drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    //[super drawRect:rect];
}

- (void)animateOneFrame
{
    /*NSLog(@"animate frame...");
    NSImage *placeholder = [[NSImage alloc] initWithContentsOfFile:@"636x460design_01.jpg"];
    [placeholder drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeDestinationOver fraction:1.0];
     */
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
