//
//  FITempSprite.m
//  FireNIce
//
//  Created by Per Borgman on 2010-05-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FITempSprite.h"

#import "FISprite.h"

@implementation FITempSprite

-(id)initWithX:(int)_x y:(int)_y sprite:(FISprite*)sprite stage:(FIStage *)theStage {
	if(![super initWithX:_x y:_y stage:theStage]) return nil;
	
	// This is dealloc'd in FIEntity
	gfx = [sprite retain];
	
	isStatic = YES;
	
	target = nil;
	
	[sprite onAnimationOverTarget:self action:@selector(animationOver)];
	
	printf("Init tempSprite\n");
	
	return self;
}
	

-(void)animationOver {
	[stage removeEntity:self];
	if(target != nil)
		[target performSelector:action];
}

-(void)onAnimationOverTarget:(id)_target action:(SEL)_action {
	target = _target;
	action = _action;
}

@end
