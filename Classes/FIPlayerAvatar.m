//
//  PlayerAvatar.m
//  FireNIce
//
//  Created by Per Borgman on 2010-05-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FIPlayerAvatar.h"

#import <OpenGLES/ES1/gl.h>

#import "FIGame.h"
#import "FIStage.h"
#import "FIIceBlock.h"
#import "FISprite.h"

@implementation FIPlayerAvatar

-(id)initWithX:(int)_x y:(int)_y stage:(FIStage*)theStage {
	if(![super initWithX:_x y:_y stage:theStage]) return nil;
			
	direction = FIEntityDirectionRight;
	state = FIEntityStateResting;
	
	fallSpeed = 4.0f;
	jumpSpeed = 4.0f;
	
	shouldMove = NO;
  
  [self buildMesh];
	
	return self;
}
	

-(void)buildMesh {
  printf("Buildmesh");
  [gfx release];
  gfx = [[FISprite alloc] initWithTexture:[stage.game texture:FITextureTypePlayer]];
  FISprite *spr = (FISprite*)gfx;
  [spr createAnimation:@"stand" start:0 end:0 rate:0.0f];
  [spr createAnimation:@"run" start:0 end:1 rate:8.0f];
  [spr createAnimation:@"magic" start:2 end:3 rate:10.0f];
  [spr setAnimationTo:@"stand"];
}


-(void)updateState:(float)dt {
	if (state == FIAvatarStateJumping) {
		if(tilePos.y > goal.y) {
			// Phase 1, jump up
			position.y -= jumpSpeed * dt;
			if(position.y < goal.y) {
				tilePos.y = goal.y;
				position.y = goal.y;
			}
		}
		
		if(tilePos.y == goal.y) {
			// Phase 2, sideways
			float speed = jumpSpeed * (direction == FIEntityDirectionLeft ? -1. : 1.);
			position.x += speed * dt;
			
			if((direction == FIEntityDirectionRight && position.x >= goal.x) ||
			   (direction == FIEntityDirectionLeft && position.x < goal.x)) {
				[self reachedGoal];
			}
		}
	}
}


-(BOOL)shouldMove {
	return shouldMove;	// Don't want to run [stage playerMayMove] here.
}

-(void)stop {
  [(FISprite*)gfx setAnimationTo:@"stand"];
  [super stop];
}


-(void)collidedWithWall:(FICollisionResult)solid offset:(int)offset {	
	// Push ice
	if(solid.type == FICollisionTypeIce) {
		FICollisionResult behind = [stage getCollisionAtX:tilePos.x+(offset*2) y:tilePos.y];
		FIIceBlock *block = solid.obstacle;
		
		if(block.size == 1 && !behind.solid) {
			[block pushInDirection:direction];
			[self stop];
			shouldMove = NO;
			return;
		}
	}
	
	// Wall there, check if we can jump
	FICollisionResult jumpColUp = [stage getCollisionAtX:tilePos.x y:tilePos.y-1];
	FICollisionResult jumpColSide = [stage getCollisionAtX:tilePos.x+offset y:tilePos.y-1];
	if(!jumpColUp.solid && !jumpColSide.solid && !solid.fire) {
		state = FIAvatarStateJumping;
		position.x = tilePos.x;
		goal.x = tilePos.x+offset;
		goal.y = tilePos.y-1;
	} else {
		[self stop];
	}
}

-(void)collidedWithFire:(FICollisionResult)fire {
	[stage playerDied];
}

-(void)moveLeft {
	printf("moveLeft\n");
	if(direction == FIEntityDirectionLeft) {
		wantDir = FIEntityDirectionLeft;
		shouldMove = YES;
    [(FISprite*)gfx setAnimationTo:@"run"];
	} else if(state == FIEntityStateResting) {
		direction = FIEntityDirectionLeft;
		shouldMove = NO;
    [(FISprite*)gfx flip:YES];
	}
}


-(void)moveRight {
	if(direction == FIEntityDirectionRight) {
		wantDir = FIEntityDirectionRight;
		shouldMove = YES;
    [(FISprite*)gfx setAnimationTo:@"run"];
	} else if(state == FIEntityStateResting) {
		direction = FIEntityDirectionRight;
		shouldMove = NO;
    [(FISprite*)gfx flip:NO];
	}
}

-(void)magic {
  [(FISprite*)gfx setAnimationTo:@"magic"];
  [(FISprite*)gfx onAnimationOverTarget:self action:@selector(stopMagic)];
}

-(void)stopMagic {
  [(FISprite*)gfx setAnimationTo:@"stand"];
}


-(void)stopMoving {
	shouldMove = NO;
}



@end
