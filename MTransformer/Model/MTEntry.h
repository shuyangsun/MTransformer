//
//  MTEntry.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/21/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A class representing entries in a vector. Super class is NSNumber.
 */
@interface MTEntry : NSNumber

//************************ Initializers  ***************************//

/**
 Generate a entry with specific float value.
 @param value Float value assigning to entry.
 */
+(NSNumber *)entryWithFloat:(float)value;

//************************ Initializers  ***************************//

@end
