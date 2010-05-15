//
//  FIDrawable.h
//  FireNIce
//
//  Created by Per Borgman on 2010-05-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FIDrawable

-(void)tick:(float)dt;
-(void)render;

@end
