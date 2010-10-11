//
//  JSONHelper.h
//  Quest
//
//  Created by Per Borgman on 2010-03-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Vector2;

@interface JSONHelper : NSObject
+(NSMutableDictionary*)dictionaryFromJSONURL:(NSURL*)path;
+(NSMutableDictionary*)dictionaryFromJSONPath:(NSString*)path;
+(NSMutableDictionary*)dictionaryFromJSONString:(NSString*)data;

@end
