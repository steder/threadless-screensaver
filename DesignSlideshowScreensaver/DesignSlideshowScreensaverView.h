//
//  DesignSlideshowScreensaverView.h
//  DesignSlideshowScreensaver
//
//  Created by Michael Steder on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@interface DesignSlideshowScreensaverView : ScreenSaverView
{
    double framesPerSecond;
    double blankSeconds;
    double secondsPerDesign;
    NSInteger interval;
    double seconds;
    NSInteger fadeInSeconds;
    NSInteger state;
    NSInteger tick;
    double alpha;
    NSImage *placeholder;
}
@end
