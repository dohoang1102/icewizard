//
//  FIOil.m
//  FireNIce
//
//  Created by Per Borgman on 2010-05-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FIOil.h"

#import <OpenGLES/ES1/gl.h>

#import "FIGame.h"
#import "FIStage.h"
#import "FISprite.h"

@implementation FIOil

@synthesize burning;

-(id)initWithX:(int)_x y:(int)_y stage:(FIStage*)theStage {
	return [self initWithX:_x y:_y burning:NO stage:theStage];
}

-(id)initWithX:(int)_x y:(int)_y burning:(BOOL)b stage:(FIStage*)theStage {
	if(![super initWithX:_x y:_y stage:theStage]) return nil;
	
	burning = b;
	
	isStatic = YES;
	
	[self buildMesh];
	
	return self;
}

-(void)buildMesh {
	[gfx release];
	gfx = [[FISprite alloc] initWithTexture:[stage.game texture:FITextureTypeOil]];
	FISprite *spr = (FISprite*)gfx;
	[spr createAnimation:@"unlit" start:0 end:0 rate:0.0f];
	[spr createAnimation:@"lit" start:1 end:3 rate:12.0f];
	if(burning)
		[spr setAnimationTo:@"lit"];
	else
		[spr setAnimationTo:@"unlit"];
}

-(void)setBurning:(BOOL)newVal {
	burning = newVal;
	if(burning)
		[(FISprite*)gfx setAnimationTo:@"lit"];
	else
		[(FISprite*)gfx setAnimationTo:@"unlit"];
}

@end
