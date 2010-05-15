//
//  PlayerAvatar.m
//  FireNIce
//
//  Created by Per Borgman on 2010-05-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FIPlayerAvatar.h"

#import <OpenGLES/ES1/gl.h>

#import "FIStage.h"
#import "FIIceBlock.h"

@implementation FIPlayerAvatar

-(id)initWithX:(int)_x y:(int)_y stage:(FIStage*)theStage {
	if(![super initWithX:_x y:_y stage:theStage]) return nil;
			
	direction = FIEntityDirectionRight;
	state = FIEntityStateResting;
	
	fallSpeed = 4.0f;
	jumpSpeed = 4.0f;
	
	shouldMove = NO;
	
	return self;
}


-(void)render {
	static const GLfloat squareVertices[] = {
        0.f,  0.f,
		1.f,  0.f,
        0.f,  1.f,
		1.f,  1.f,
    };
	
	static const GLfloat coords[] = {
		0.0f,	0.0f,
		1.0f,	0.0f,
		0.0f,	1.0f,
		1.0f,	1.0f
	};
		
	glTranslatef(position.x, position.y, 0.0f);
	if(direction == FIEntityDirectionLeft) {
		glTranslatef(1.0f, 0.0f, 0.0f);
		glScalef(-1.f, 1.0f, 1.0f);
	}
	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	
	glVertexPointer(2, GL_FLOAT, 0, squareVertices);
	glTexCoordPointer(2, GL_FLOAT, 0, coords);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
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


-(void)moveLeft {
	if(direction == FIEntityDirectionLeft) {
		wantDir = FIEntityDirectionLeft;
		shouldMove = YES;
	} else if(state == FIEntityStateResting) {
		direction = FIEntityDirectionLeft;
		shouldMove = NO;
	}
}


-(void)moveRight {
	if(direction == FIEntityDirectionRight) {
		wantDir = FIEntityDirectionRight;
		shouldMove = YES;
	} else if(state == FIEntityStateResting) {
		direction = FIEntityDirectionRight;
		shouldMove = NO;
	}
}


-(void)stopMoving {
	shouldMove = NO;
}

@end
