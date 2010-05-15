//
//  FIFire.h
//  FireNIce
//
//  Created by Per Borgman on 2010-05-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FIEntity.h"


@interface FIFire : FIEntity {

}

-(id)initWithX:(int)_x y:(int)_y stage:(FIStage*)theStage;

-(void)buildMesh;

-(void)landedOn:(FICollisionResult)floor;

@end
