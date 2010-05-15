//
//  IceBlock.m
//  FireNIce
//
//  Created by Per Borgman on 2010-05-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FIIceBlock.h"

#import <OpenGLES/ES1/gl.h>

#import "FIGame.h"
#import "FIStage.h"
#import "FITexture.h"
#import "FIMesh.h"

@implementation FIIceBlock

@synthesize fixedLeft, fixedRight;


+(FIIceBlock*)blockWithX:(int)_x y:(int)_y length:(int)_length isFixedLeft:(BOOL)fL isFixedRight:(BOOL)fR stage:(FIStage*)theStage {
	return [[[FIIceBlock alloc] initWithX:_x y:_y length:_length isFixedLeft:fL isFixedRight:fR stage:theStage] autorelease];
}

-(id)initWithX:(int)_x y:(int)_y
		length:(int)_length
   isFixedLeft:(BOOL)_fixedLeft
  isFixedRight:(BOOL)_fixedRight
		 stage:(FIStage*)theStage {
	if(![super initWithX:_x y:_y stage:theStage]) return nil;
		
	size = _length;
		
	fixedLeft = _fixedLeft;
	fixedRight = _fixedRight;
	
	moveSpeed = 5.0f;
	
	pushed = NO;
	
	[self buildMesh];
	
	return self;
}


-(void)setSize:(int)newSize {
	size = newSize;
	[self buildMesh];
}


-(void)buildMesh {
	[gfx release];
	gfx = [[FIMesh alloc] initWithMode:GL_TRIANGLES texture:[stage.game texture:FITextureTypeIce] numberOfTiles:size];
	FIMesh *mesh = (FIMesh*)gfx;
	for (int i=0; i<size; i++) {
		int u;
		if(size == 1 && !fixedLeft && !fixedRight) u = 3;
		else if(size == 1 && fixedLeft && fixedRight) u = 0;
		else if(size == 1 && fixedLeft)	u = 2;
		else if(size == 1 && fixedRight) u = 1;
		else if(i==0 && !fixedLeft)	u = 1;
		else if(i==size-1 && !fixedRight)	u = 2;
		else			u = 0;
		
		[mesh addQuad:CGPointMake(i, 0.0f) withTextureOffset:u];
	}
}
	

-(BOOL)shouldFall {
	if(fixedLeft || fixedRight) return NO;
	pushed = NO;
	return YES;
}


-(BOOL)shouldMove {
	return pushed;
}


-(void)pushInDirection:(FIEntityDirection)dir {
	wantDir = dir;
	pushed = YES;
}


-(void)collidedWithWall:(FICollisionResult)solid offset:(int)offset {
	[super collidedWithWall:solid offset:offset];
	pushed = NO;
}


-(void)collidedWithFire:(FICollisionResult)fire {
	printf("I collided with fire.\n");
	[stage ice:self collidedWithFire:fire];
}


-(BOOL)hasIceAtX:(int)_x y:(int)_y {
	if(tilePos.y == _y && _x >= tilePos.x && _x < tilePos.x+size) return YES;
	//if(goal.y == _y && _x >= goal.x && _x < goal.x+length) return YES;
	return NO;
}


-(void)moveX:(int)dist {
	tilePos.x += dist;
	goal = tilePos;
	position.x = tilePos.x;
}

@end
