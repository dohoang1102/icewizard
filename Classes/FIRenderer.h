//
//  FIRenderer.h
//  FireNIce
//
//  Created by Per Borgman on 2010-05-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FIGame;

@interface FIRenderer : NSObject {
	FIGame	*game;
	
	int		width, height;
}

-(id)initWithGame:(FIGame*)theGame;

-(void)setup;
-(void)render;

@end
