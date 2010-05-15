//
//  IceBlock.h
//  FireNIce
//
//  Created by Per Borgman on 2010-05-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FIEntity.h"

typedef enum {
	FIIceStateResting,
	FIIceStateFalling,
	FIIceStateMovingLeft,
	FIIceStateMovingRight
} FIIceState;

@class FIEntity;

@interface FIIceBlock : FIEntity {
	BOOL	fixedLeft, fixedRight;
	BOOL	pushed;
}

@property (nonatomic) BOOL fixedLeft;
@property (nonatomic) BOOL fixedRight;

+(FIIceBlock*)blockWithX:(int)_x y:(int)_y length:(int)_length isFixedLeft:(BOOL)fL isFixedRight:(BOOL)fR stage:(FIStage*)theStage;

-(id)initWithX:(int)_x y:(int)_y length:(int)_length isFixedLeft:(BOOL)_fixedLeft isFixedRight:(BOOL)_fixedRight stage:(FIStage*)theStage;

-(void)buildMesh;

-(BOOL)shouldFall;
-(BOOL)shouldMove;

-(void)pushInDirection:(FIEntityDirection)dir;
-(void)collidedWithWall:(FICollisionResult)solid offset:(int)offset;
-(void)collidedWithFire:(FICollisionResult)fire;

-(BOOL)hasIceAtX:(int)_x y:(int)_y;
-(void)moveX:(int)dist;

@end
