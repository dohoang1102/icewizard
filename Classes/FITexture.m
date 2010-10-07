//
//  FITexture.m
//  FireNIce
//
//  Created by Per Borgman on 2010-05-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FITexture.h"

@implementation FITexture

@synthesize width, height;

+(FITexture*)textureWithName:(NSString*)name {
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png" inDirectory:@"data/tex"];
	if(!path) {
		printf("Texture %s not found.\n", [path UTF8String]);
		return nil;
	}
	
	CGImageRef image = [UIImage imageWithContentsOfFile:path].CGImage;
		
	GLuint glName;
	glGenTextures(1, &glName);
	
	glBindTexture(GL_TEXTURE_2D, glName);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_NEAREST); 
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	
	int width = CGImageGetWidth(image);
	int height = CGImageGetHeight(image);	
	GLubyte *bytes = (GLubyte*) calloc(width*height*4, sizeof(GLubyte));
	
	CGContextRef texContext = CGBitmapContextCreate(bytes, width, height, 8, width * 4, CGImageGetColorSpace(image), kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(texContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), image);
	CGContextRelease(texContext);
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, bytes);
	
	free(bytes);
	
	return [[[FITexture alloc] initWithWidth:width height:height name:glName] autorelease];
	
}

-(id)initWithWidth:(int)w height:(int)h name:(GLuint)n {
	if(![super init]) return nil;
	
	width = w;
	height = h;
	name = n;
	
	printf("Init texture: %d %d, %d\n", width, height, n);
	
	return self;
}

-(void)dealloc {
	// Unload texture from GPU
	
	[super dealloc];
}

-(void)use {
	glBindTexture(GL_TEXTURE_2D, name);
}

@end
