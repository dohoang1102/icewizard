//
//  EAGLView.m
//  FirenIce
//
//  Created by Per Borgman on 2010-05-07.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "EAGLView.h"

#import "FIGame.h"

@implementation EAGLView

@synthesize animating;
@dynamic animationFrameInterval;

@synthesize game;

// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

//The EAGL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder
{    
    if ((self = [super initWithCoder:coder]))
    {
		printf("EAGLView: Initialize.\n");
		
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];

		[self initOpenGLES];
		
		game = [[FIGame alloc] init];
		
        animating = FALSE;
        displayLinkSupported = FALSE;
        animationFrameInterval = 1;
        displayLink = nil;
        animationTimer = nil;

        // A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
        // class is used as fallback when it isn't available.
        NSString *reqSysVer = @"3.1";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
            displayLinkSupported = TRUE;
    }
	

    return self;
}

-(void)initOpenGLES {
	printf("EAGLView: Initialize OpenGL ES 1.1\n");
	context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	[EAGLContext setCurrentContext:context];
	
	GLuint framebuffer;
	glGenFramebuffersOES(1, &framebuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, framebuffer);
	
	GLuint colorRenderbuffer;
	glGenRenderbuffersOES(1, &colorRenderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
	
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
	
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	
	glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

- (void)tick:(id)sender
{	
	float dt = 1.f/60.f;
	[game tick:dt];
	[game render:dt];
	
	//usleep(400000);
	
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)layoutSubviews
{
	printf("EAGLView: Setup bounds.\n");
	
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];

	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &width);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &height);
	
	[self setupView];
	
    [self tick:nil];
}

-(void)setupView {
	printf("EAGLView: Setup view with size %d %d\n", width, height);
	
	glViewport(0, 0, width, height);
	
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
	glOrthof(0.0, 10.0, 15.0, 0.0, -1.0f, 1.0f);
    glMatrixMode(GL_MODELVIEW);
}

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    // Frame interval defines how many display frames must pass between each time the
    // display link fires. The display link will only fire 30 times a second when the
    // frame internal is two on a display that refreshes 60 times a second. The default
    // frame interval setting of one will fire 60 times a second when the display refreshes
    // at 60 times a second. A frame interval setting of less than one results in undefined
    // behavior.
    if (frameInterval >= 1)
    {
        animationFrameInterval = frameInterval;

        if (animating)
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!animating)
    {
        if (displayLinkSupported)
        {
            // CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
            // if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
            // not be called in system versions earlier than 3.1.

            displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(tick:)];
            [displayLink setFrameInterval:animationFrameInterval];
            [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
			
			printf("EAGLView: Started DisplayLink timer.\n");
        }
        else {
            animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(tick:) userInfo:nil repeats:TRUE];
			
			printf("EAGLView: Started NSTimer.\n");
		}

        animating = TRUE;
    }
}

- (void)stopAnimation
{
    if (animating)
    {
        if (displayLinkSupported)
        {
            [displayLink invalidate];
            displayLink = nil;
        }
        else
        {
            [animationTimer invalidate];
            animationTimer = nil;
        }

        animating = FALSE;
    }
}

- (void)dealloc
{
	[game release];

    [super dealloc];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {	
	CGPoint pos = [[touches anyObject] locationInView:nil];

	CGPoint newPos;
	newPos.x = pos.y;
	newPos.y = self.frame.size.width - pos.x;
	
	[game downAt:newPos];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[game up];
}

@end
