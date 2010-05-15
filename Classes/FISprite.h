//
//  FISprite.h
//  FireNIce
//
//  Created by Per Borgman on 2010-05-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenGLES/ES1/gl.h>

#import "FIDrawable.h"

@class FITexture;

@interface FISpriteAnimation : NSObject {
	int		start;
	int		end;
	float	fps;
}

-(id)initWithStart:(int)start end:(int)end fps:(float)fps;

@property (nonatomic,readonly) int start;
@property (nonatomic,readonly) int end;
@property (nonatomic,readonly) float fps;

@end

@interface FISprite : NSObject<FIDrawable> {
	FITexture	*texture;
	
	int		startFrame;
	int		endFrame;
	float	fps;
	float	textureStep;
	
	int		frame;
	float	frame_f;
	
	GLfloat	mesh[8];
	
	NSMutableDictionary *animations;
	
	id		target;
	SEL		action;
}

-(id)initWithTexture:(FITexture*)tex;
-(id)initWithTexture:(FITexture*)tex frames:(int)max rate:(float)rate;

-(void)createAnimation:(NSString*)name start:(int)start end:(int)end rate:(float)rate;
-(void)setAnimationTo:(NSString*)animationName;

-(void)tick:(float)dt;
-(void)render;

-(void)onAnimationOverTarget:(id)_target action:(SEL)_action;


@end
