//
//  FIEntity.m
//  FireNIce
//
//  Created by Per Borgman on 2010-05-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FIEntity.h"

#import "FIStage.h"

@implementation FIEntity

@synthesize tilePos, position, direction, wantDir, state, size;

-(id)initWithX:(int)_x y:(int)_y stage:(FIStage*)theStage {
	if(![super init]) return nil;
	
	stage = theStage;
	
	tilePos.x = _x;
	tilePos.y = _y;
	goal = tilePos;
	
	position.x = tilePos.x;
	position.y = tilePos.y;
	
	size = 1;
	
	state = FIEntityStateResting;
	
	moveSpeed = 3.0f;
	fallSpeed = 5.0f;
	
	isStatic = NO;
	onFloor = NO;
			
	return self;
}


-(void)tick:(float)dt {
	[gfx tick:dt];
	
	if(isStatic) return;
	
	if (state == FIEntityStateResting) {
		[self evaluateSurroundings];
	} else if (state == FIEntityStateMoving) {
		if(direction == FIEntityDirectionLeft)
			position.x -= moveSpeed * dt;
		else
			position.x += moveSpeed * dt;
		
		// Reached goal!
		if((direction == FIEntityDirectionRight && position.x >= goal.x) ||
		   (direction == FIEntityDirectionLeft && position.x < goal.x)) {
			[self reachedGoal];
		}
	} else if (state == FIEntityStateFalling) {
		position.y += fallSpeed * dt;
		
		if(position.y >= goal.y)
			[self reachedGoal];
	} else {
		[self updateState:dt];
	}
}

-(void)render {
	glPushMatrix();
	glTranslatef(position.x, position.y, 0.0f);
	
	[gfx render];
	
	glPopMatrix();
}

-(void)buildMesh {}

-(void)updateState:(float)dt {}


-(void)stop {
	state = FIEntityStateResting;
	tilePos = goal;
	position.x = tilePos.x;
	position.y = tilePos.y;
}


-(void)reachedGoal {
	// Avatar has reached goal, either by moving or falling.	
	tilePos = goal;
	
	if(![self evaluateSurroundings])
		// Stand still
		[self stop];		
}


-(BOOL)evaluateSurroundings {
	
	// Then, check hazards
	for(int i=0; i<size; i++) {
		FICollisionResult on = [stage getCollisionAtX:tilePos.x+i y:tilePos.y ignore:self];
		FICollisionResult floor = [stage getCollisionAtX:tilePos.x+i y:tilePos.y+1];

		if(on.fire || floor.type == FICollisionTypeBurningOil) {
			[self collidedWithFire:on];
			return YES;
		}
	}
	
	// There's no floor, should I fall?
	if(![self onFloor] && [self shouldFall]) {
		state = FIEntityStateFalling;
		goal.y = tilePos.y+1;
		position.x = tilePos.x;
		onFloor = NO;
		return YES;
	}
	
	// I have landed
	if(!onFloor) {
		[self landedOn:[stage getCollisionAtX:tilePos.x y:tilePos.y+1]];
		onFloor = YES;
	}
	
	// Everything seems to be okay, I'll try to move if I want to.
	if([self shouldMove]) {
		[self setNewGoal];
		position.y = tilePos.y;
		return YES;
	}
	
	return NO;
}


-(BOOL)onFloor {
	for(int i=0; i<size; i++) {
		if([stage getCollisionAtX:tilePos.x+i y:tilePos.y+1].solid) return YES;
	}
	return NO;
}


-(BOOL)shouldMove {
	return NO;
}


-(BOOL)shouldFall {
	return YES;
}


-(void)setNewGoal {
	direction = wantDir;
	int offset = direction == FIEntityDirectionLeft ? -1 : 1;
	
	FICollisionResult col = [stage getCollisionAtX:tilePos.x+offset y:tilePos.y];
	if(!col.solid) {
		state = FIEntityStateMoving;
		goal.x = tilePos.x+offset;
		goal.y = tilePos.y;
	} else {
		[self collidedWithWall:col offset:offset];
	}
}


-(void)collidedWithWall:(FICollisionResult)solid offset:(int)offset {
	[self stop];
}

-(void)collidedWithFire:(FICollisionResult)fire {}

-(void)landedOn:(FICollisionResult)floor {}


@end
