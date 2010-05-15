//
//  FIFire.m
//  FireNIce
//
//  Created by Per Borgman on 2010-05-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FIFire.h"

#import <OpenGLES/ES1/gl.h>

#import "FIOil.h"
#import "FISprite.h"
#import "FIGame.h"

@implementation FIFire

-(id)initWithX:(int)_x y:(int)_y stage:(FIStage*)theStage {
	if(![super initWithX:_x y:_y stage:theStage]) return nil;
	
	[self buildMesh];
	
	return self;
}

-(void)buildMesh {
	[gfx release];
	gfx = [[FISprite alloc] initWithTexture:[stage.game texture:FITextureTypeFire] frames:4 rate:15.0f];
}


-(void)landedOn:(FICollisionResult)floor {
	if(floor.type != FICollisionTypeOil) return;
	((FIOil*)floor.obstacle).burning = YES;
}

@end
