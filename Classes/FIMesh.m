//
//  FIMesh.m
//  FireNIce
//
//  Created by Per Borgman on 2010-05-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FIMesh.h"

#import "FITexture.h"

@implementation FIMesh

-(id)initWithMode:(int)_mode texture:(FITexture*)_texture numberOfTiles:(int)size {
	return [self initWithMode:_mode texture:_texture numberOfTiles:size subTiled:NO];
}

-(id)initWithMode:(int)_mode texture:(FITexture*)_texture numberOfTiles:(int)size subTiled:(BOOL)_subTiled {
	if(![super init]) return nil;
	
	mode = _mode;
	subTiled = _subTiled;
	texture = _texture;
	textureStep = 16.f / texture.width;
		
	maxTris = size * 2 * (subTiled?4:1);
	maxVerts = maxTris * 3;		// Every tri has 3 vertices
	maxElements = maxVerts * 2;	// Two floats for each vertex
	
	if(mode == GL_TRIANGLES) {
		mesh = malloc(sizeof(GLfloat) * maxElements);
		texcoords = malloc(sizeof(GLfloat) * maxElements);
	} else {
		printf("Draw mode not supported.\n");
		return nil;
	}
	
	numElements = 0;
	numVerts = 0;
		
	return self;
}

-(void)dealloc {
	free(mesh);
	free(texcoords);
	
	[super dealloc];
}

-(void)addQuad:(CGPoint)pos withTextureOffset:(int)offset {
	if(numElements >= maxElements) {
		printf("Exceeded max number of triangles.\n");
		return;
	 }
	
	float x = pos.x;
	float y = pos.y;
		
	float u = textureStep * offset;
	
	mesh[numElements] = x;
	mesh[numElements+1] = y;
	
	mesh[numElements+2] = x+1.0;
	mesh[numElements+3] = y;
	
	mesh[numElements+4] = x;
	mesh[numElements+5] = y+1.0;
	
	mesh[numElements+6] = x+1.0;
	mesh[numElements+7] = y;
	
	mesh[numElements+8] = x+1.0;
	mesh[numElements+9] = y+1.0;
	
	mesh[numElements+10] = x;
	mesh[numElements+11] = y+1.0;
	
	texcoords[numElements] = u;
	texcoords[numElements+1] = 0.0f;
	
	texcoords[numElements+2] = u+textureStep;
	texcoords[numElements+3] = 0.0f;
	
	texcoords[numElements+4] = u;
	texcoords[numElements+5] = 1.0f;
	
	texcoords[numElements+6] = u+textureStep;
	texcoords[numElements+7] = 0.0f;
	
	texcoords[numElements+8] = u+textureStep;
	texcoords[numElements+9] = 1.0f;
	
	texcoords[numElements+10] = u;
	texcoords[numElements+11] = 1.0f;
	
	numElements += 12;
	numVerts += 6;
}

-(void)createSubSquad:(CGRect)rect coords:(CGRect)coords offset:(int)offset {
	float u = offset * textureStep + (coords.origin.x * textureStep);
	float v = coords.origin.y;
	float tu = offset * textureStep + (coords.size.width * textureStep);
	float tv = coords.size.height;
	
	float x = rect.origin.x;
	float y = rect.origin.y;
	float tx = rect.size.width;
	float ty = rect.size.height;
	
	//printf("Offset %d, (%f %f, %f %f) => (%f %f, %f %f)\n", offset, 
	//	   coords.origin.x, coords.origin.y, coords.size.width, coords.size.height,
	//	   u, v, tu, tv);
		
	mesh[numElements] = x;
	mesh[numElements+1] = y;
	
	mesh[numElements+2] = tx;
	mesh[numElements+3] = y;
	
	mesh[numElements+4] = x;
	mesh[numElements+5] = ty;
	
	mesh[numElements+6] = tx;
	mesh[numElements+7] = y;
	
	mesh[numElements+8] = tx;
	mesh[numElements+9] = ty;
	
	mesh[numElements+10] = x;
	mesh[numElements+11] = ty;
	
	texcoords[numElements] = u;
	texcoords[numElements+1] = v;
	
	texcoords[numElements+2] = tu;
	texcoords[numElements+3] = v;
	
	texcoords[numElements+4] = u;
	texcoords[numElements+5] = tv;
	
	texcoords[numElements+6] = tu;
	texcoords[numElements+7] = v;
	
	texcoords[numElements+8] = tu;
	texcoords[numElements+9] = tv;
	
	texcoords[numElements+10] = u;
	texcoords[numElements+11] = tv;
	
	numElements += 12;
	numVerts += 6;
}

-(void)addSubtiledSquad:(CGPoint)pos ul:(int)ul ur:(int)ur bl:(int)bl br:(int)br {
	if(!subTiled || numElements >= maxElements) return;
	
	float x = pos.x;
	float y = pos.y;
	
	[self createSubSquad:CGRectMake(x,y,x+0.5f,y+0.5f) coords:CGRectMake(0.0f,0.0f,0.5f,0.5f) offset:ul];
	[self createSubSquad:CGRectMake(x+0.5f,y,x+1.0f,y+0.5f) coords:CGRectMake(0.5f,0.0f,1.0f,0.5f) offset:ur];
	[self createSubSquad:CGRectMake(x,y+0.5f,x+0.5f,y+1.0f) coords:CGRectMake(0.0f,0.5f,0.5f,1.0f) offset:bl];
	[self createSubSquad:CGRectMake(x+0.5f,y+0.5f,x+1.0f,y+1.0f) coords:CGRectMake(0.5f,0.5f,1.0f,1.0f) offset:br];
}

-(void)tick:(float)dt {}

-(void)render {	
	[texture use];
	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	glVertexPointer(2, GL_FLOAT, 0, mesh);
	glTexCoordPointer(2, GL_FLOAT, 0, texcoords);
	glDrawArrays(GL_TRIANGLES, 0, numVerts);
}

@end
