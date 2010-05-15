//
//  FIGame.h
//  FireNIce
//
//  Created by Per Borgman on 2010-05-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenGLES/ES1/gl.h>

typedef enum {
	FITextureTypeLevel = 0,
	FITextureTypeIce,
	FITextureTypeFire,
	FITextureTypeOil,
	FITextureTypeMagic
} FITextureType;

@class FIStage;
@class FITexture;

@interface FIGame : NSObject {
	FIStage	*stage;
	
	FITexture *textures[5];
}

@property (nonatomic,readonly) FIStage *stage;

-(id)init;

-(void)tick:(float)dt;
-(void)render;

-(void)loadTextures;
-(FITexture*)texture:(FITextureType)tex;

-(void)tappedAt:(CGPoint)pos;
-(void)downAt:(CGPoint)pos;
-(void)up;

@end
