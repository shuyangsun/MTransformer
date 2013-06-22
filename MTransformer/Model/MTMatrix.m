//
//  MTMatrix.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/21/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTMatrix.h"

#import "MTVector.h" // Import header file for MTVector.

#include "GlobalMacro.h" // Global macro definitions.

@interface MTMatrix() // Class extensions.

/** Property indicating whether this matrix is a homogeneous matrix. (readonly in header file) */
@property (readwrite, nonatomic, getter = isHomogeneous) BOOL homogeneous; // Change to readwrite in class extension.

@end

@implementation MTMatrix

// Initializing with a array of vectors.
-(id)initWithVectors:(NSArray *)theVectors
{
	self = [super init];
	if (self) {
		if ([theVectors count] > 0){ // If there is vector in theVectors, initialize it.
			self.vectors = [theVectors mutableCopy]; // Assign theVectors to property vectors.
			
			//************************ Determine if this matrix is a homogeneous matrix. ***************************//

			self.homogeneous = YES; // Initialize property homogeneous to YES, if there is one vector which is not homogeneous vector, set to to NO.
			for (int i = 0; i < [self.vectors count]; ++i) { // Iterat through vectors.
				// If one of them is not homogeneous, the matrix is not homogeneous, break and set property homogeneous to NO.
				if ([[self.vectors objectAtIndex:i] isHomogeneous] == NO) { // If anyone is not a homogeneous vector:
					self.homogeneous = NO; // Set homogeneous to NO.
					break; // Break out of the loop.
				}
			}
			//************************ Determine if this matrix is a homogeneous matrix. ***************************//
			
		}
	}
	return self;
}

// Initialize with a two dimensional C style float array.
-(id)initWithFloatValues:(float **)fVals
{
	self = [super init];
	if (self) {
		self.homogeneous = NO;
		for (size_t i = 0; i < (size_t)arrlen(fVals); ++i) { // Iterate over columns (vectors), the first index place [*][]:
			MTVector *vec = [[MTVector alloc] initWithFloatArray:*(fVals + i)]; // Initialize current vector with float array.
			[self.vectors addObject:vec]; // Add this vector to matrix.
			vec = nil; // Set vec to nil, release memory.
		}
	}
	return self;
}

// Designated initializer.
-(id)init
{
	self = [super init];
	if (self) {
		self.vectors = [[NSMutableArray alloc] init]; // Initialize an empty vectos array.
		self.homogeneous = NO;
	}
	return self;
}

// Convert all vectors in matrx to homogeneous vectors.
-(void)toHomogeneousMatrix
{
	[self.vectors performSelector:@selector(toHomogeneousVector)]; // Convert all the vectors to homogeneous vector.
}

// Get the homogeneous matrix of this matrix.
-(MTMatrix *)getHomogeneousMatrix
{
	MTMatrix *res = [self mutableCopy]; // Make a mutable copy of this matrix.
	[res toHomogeneousMatrix]; // Convert result to homogeneous matrix.
	return res;
}

// Overriding getter method of vectors to use lazy instantiation.
-(NSMutableArray *)vectors
{
	if (!_vectors) _vectors = [[NSMutableArray alloc] init]; // Lazy instantiation.
	return _vectors;
}

// copyWithZone: method required in NSCopying protocol.
-(id)copyWithZone:(NSZone *)zone
{
	MTMatrix *res = [[MTMatrix alloc] init]; // Initialize an empty matrix.
	res.vectors = [self.vectors copy]; // Make a copy of vectos.
	res.homogeneous = self.homogeneous; // Set homogeneous value.
	return res;
}

// mutableCopyWithZone: method required in NSCopying protocol.
-(id)mutableCopyWithZone:(NSZone *)zone
{
	MTMatrix *res = [[MTMatrix alloc] init]; // Initialize an empty matrix.
	res.vectors = [self.vectors mutableCopy]; // Make a mutable copy of vectos.
	res.homogeneous = self.homogeneous; // Set homogeneous value.
	return res;
}

@end
