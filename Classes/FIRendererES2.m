//
//  FIRendererES2.m
//  FireNIce
//
//  Created by Per Borgman on 2010-05-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FIRendererES2.h"


@implementation FIRendererES2

-(id)initWithGame:(FIGame*)theGame {
	if (![super initWithGame:theGame]) return nil;
	
	printf("FIRendererES2: Initialize...\n");

	context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	if (!context || ![EAGLContext setCurrentContext:context])
	{
		[self release];
		return nil;
	}
	
	// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
	glGenFramebuffers(1, &defaultFramebuffer);
	glGenRenderbuffers(1, &colorRenderbuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
		
	[self setup];
	
    return self;
}	

@end
