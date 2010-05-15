//
//  PlayerAvatar.h
//  FireNIce
//
//  Created by Per Borgman on 2010-05-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FIEntity.h"

#import "FIStage.h"

typedef enum {
	FIAvatarStateJumping = FIEntityStateCustom,
} FIAvatarState;

@interface FIPlayerAvatar : FIEntity {
	float	jumpSpeed;
	
	BOOL			shouldMove;
}

-(id)initWithX:(int)_x y:(int)_y stage:(FIStage*)theStage;

-(void)render;

-(void)updateState:(float)dt;

-(BOOL)shouldMove;
-(void)collidedWithWall:(FICollisionResult)solid offset:(int)offset;

-(void)moveLeft;
-(void)moveRight;
-(void)stopMoving;

@end
