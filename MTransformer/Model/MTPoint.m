//
//  MTPoint.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/20/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTPoint.h"
#include "GlobalMacro.h"

@interface MTPoint() // Class extension

// Array of points holding the points it connects to. (readonly in interface file, readwrite in class extension)
@property (readwrite, strong, nonatomic) NSMutableArray *connectedPoints;

@end

@implementation MTPoint

@end

