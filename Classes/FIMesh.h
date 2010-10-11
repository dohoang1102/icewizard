//
//  FIMesh.h
//  FireNIce
//
//  Created by Per Borgman on 2010-05-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenGLES/ES1/gl.h>

#import "FIDrawable.h"

@class FITexture;

@interface FIMesh : NSObject<FIDrawable> {
	int		mode;	// OpenGL draw mode
	
	BOOL		subTiled;
	
	FITexture*	texture;
	float		textureStep;
	
	int		maxTris;
	int		maxVerts;
	int		maxElements;
	
	GLfloat	*mesh;
	GLfloat *texcoords;
	
	int		numElements;
	int		numVerts;
}

-(id)initWithMode:(int)_mode texture:(FITexture*)_texture numberOfTiles:(int)size;
-(id)initWithMode:(int)_mode texture:(FITexture*)_texture numberOfTiles:(int)size subTiled:(BOOL)_subTiled;

-(void)addQuad:(CGPoint)pos withTextureOffset:(int)offset;
-(void)addSubtiledSquad:(CGPoint)pos ul:(int)ul ur:(int)ur bl:(int)bl br:(int)br;

-(void)createSubSquad:(CGRect)rect coords:(CGRect)coords offset:(int)offset;

-(void)tick:(float)dt;
-(void)render;

@end
