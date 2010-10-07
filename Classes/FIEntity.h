//
//  FIEntity.h
//  FireNIce
//
//  Created by Per Borgman on 2010-05-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FIStage.h"
#import "FIDrawable.h"

typedef enum {
	FIEntityStateResting = 0,
	FIEntityStateMoving,
	FIEntityStateFalling,
	FIEntityStateCustom
} FIEntityState;

typedef enum {
	FIEntityDirectionLeft,
	FIEntityDirectionRight
} FIEntityDirection;

typedef struct {
	int		x, y;
} FITilePosition;

@class FIStage;
@class FIMesh;

@interface FIEntity : NSObject {
	FIStage		*stage;
	
	float		moveSpeed;
	float		fallSpeed;
	
	FITilePosition	tilePos;
	FITilePosition	goal;
	CGPoint			position;
	int				size;
	
	FIEntityDirection direction;
	FIEntityDirection wantDir;
	
	FIEntityState state;
	
	BOOL			isStatic;
	BOOL			onFloor;
	
	NSObject<FIDrawable>	*gfx;
}

@property (nonatomic) CGPoint position;
@property (nonatomic) FITilePosition tilePos;
@property (nonatomic) int size;
@property (nonatomic) FIEntityState state;
@property (nonatomic) FIEntityDirection direction;
@property (nonatomic) FIEntityDirection wantDir;

-(id)initWithX:(int)_x y:(int)_y stage:(FIStage*)theStage;

-(void)tick:(float)dt;
-(void)render:(float)dt;

-(void)buildMesh;
-(void)removeMesh;

-(void)stop;

-(void)reachedGoal;
-(BOOL)evaluateSurroundings;
-(void)setNewGoal;
-(BOOL)onFloor;

//
// Methods that subclasses may implement.
//

// updateState
// -----------
// Subclasses can parse their custom states here.
-(void)updateState:(float)dt;

// shouldMove
// ----------
// Called when entity has reached its goal.
// If YES, entity continues to move (or starts after a fall) in [wantDir] direction.
-(BOOL)shouldMove;

// shouldFall
// ----------
// Called when there is no floor at (x,y+1).
// Default impl. returns YES.
// Subclasses implement special conditions to prevent fall.
-(BOOL)shouldFall;

// collidedWithWall
// ----------------
// Called when bumping into a solid while moving.
// [offset] is where the wall is relative to the Entity.
// Default implementaion just stops.
-(void)collidedWithWall:(FICollisionResult)wall offset:(int)offset;

// collidedWithFire
// ----------------
// Called when touching fire.
-(void)collidedWithFire:(FICollisionResult)fire;

// landedOn
// --------
// Stopped falling.
-(void)landedOn:(FICollisionResult)floor;

@end
