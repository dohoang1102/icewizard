//
//  EAGLView.h
//  FirenIce
//
//  Created by Per Borgman on 2010-05-07.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//#import <OpenGLES/EAGL.h>
//#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "ESRenderer.h"

@class FIGame;

// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
// The view content is basically an EAGL surface you render your OpenGL scene into.
// Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
@interface EAGLView : UIView
{    
@private
	EAGLContext *context;
	GLint		width, height;

    BOOL animating;
    BOOL displayLinkSupported;
    NSInteger animationFrameInterval;
    // Use of the CADisplayLink class is the preferred method for controlling your animation timing.
    // CADisplayLink will link to the main display and fire every vsync when added to a given run-loop.
    // The NSTimer class is used only as fallback when running on a pre 3.1 device where CADisplayLink
    // isn't available.
    id displayLink;
    NSTimer *animationTimer;
	
	FIGame	*game;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

@property (nonatomic, assign) FIGame *game;

-(void)initOpenGLES;
-(void)setupView;

- (void)startAnimation;
- (void)stopAnimation;
- (void)tick:(id)sender;

@end
