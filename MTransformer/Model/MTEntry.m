//
//  MTEntry.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/21/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTEntry.h"

@implementation MTEntry

// Generate a entry with a float value.
+(NSNumber *)entryWithFloat:(float)value
{
	return [self numberWithFloat:value]; // The same as class method: numberWithFloat:
}

@end
