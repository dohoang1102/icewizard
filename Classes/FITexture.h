//
//  FITexture.h
//  FireNIce
//
//  Created by Per Borgman on 2010-05-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenGLES/ES1/gl.h>

@interface FITexture : NSObject {
	int	width;
	int	height;
	GLuint	name;
}

@property (nonatomic,readonly) int width;
@property (nonatomic,readonly) int height;

+(FITexture*)textureWithName:(NSString*)name;

-(id)initWithWidth:(int)w height:(int)h name:(GLuint)n;

-(void)use;

@end
