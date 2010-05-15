//
//  FIOil.h
//  FireNIce
//
//  Created by Per Borgman on 2010-05-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FIEntity.h"


@interface FIOil : FIEntity {
	BOOL	burning;
}

@property (nonatomic) BOOL burning;

-(id)initWithX:(int)_x y:(int)_y burning:(BOOL)b stage:(FIStage*)theStage;

@end
