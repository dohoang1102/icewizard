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

	[self startStageWithName:@"bar"];
	
	return self;
}

-(void)restartStage {
  nextStage = [currentStage retain];
}

-(void)startStageWithName:(NSString*)name {
	[currentStage release];
	[nextStage release];
	nextStage = [name retain];
	currentStage = [name retain];
}

-(void)tick:(float)dt {
	[stage tick:dt];
	
	if(nextStage != nil) {
		
		// This will be made prettier.
		// Stage should fade out, and then the new one
		// should fade in.
		
		[stage release];
		stage = [[FIStage stageWithName:nextStage game:self] retain];
		[nextStage release];
		nextStage = nil;
	}
}


-(void)render:(float)dt {
	glClear(GL_COLOR_BUFFER_BIT);
	glLoadIdentity();
	
	glRotatef(90.0f, 0.0f, 0.0f, 1.0f);
	glTranslatef(0.0f, -10.0f, 0.0f);
	
	[stage render:dt];
}


-(void)loadTextures {	
	textures[FITextureTypeLevel] = [[FITexture textureWithName:@"level"] retain];
	textures[FITextureTypeIce] = [[FITexture textureWithName:@"ice"] retain];
	textures[FITextureTypeFire] = [[FITexture textureWithName:@"fire"] retain];
	textures[FITextureTypeOil] = [[FITexture textureWithName:@"oil"] retain];
	textures[FITextureTypeMagic] = [[FITexture textureWithName:@"magic"] retain];
	textures[FITextureTypePoof] = [[FITexture textureWithName:@"poof"] retain];
  textures[FITextureTypePlayer] = [[FITexture textureWithName:@"player"] retain];
}


-(FITexture*)texture:(FITextureType)tex {
	return textures[tex];
}


-(void)tappedAt:(CGPoint)pos {
}


-(void)downAt:(CGPoint)pos {
	
	pos.x /= 32.0f;
	pos.y /= 32.0f;
	
	printf("%f %f\n", pos.x, pos.y);
	
	if(![stage playerMayMove]) return;
	if(pos.y > 5.0f) {
		if(pos.x < 7.5f)
			[stage.avatar moveLeft];
		else
			[stage.avatar moveRight];
	} else {		
		[stage toggleIce];
	}
}


-(void)up {
	[stage.avatar stopMoving];
}


@end
