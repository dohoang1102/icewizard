//
//  FISprite.m
//  FireNIce
//
//  Created by Per Borgman on 2010-05-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FISprite.h"

#import "FITexture.h"

@implementation FISpriteAnimation

@synthesize start, end, fps;

-(id)initWithStart:(int)_start end:(int)_end fps:(float)_fps {
	if(![super init]) return nil;
	
	start = _start;
	end = _end;
	fps = _fps;
		
	return self;
}

@end


@implementation FISprite

-(id)initWithTexture:(FITexture*)tex {
	return [self initWithTexture:tex frames:tex.width/16 rate:0.0f];
}

-(id)initWithTexture:(FITexture*)tex frames:(int)max rate:(float)rate {
	if(![super init]) return nil;
	
	animations = [[NSMutableDictionary alloc] init];
	
	texture = tex;
	textureStep = 16.0f / tex.width;
		
	mesh[0] = 0.0f;
	mesh[1] = 0.0f;
	mesh[2] = 1.0f;
	mesh[3] = 0.0f;
	mesh[4] = 0.0f;
	mesh[5] = 1.0f;
	mesh[6] = 1.0f;
	mesh[7] = 1.0f;
	
	[self createAnimation:@"full" start:0 end:max-1 rate:rate];
	[self setAnimationTo:@"full"];

	target = nil;
	
	return self;
}


-(void)dealloc {
	[animations release];
	
	[super dealloc];
}


-(void)tick:(float)dt {
	BOOL animationOver = NO;
	
	if(endFrame > startFrame) {
		frame_f += fps * dt;
		if((int)frame_f > endFrame) { frame_f = startFrame; animationOver = YES; }

	} else {
		frame_f -= fps * dt;
		if(frame_f < 0.0f) { frame_f = endFrame; animationOver = YES; }
	}
	
	if(animationOver && action != nil) {
		printf("Triggering onAnimationOver\n");
		[target performSelector:action];
    target = nil;
    action = nil;
    animationOver = NO;
	}
}

-(void)createAnimation:(NSString*)name start:(int)start end:(int)end rate:(float)rate {
	FISpriteAnimation *newAnim = [[FISpriteAnimation alloc] initWithStart:start end:end fps:rate];
	[animations setObject:newAnim forKey:name];
	[newAnim release];
}

-(void)setAnimationTo:(NSString*)animationName {
	FISpriteAnimation *anim = [animations objectForKey:animationName];
	if(anim) {
		startFrame = anim.start;
		endFrame = anim.end;
		fps = anim.fps;
		/*if(anim.start > anim.end)
			frame_f = startFrame + 1.0f;
		else
			frame_f = startFrame;*/
		frame_f = startFrame;
    
    target = nil;
    action = nil;
	}
}

-(void)render {
	frame = frame_f;
	
	float u = frame * textureStep;
  
  GLfloat coords[8];
  if(!flipped) {
    coords[0] = u;
    coords[1] = 0.0f;
    coords[2] = u+textureStep;
    coords[3] = 0.0f;
    coords[4] = u;
    coords[5] = 1.0f;
    coords[6] = u+textureStep;
    coords[7] = 1.0f;
  } else {
    coords[0] = u+textureStep;
    coords[1] = 0.0f;
    coords[2] = u;
    coords[3] = 0.0f;
    coords[4] = u+textureStep;
    coords[5] = 1.0f;
    coords[6] = u;
    coords[7] = 1.0f;
  }
  
	
	[texture use];
	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	glVertexPointer(2, GL_FLOAT, 0, mesh);
	glTexCoordPointer(2, GL_FLOAT, 0, coords);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

-(void)flip:(BOOL)f {
  flipped = f;
}

-(void)onAnimationOverTarget:(id)_target action:(SEL)_action {
	target = _target;
	action = _action;
	printf("Register onAnimationOver\n");
}

@end
