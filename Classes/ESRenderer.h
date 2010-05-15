//
//  ESRenderer.h
//  FirenIce
//
//  Created by Per Borgman on 2010-05-07.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

@class FIGame;

@protocol ESRenderer <NSObject>

- (id)initWithGame:(FIGame*)theGame;

- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end
