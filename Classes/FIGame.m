//
//  FIGame.m
//  FireNIce
//
//  Created by Per Borgman on 2010-05-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FIGame.h"

#import "FIStage.h"
#import "FIPlayerAvatar.h"
#import "FITexture.h"

@implementation FIGame

@synthesize stage;

-(id)init {
	if(![super init]) return nil;
	
	printf("Initialize game.\n");
	
	[self loadTextures];
	stage = [[FIStage alloc] initWithGame:self];

	return self;
}

-(void)tick:(float)dt {
	[stage tick:dt];
}


-(void)render {
	glClear(GL_COLOR_BUFFER_BIT);
	glLoadIdentity();
	
	[stage render];
}


-(void)loadTextures {	
	textures[FITextureTypeLevel] = [[FITexture textureWithName:@"level"] retain];
	textures[FITextureTypeIce] = [[FITexture textureWithName:@"ice"] retain];
	textures[FITextureTypeFire] = [[FITexture textureWithName:@"fire"] retain];
	textures[FITextureTypeOil] = [[FITexture textureWithName:@"oil"] retain];
	textures[FITextureTypeMagic] = [[FITexture textureWithName:@"magic"] retain];
}


-(FITexture*)texture:(FITextureType)tex {
	return textures[tex];
}


-(void)tappedAt:(CGPoint)pos {
}


-(void)downAt:(CGPoint)pos {
	if(![stage playerMayMove]) return;
	if(pos.y > 300) {
		if(pos.x < 160)
			[stage.avatar moveLeft];
		else
			[stage.avatar moveRight];
	} else {		
		// Recalc pos
		//int x = pos.x / 16.f;
		//int y = pos.y / 16.f;
		
		//[stage toggleIceAtX:x y:y];
		[stage toggleIce];
				
		//[stage toggleIce];
	}
}


-(void)up {
	[stage.avatar stopMoving];
}


@end
