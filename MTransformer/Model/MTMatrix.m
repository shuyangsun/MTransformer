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

//************************ Linear Algebra Calculation ***************************//

// Multiply by a vector, after multiplication, this matrix
-(MTVector *)multiplyVector: (MTVector *) vector
{
	if ([vector entryCount] != [self.vectors count]) { // If the multipliation is not defined, return nil.
		return nil; // Return nil to end the method.
	}
	MTMatrix *multipliedMatrix = [self mutableCopy]; // Make a copy of current matrix.
	for (size_t i = 0; i < (size_t)[self.vectors count]; ++i) { // Loop through vectors.
		[[self.vectors objectAtIndex:i] multiplyByNumber:[vector entryAtIndexAsFloat:i]]; // Multiply the ith vector in this matrix with the ith entry in the new vector.
	}
	MTVector *res = [[MTVector alloc] initWithNumberOfEntries:[[self.vectors objectAtIndex:0] entryCount]]; // Create a result with the same number entris. (all entries are ZEROs now)
	for (size_t i = 0; i < [self.vectors count]; ++i) { // Loop through the vectors.
		[res addVector:[self.vectors objectAtIndex:i]]; // Add all vectors together.
	}

	[multipliedMatrix.vectors removeObjectAtIndex:0]; // Remove the first vector.
	multipliedMatrix = nil; // Release the multiplied matrix.
	return res; // Multply succeed, return the result.
}

// Multiply by a matrix, front indicate wether it should be in the front or after this matrix.
-(BOOL)multiplyMatrix:(MTMatrix *)anotherMatrix inTheFront:(BOOL)front
{
	if (front) { // If the matrix multiplying is in the front of this matrix:
		if ([[self.vectors objectAtIndex:0] entryCount] != [anotherMatrix.vectors count]) return NO; // If number of rows for this matrix doesn't equal to number of columns for the new matrix, multiplication is not defined. Return NO.
		MTMatrix *res = [[MTMatrix alloc] init]; // Replace self with this matrix later.
		for (size_t i = 0; i < (size_t)[self.vectors count]; ++i) { // Loop through all vectors in this matrix.
			MTVector *temp = [anotherMatrix multiplyVector:[self.vectors objectAtIndex:i]]; // Create a new vector holding currentmultiplication result.
			[res.vectors addObject:temp]; // Add the multiplication result to the new matrx.
			temp = nil; // Release temp.
		}
		for (size_t i = 0; i < (size_t)[self.vectors count]; ++i) { // Loop through vectors in this matrix.
			[self.vectors replaceObjectAtIndex:i withObject:[res.vectors objectAtIndex:i]]; // Replace with the new vectos.
		}
		res = nil; // Release res.
	} else { // If the matrix multiplying is at the back of this matrix:
		if ([self.vectors count] != [[anotherMatrix.vectors objectAtIndex:0] entryCount]) return NO; // If number of columns for this matrix doesn't equal to number of rows for the new matrix, multiplication is not defined. Return NO.
		MTMatrix *res = [[MTMatrix alloc] init]; // Replace self with this matrix later.
		for (size_t i = 0; i < (size_t)[anotherMatrix.vectors count]; ++i) { // Loop through all vectors in anotherMatrix.
			MTVector *temp = [self multiplyVector:[anotherMatrix.vectors objectAtIndex:i]]; // Create a new vector holding currentmultiplication result.
			[res.vectors addObject:temp]; // Add the multiplication result to the new matrx.
			temp = nil; // Release temp.
		}
		for (size_t i = 0; i < (size_t)[self.vectors count]; ++i) { // Loop through vectors in this matrix.
			[self.vectors replaceObjectAtIndex:i withObject:[res.vectors objectAtIndex:i]]; // Replace with the new vectos.
		}
		res = nil; // Release res.
	}
	return YES; // Multiplication succedd.
}
//************************ Linear Algebra Calculation ***************************//

//************************ Copy Protocol Methods ***************************//

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
//************************ Copy Protocol Methods ***************************//

@end
