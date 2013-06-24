//
//  MTMatrix.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/21/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTMatrix.h"

#import "MTVector.h" // Import header file for MTVector.

@interface MTMatrix() // Class extensions.

/** Property indicating whether this matrix is a homogeneous matrix. (readonly in header file) */
@property (readwrite, nonatomic, getter = isHomogeneous) BOOL homogeneous; // Change to readwrite in class extension.

/** 
 Generate a message indicating initialization failed.
 @param errorReason The reason of initialization fail.
 */
-(void)generateMatrixInitializationFailedMessage: (NSString *) errorReason;

@end

@implementation MTMatrix

// Initializing with a array of vectors.
-(id)initWithVectors:(NSArray *)theVectors
{
	self = [super init];
	if (self) {
		if ([theVectors count] > 0) { // If there is vector in theVectors, initialize it.
			self.vectors = [theVectors mutableCopy]; // Assign theVectors to property vectors.
			NSUInteger entryNumber = [self.vectors[0] entryCount]; // Record the entry number in the first vector, determine if all vectors has the same entry.

			//************************ Determine if this matrix is a homogeneous matrix. ***************************//

			self.homogeneous = YES; // Initialize property homogeneous to YES, if there is one vector which is not homogeneous vector, set to to NO.
			for (int i = 0; i < [self.vectors count]; ++i) { // Iterat through vectors.
				// If one of them is not homogeneous, the matrix is not homogeneous, break and set property homogeneous to NO.
				if ([self.vectors[i] entryCount] != entryNumber){ // If there is a vector has different number of entry, set self as nil, generate log message and end the method.
					self = nil;
					[self generateMatrixInitializationFailedMessage:@"vectors have different number of entries."];
					return self;
				}
				if ([self.vectors[i] isHomogeneous] == NO) { // If anyone is not a homogeneous vector:
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
-(id)initWithFloatValues:(MTCStyleMatrix)cStyleMatrix
{
	self = [super init];
	if (self) {
		self.homogeneous = NO; // Set homogeneous to NO.
		size_t row = cStyleMatrix.row; // Get the row number.
		size_t col = cStyleMatrix.col; // Get the colum number.

		for (size_t i = 0; i < col; ++i) { // Iterate over columns (vectors), the second index place [][*]:
			MTVector *vec = [[MTVector alloc] init]; // Create the current vector.
			for (size_t j = 0; j < row; ++j) { // Iterate through this column of array.
				[vec addEntryWithFloatValue:cStyleMatrix.fVals[j * row + i]]; // Add the current entry.
			}
			[self.vectors addObject:vec]; // Add this vector to matrix.
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
-(BOOL)multiplyMatrix:(MTMatrix *)anotherMatrix
		   inTheFront:(BOOL)front
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

// Add another matrix
-(BOOL)addMatrix:(MTMatrix *)anotherMatrix
{
	if ([self.vectors count] != [anotherMatrix.vectors count] || // If number columns are not the same or:
		[self.vectors[0] entryCount] != [anotherMatrix.vectors[0] entryCount]) { // number of rows are not the same:
		return NO; // Return NO and terminate the method.
	}
	for (size_t i = 0; i < [self.vectors count]; ++i) { // Iterate through all the vectors.
		[self.vectors[i] addVector: anotherMatrix.vectors[i]]; // Add vectors in another matrix to this matrix.
	}
	return YES; // Return YES to indicate operation succeed.
}

// Substract another matrix
-(BOOL)substractMatrix:(MTMatrix *)anotherMatrix
{
	if ([self.vectors count] != [anotherMatrix.vectors count] || // If number columns are not the same or:
	   [self.vectors[0] entryCount] != [anotherMatrix.vectors[0] entryCount]) { // number of rows are not the same:
		return NO; // Return NO and terminate the method.
	}
	for (size_t i = 0; i < [self.vectors count]; ++i) { // Iterate through all the vectors.
		[self.vectors[i] substractVector: anotherMatrix.vectors[i]]; // Substract vectors in another matrix by this matrix.
	}
	return YES; // Return YES to indicate operation succeed.
}

// Override description for matrix.
-(NSString *)description
{
	NSMutableString *res = [NSMutableString string]; // Create a mutable stirng to represent result.
	for (size_t row = 0; row < (size_t)[self.vectors[0] entryCount]; ++row) { // Iterate through rows.
		[res appendString:@"| "]; // Append @"| " at the beginning of each row.
		for (size_t col = 0 ; col < (size_t)[self.vectors count]; ++col) { // Iterate through columns.
			[res appendFormat:@"%.1f ", [self.vectors[col][row] floatValue]]; // Append the float value and a space.
		}
		[res appendString:@" |"]; // Append @" |" at the end of each row.
		[res appendString:@"\n"]; // Append new line character.
	}
	return res; // Return the string.
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

//************************ Helper Methods ***************************//

// Generate error message.
-(void)generateMatrixInitializationFailedMessage:(NSString *)errorReason
{
	NSLog(@"Matrix initialization failed: %@", errorReason); // Generate error message and reason.
}

//************************ Helper Methods ***************************//

@end
