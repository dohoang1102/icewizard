//
//  FIStage.h
//  FireNIce
//
//  Created by Per Borgman on 2010-05-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenGLES/ES1/gl.h>

typedef enum {
	FICollisionTypeNone,
	FICollisionTypeWall,
	FICollisionTypeIce,
	FICollisionTypeOil,
	FICollisionTypeBurningOil,
	FICollisionTypeStone,
	FICollisionTypePipe,
	FICollisionTypeFire
} FICollisionType;

typedef struct {
	FICollisionType	type;
	BOOL			solid;		// Wall, ice, oil, burning oil, stone, pipe
	BOOL			fire;		// Burning oil, fire
	id				obstacle;
} FICollisionResult;

#define MAP_WIDTH	14
#define MAP_HEIGHT	12
#define MAP_SIZE	MAP_WIDTH * MAP_HEIGHT

@class FIGame;
@class FIEntity;
@class FIMesh;
@class FIIceBlock;
@class FIFire;
@class FIPlayerAvatar;
@class FIOil;

@interface FIStage : NSObject {
	FIGame			*game;
	
	int				walls[168];
	
	FIMesh			*background;
	FIMesh			*mesh;
	
	NSMutableArray	*iceBlocks;
	NSMutableArray	*stones;
	NSMutableArray	*flames;
	NSMutableArray	*oils;
	
	NSMutableArray  *temps;
	
	FIPlayerAvatar	*avatar;
	
	FIIceBlock		*toToggleIce;
	int				toToggleX, toToggleY;
}

@property (nonatomic,readonly) FIGame *game;
@property (nonatomic,readonly) FIPlayerAvatar *avatar;

-(id)initWithGame:(FIGame*)theGame;
-(void)rebuild;

-(void)tick:(float)dt;
-(void)render;

-(void)removeTemp:(FIEntity*)temp;

-(BOOL)playerMayMove;

-(void)addIceAtX:(int)x y:(int)y;
-(void)removeIce:(FIIceBlock*)targ atX:(int)x y:(int)y magic:(BOOL)magic;
-(void)toggleIceAtX:(int)x y:(int)y magic:(BOOL)magic;
-(void)toggleIce;

-(void)ice:(FIIceBlock*)theIce collidedWithFire:(FICollisionResult)fire;

-(FICollisionResult)getCollisionAtX:(int)x y:(int)y;
-(FICollisionResult)getCollisionAtX:(int)x y:(int)y ignore:(FIEntity*)ignore;
-(int)getWallAtX:(int)x y:(int)y;
-(FIIceBlock*)getIceAtX:(int)x y:(int)y ignore:(FIEntity*)ignore;
-(FIFire*)getFireAtX:(int)x y:(int)y ignore:(FIEntity*)ignore;
-(FIOil*)getOilAtX:(int)x y:(int)y ignore:(FIEntity*)ignore;

@end
