//
//  FIStage.m
//  FireNIce
//
//  Created by Per Borgman on 2010-05-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FIStage.h"

#import <OpenGLES/ES1/gl.h>

#import "FIGame.h"
#import "FIEntity.h"
#import "FIMesh.h"
#import "FIPlayerAvatar.h"
#import "FIIceBlock.h"
#import "FIFire.h"
#import "FIOil.h"
#import "FITempSprite.h"
#import "FISprite.h"

@implementation FIStage

@synthesize game, avatar;

-(id)initWithGame:(FIGame*)theGame {
	if(![super init]) return nil;
	
	printf("Initialize Stage.\n");
	
	game = theGame;
	
	mesh = NULL;
	
	int map2[] = {
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,	// 0
		1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
		1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0,
		1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0,	// 3
		1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0,
		1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,	// 5
		1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,	// 7
		0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	// 9
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1	// 11
	};
	
	
	int map[] = {
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	// 0
		0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,	// 2
		0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0,	// 4
		0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0,	// 6
		1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0,
		0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0,	// 8
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	// 10
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	};
	//	0     2     4     6     8    10 11    13
	
	memcpy(walls, map, sizeof(int)*MAP_SIZE);
	
	[self rebuild];
	
	iceBlocks = [[NSMutableArray alloc] init];
	flames = [[NSMutableArray alloc] init];
	oils = [[NSMutableArray alloc] init];
	temps = [[NSMutableArray alloc] init];
	//stones = [[NSMutableArray alloc] init];
	
	[iceBlocks addObject:[FIIceBlock blockWithX:3 y:2 length:1 isFixedLeft:YES isFixedRight:YES stage:self]];
	//[iceBlocks addObject:[FIIceBlock blockWithX:2 y:5 length:1 isFixedLeft:NO isFixedRight:NO stage:self]];

	/*
	[iceBlocks addObject:[FIIceBlock blockWithX:2 y:5 length:1 isFixedLeft:NO isFixedRight:NO stage:self]];
	[iceBlocks addObject:[FIIceBlock blockWithX:4 y:5 length:1 isFixedLeft:NO isFixedRight:NO stage:self]];
	[iceBlocks addObject:[FIIceBlock blockWithX:7 y:5 length:1 isFixedLeft:NO isFixedRight:NO stage:self]];
	[iceBlocks addObject:[FIIceBlock blockWithX:7 y:4 length:1 isFixedLeft:NO isFixedRight:NO stage:self]];
	[iceBlocks addObject:[FIIceBlock blockWithX:7 y:3 length:2 isFixedLeft:NO isFixedRight:YES stage:self]];
	[iceBlocks addObject:[FIIceBlock blockWithX:6 y:2 length:1 isFixedLeft:YES isFixedRight:NO stage:self]];
	*/
	
	[flames addObject:[[[FIFire alloc] initWithX:11 y:3 stage:self] autorelease]];
	[flames addObject:[[[FIFire alloc] initWithX:3 y:1 stage:self] autorelease]];
	
	[oils addObject:[[[FIOil alloc] initWithX:3 y:5 burning:NO stage:self] autorelease]];
	
	avatar = [[FIPlayerAvatar alloc] initWithX:7 y:2 stage:self];
	
	return self;
}


-(void)rebuild {
	[background release];
	[mesh release];

	background = [[FIMesh alloc] initWithMode:GL_TRIANGLES texture:[game texture:FITextureTypeLevel] numberOfTiles:MAP_SIZE];
	mesh = [[FIMesh alloc] initWithMode:GL_TRIANGLES texture:[game texture:FITextureTypeLevel] numberOfTiles:MAP_SIZE subTiled:YES];
			
	for(int y=0; y<MAP_HEIGHT; y++) {
		for(int x=0; x<MAP_WIDTH; x++) {
			
			[background addQuad:CGPointMake(x, y) withTextureOffset:14];
			
			if(walls[y*MAP_WIDTH + x] > 0) {
				
				int left = [self getWallAtX:x-1 y:y];
				int right = [self getWallAtX:x+1 y:y];
				int up = [self getWallAtX:x y:y-1];
				int upLeft = [self getWallAtX:x-1 y:y-1];
				int upRight = [self getWallAtX:x+1 y:y-1];
				int down = [self getWallAtX:x y:y+1];
				
				int ul = 0;
				int ur = 0;
				int bl = 0;
				int br = 0;
				
				if(up==0 && down==0) {
					if(left==0) ul = bl = 6;
					else if(upLeft==1) { ul = bl = 13; }
					else { ul = 1; bl = 3; }
					if(right==0) ur = br = 7;
					else if(upRight==1) ur = br = 13;
					else { ur = 1; br = 3; }
					
				} else if(up==0) {
					if(left==0) { ul = bl = 8; }
					else if(upLeft==1) { ul = bl = 12; }
					else ul = bl = 1; 
					if(right==0) ur = br = 9;
					else if(upRight==1) { ur = br = 12; }
					else ur = br = 1;
					
				} else if(down==0) {
					if(left==0) bl = ul = 10;
					else bl = ul = 2;
					if(right==0) br = ur = 11;
					else br = ur = 2;
					
				} else {
					if(left==0 && right==1) ul = bl = ur = br = 4;
					if(left==1 && right==0) ul = bl = ur = br = 5;
					else if(left==0 && right==0) { ul = bl = 4; ur = br = 5; }
				}
				
				//[mesh addQuad:CGPointMake(x, y) withTextureOffset:u];
				[mesh addSubtiledSquad:CGPointMake(x,y) ul:ul ur:ur bl:bl br:br];
			}
		}
	}
}


-(void)tick:(float)dt {
	for(FIIceBlock *block in iceBlocks)
		[block tick:dt];
	
	for(FIFire *flame in flames)
		[flame tick:dt];
	
	for(FIOil *oil in oils)
		[oil tick:dt];
	
	for(FIEntity *temp in temps)
		[temp tick:dt];
	
	[avatar tick:dt];
}


-(void)render {
	[background render];
	[mesh render];
		
	for(FIIceBlock *block in iceBlocks)
		[block render];
	
	for(FIFire *flame in flames)
		[flame render];
	
	for(FIOil *oil in oils)
		[oil render];
	
	for(FIEntity *temp in temps)
		[temp render];
	
	[avatar render];
}


-(void)removeTemp:(FIEntity*)temp {
	[temps removeObject:temp];
}


-(BOOL)playerMayMove {	
	for(FIIceBlock *block in iceBlocks)
		if(block.state != FIEntityStateResting) return NO;
	
	for(FIFire *flame in flames)
		if(flame.state != FIEntityStateResting) return NO;
	
	return YES;
}


-(void)doRemoveIce {
	[self removeIce:toToggleIce atX:toToggleX y:toToggleY magic:YES];
}


-(void)removeIce:(FIIceBlock*)targ atX:(int)x y:(int)y magic:(BOOL)magic {
	if(targ.size == 1) {
		[iceBlocks removeObject:targ];
		return;
	}
	
	FICollisionResult left = [self getCollisionAtX:x-1 y:y];
	FICollisionResult right = [self getCollisionAtX:x+1 y:y];
	
	BOOL iceLeft = left.type == FICollisionTypeIce;
	BOOL iceRight = right.type == FICollisionTypeIce;
		
	if(iceLeft && iceRight) {
		// Merge/split
		FIIceBlock *lIce = left.obstacle;
		FIIceBlock *rIce = right.obstacle;
		
		if(targ == rIce && targ == lIce) {
			// Split a large ice block
			int length = (targ.tilePos.x + targ.size - x) - 1;
			
			[iceBlocks addObject:[[[FIIceBlock alloc] initWithX:x+1 y:y length:length isFixedLeft:NO isFixedRight:targ.fixedRight stage:self] autorelease]];
			
			lIce.size = x - lIce.tilePos.x;
			
			return;
		}
	} 
	
	if (iceLeft) {
		FIIceBlock *lIce = left.obstacle;
		
		if(lIce == targ) {
			lIce.fixedRight = NO;
			lIce.size--;
			return;
		}
	} 
	
	if (iceRight) {
		FIIceBlock *rIce = right.obstacle;
		
		if(rIce == targ) {
			rIce.fixedLeft = NO;
			rIce.size--;
			[rIce moveX:1];
			return;
		}
	}
}


-(void)doAddIce {
	[self addIceAtX:toToggleX y:toToggleY];
}


-(void)addIceAtX:(int)x y:(int)y {
	// YAY!
	FICollisionResult left = [self getCollisionAtX:x-1 y:y];
	FICollisionResult right = [self getCollisionAtX:x+1 y:y];
	
	BOOL iceLeft = left.type == FICollisionTypeIce;
	BOOL iceRight = right.type == FICollisionTypeIce;
	
	if(iceLeft && iceRight) {
		// Merge
		FIIceBlock *lIce = left.obstacle;
		FIIceBlock *rIce = right.obstacle;
		
		lIce.fixedRight = rIce.fixedRight;
		lIce.size = lIce.size + rIce.size + 1;
		
		[iceBlocks removeObject:rIce];
	} else if (iceLeft) {
		FIIceBlock *lIce = left.obstacle;
		
		lIce.fixedRight = right.solid;
		lIce.size++;
	} else if (iceRight) {
		FIIceBlock *rIce = right.obstacle;
		
		rIce.fixedLeft = left.solid;
		rIce.size++;
		[rIce moveX:-1];
	} else {
		[iceBlocks addObject:[[[FIIceBlock alloc] initWithX:x y:y length:1 isFixedLeft:left.solid isFixedRight:right.solid stage:self] autorelease]];
	}	
}


-(void)toggleIceAtX:(int)x y:(int)y magic:(BOOL)magic {
	FIIceBlock *targ = [self getIceAtX:x y:y ignore:nil];
	
	if(targ) {
		if(magic) {
			toToggleIce = targ;
			toToggleX = x;
			toToggleY = y;
			
			FISprite *spr = [[FISprite alloc] initWithTexture:[game texture:FITextureTypeMagic]];
			[spr createAnimation:@"full" start:4 end:0 rate:20.0f];
			[spr setAnimationTo:@"full"];
			FITempSprite *magic = [[FITempSprite alloc] initWithX:x y:y sprite:spr stage:self];
			[magic onAnimationOverTarget:self action:@selector(doRemoveIce)];
			[temps addObject:magic];
			[spr release];
		}	
		return;
	}
	
	// No ice there. Can we create?
	FICollisionResult on = [self getCollisionAtX:x y:y];
	FICollisionResult under = [self getCollisionAtX:x y:y+1];
	
	if(on.fire || under.type == FICollisionTypeBurningOil) return;
	if(on.type != FICollisionTypeNone) return;
	
	toToggleIce = targ;
	toToggleX = x;
	toToggleY = y;
	
	printf("Did magic\n");
	FISprite *spr = [[FISprite alloc] initWithTexture:[game texture:FITextureTypeMagic] frames:5 rate:20.0f];
	FITempSprite *tmpmagic = [[FITempSprite alloc] initWithX:x y:y sprite:spr stage:self];
	[tmpmagic onAnimationOverTarget:self action:@selector(doAddIce)];
	[temps addObject:tmpmagic];
	[spr release];
}


-(void)toggleIce {
	if(avatar.state != FIEntityStateResting) return;
	
	if(avatar.direction == FIEntityDirectionLeft)
		[self toggleIceAtX:avatar.tilePos.x-1 y:avatar.tilePos.y+1 magic:YES];
	else
		[self toggleIceAtX:avatar.tilePos.x+1 y:avatar.tilePos.y+1 magic:YES];
}


-(void)ice:(FIIceBlock*)theIce collidedWithFire:(FICollisionResult)fire {
	FIEntity *ent = fire.obstacle;
		
	[self removeIce:theIce atX:ent.tilePos.x y:theIce.tilePos.y magic:NO];
	
	if(fire.type == FICollisionTypeFire)
		[flames removeObject:ent];
}


-(FICollisionResult)getCollisionAtX:(int)x y:(int)y {
	return [self getCollisionAtX:x y:y ignore:nil];
}

-(FICollisionResult)getCollisionAtX:(int)x y:(int)y ignore:(FIEntity*)ignore {
	FICollisionResult res;
	res.type = FICollisionTypeNone;
	res.solid = NO;
	res.fire = NO;
	res.obstacle = nil;
	
	if(x < 0 || x >= MAP_WIDTH || y < 0 || y >= MAP_HEIGHT) {
		res.solid = YES;
		res.type = FICollisionTypeWall;
		return res;
	}
	
	int wall = [self getWallAtX:x y:y];
	if(wall > 0) {
		res.solid = YES;
		res.type = FICollisionTypeWall;
		return res;
	}
	
	FIOil *oil = [self getOilAtX:x y:y ignore:ignore];
	if(oil) {
		if(oil.burning) {
			res.type = FICollisionTypeBurningOil;
			res.fire = YES;
		} else
			res.type = FICollisionTypeOil;
		res.solid = YES;
		res.obstacle = oil;
		return res;
	}			
	
	FIFire *fire = [self getFireAtX:x y:y ignore:ignore];
	if(fire) {
		res.type = FICollisionTypeFire;
		res.fire = YES;
		res.obstacle = fire;
		return res;
	}
	
	if(x == avatar.tilePos.x && y == avatar.tilePos.y && avatar != ignore) {
		res.solid = YES;
		res.type = FICollisionTypeWall;
		res.obstacle = avatar;
		return res;
	}
	
	FIIceBlock *ice = [self getIceAtX:x y:y ignore:ignore];
	if(ice) {
		res.solid = YES;
		res.type = FICollisionTypeIce;
		res.obstacle = ice;
		return res;
	}
	
	return res;
}

-(int)getWallAtX:(int)x y:(int)y {
	if(x<0 || y<0 || x>=MAP_WIDTH || y>=MAP_HEIGHT) return 1;
	return walls[y*MAP_WIDTH + x];
}

-(FIIceBlock*)getIceAtX:(int)x y:(int)y ignore:(FIEntity*)ignore {
	for(FIIceBlock *block in iceBlocks) {
		if(block != ignore && [block hasIceAtX:x y:y]) return block;
	}
	return nil;
}

-(FIFire*)getFireAtX:(int)x y:(int)y ignore:(FIEntity*)ignore {
	for(FIFire *flame in flames)
		if(flame != ignore && flame.tilePos.x == x && flame.tilePos.y == y) return flame;
	return nil;
}

-(FIOil*)getOilAtX:(int)x y:(int)y ignore:(FIEntity*)ignore {
	for(FIOil *oil in oils)
		if(oil != ignore && oil.tilePos.x == x && oil.tilePos.y == y) return oil;
	return nil;
}


@end
