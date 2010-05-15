//
//  FIRenderer.m
//  FireNIce
//
//  Created by Per Borgman on 2010-05-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FIRenderer.h"

#import "FIGame.h"
#import "FIStage.h"
#import "FIPlayerAvatar.h"

@implementation FIRenderer

-(id)initWithGame:(FIGame*)theGame {
	if(![super init]) return nil;
	
	game = theGame;
	
	return self;
}


-(void)setup {
	printf("Setup renderer with size %d %d\n", width, height);
	
	glViewport(0, 0, width, height);
	
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
	glOrthof(0.0, 14.0, 12.0, 0.0, -1.0f, 1.0f);
    glMatrixMode(GL_MODELVIEW);

	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
}


-(void)render {
	glClear(GL_COLOR_BUFFER_BIT);
	glLoadIdentity();
	
	FIStage *stage = game.stage;
	FIPlayerAvatar *avatar = stage.avatar;
	
	glTranslatef(avatar.position.x, avatar.position.y);
	
	
}

@end
