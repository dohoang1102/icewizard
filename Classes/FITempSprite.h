//
//  FITempSprite.h
//  FireNIce
//
//  Created by Per Borgman on 2010-05-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FIEntity.h"

@class FIStage;
@class FISprite;

@interface FITempSprite : FIEntity {
	id	target;
	SEL	action;
}

-(id)initWithX:(int)_x y:(int)_y sprite:(FISprite*)sprite stage:(FIStage *)theStage;

-(void)onAnimationOverTarget:(id)_target action:(SEL)_action;

@end
