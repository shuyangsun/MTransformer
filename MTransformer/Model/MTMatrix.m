//
//  MTMatrix.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/21/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTMatrix.h"

#import "MTPoint.h" // Import header file for MTPoint.
#import "MTPoint.h" // Impotr header file for MTPoint
#import "MTMatrixCollection.h" // Import MTMatrixCollection for transformation & projection calculation.

@interface MTMatrix() // Class extensions.

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
			MTPoint *vec = [[MTPoint alloc] init]; // Create the current vector.
			for (size_t j = 0; j < row; ++j) { // Iterate through this column of array. (rows)
				[vec addEntryWithFloatValue:cStyleMatrix.fVals[j * col + i]]; // Add the current entry.
			}
			[self.vectors addObject:vec]; // Add this vector to matrix.
		}
	}
	return self;
}

// Initialize with float data and points connecting to.
-(id)initWithFloatValues:(MTCStyleMatrix)cStyleMatrix
 andPointsConnectionData:(char *)connectionData
{
	self = [super init];
	if (self) {
		self.homogeneous = NO; // Set homogeneous to NO.
		size_t row = cStyleMatrix.row; // Get the row number.
		size_t col = cStyleMatrix.col; // Get the colum number.

		for (size_t i = 0; i < col; ++i) { // Iterate over columns (vectors), the second index place [][*]:
			MTPoint *point = [[MTPoint alloc] init]; // Create the current vector.
			point.visited = NO; // Set the visited to no.
			point.name = [NSString stringWithFormat:@"%c", (char)('A' + i)]; // Set the point name.
			for (size_t j = 0; j < row; ++j) { // Iterate through this column of array. (rows)
				[point addEntryWithFloatValue:cStyleMatrix.fVals[j * col + i]]; // Add the current entry.
			}
			[self.vectors addObject:point]; // Add this vector to matrix.
		}

		//************************ Connect Points ***************************//
		for (size_t col = 1; col < cStyleMatrix.col; ++col) { // Iterate through colomns in connection data.
			for (size_t row = 0; row < col; ++row) { //Iterate only rows in the upper-half triangle.
				int indexOfCurrentPoint = col + row * cStyleMatrix.col; // Get the index of current point evaluating.
				if (connectionData[indexOfCurrentPoint] != 0){ // If it is connecting to this point.
					[((MTPoint *)self.vectors[col]) connectToPoint:self.vectors[row]]; // Connect to the point.
				}
			} 
		}
		//************************ Connect Points ***************************//
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
	[self.vectors makeObjectsPerformSelector: @selector(toHomogeneousVector)]; // Convert all the vectors to homogeneous vector.
	self.homogeneous = YES; // Set the homogeneous to YES.
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
-(void)multiplyVector: (MTPoint *) vector inTheFront:(BOOL)front atVector:(int)vecIndex
{
	if ([vector entryCount] != [self.vectors count]) { // If the multipliation is not defined, return nil.
		NSLog(@"Multiplicataion undefined for matrix * vector."); // Generate log message.
		return; // Return nil to end the method.
	}
	MTMatrix *multipliedMatrix = [self deepCopy]; // Make a deep copy of current matrix.
	
	for (size_t i = 0; i < (size_t)[multipliedMatrix.vectors count]; ++i) { // Loop through vectors.
		[multipliedMatrix.vectors[i] multiplyByNumber:[vector entryAtIndexAsFloat:i]]; // Multiply the ith vector in this matrix with the ith entry in the new vector.
	}
	for (size_t i = 0; i < [multipliedMatrix.vectors[0] entryCount]; ++i) { // Loop all rows.
		float newVal = 0.0f; // Create a new value holding the result of this entry.
		for (size_t j = 0; j < [multipliedMatrix.vectors count]; ++j) { // Loop through columns in the row
			newVal += [[multipliedMatrix.vectors objectAtIndex:j] entryAtIndexAsFloat:i]; // Accumulative add the values.
		}
		if (front) {// If this vector is in the front:
			[vector replaceEntryAtIndex:i withFloatValue:newVal]; // Change the value of this entry/
		} else {
			[[self.vectors objectAtIndex:vecIndex] replaceEntryAtIndex:i withFloatValue:newVal];
		}
		}
	multipliedMatrix = nil; // Release the multiplied matrix.
}

// Multiply by a matrix, front indicate wether it should be in the front or after this matrix.
-(BOOL)multiplyMatrix:(MTMatrix *)anotherMatrix
		   inTheFront:(BOOL)front
{
	if (front) { // If the matrix multiplying is in the front of this matrix:
		if ([[self.vectors objectAtIndex:0] entryCount] != [anotherMatrix.vectors count]) return NO; // If number of rows for this matrix doesn't equal to number of columns for the new matrix, multiplication is not defined. Return NO.
		
		for (size_t i = 0; i < (size_t)[self.vectors count]; ++i) { // Loop through all vectors in this matrix.
			[anotherMatrix multiplyVector:[self.vectors objectAtIndex:i] inTheFront:front atVector:i]; // Multiply all vectors with this matrix.
		}
	} else { // If the matrix multiplying is at the back of this matrix:
		if ([self.vectors count] != [[anotherMatrix.vectors objectAtIndex:0] entryCount]) return NO; // If number of columns for this matrix doesn't equal to number of rows for the new matrix, multiplication is not defined. Return NO.
		for (size_t i = 0; i < (size_t)[anotherMatrix.vectors count]; ++i) { // Loop through all vectors in anotherMatrix.
			[self multiplyVector:[anotherMatrix.vectors objectAtIndex:i] inTheFront:front atVector:i]; // Multiply all vectors with this matrix.
		}
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

//************************ Linear Algebra Calculation ***************************//

// Override description for matrix.
-(NSString *)description
{
	NSMutableString *res = [NSMutableString string]; // Create a mutable stirng to represent result.
	for (size_t row = 0; row < (size_t)[self.vectors[0] entryCount]; ++row) { // Iterate through rows.
		[res appendString:@"|  "]; // Append @"|  " at the beginning of each row.
		for (size_t col = 0 ; col < (size_t)[self.vectors count]; ++col) { // Iterate through columns.
			[res appendFormat:@"%5.1f ", [self.vectors[col][row] floatValue]]; // Append the float value and a space. The float display one number after decimal point, number is 5 width.
		}
		[res appendString:@"|"]; // Append @"|" at the end of each row.
		[res appendString:@"\n"]; // Append new line character.
	}
	return res; // Return the string.
}



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

//************************ Coding Protocol Methods ***************************//

// Decoder:
-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self) {
		self.vectors = [aDecoder decodeObjectForKey:@"MTMatrixVectors"]; // Decode vectors.
		self.homogeneous = [aDecoder decodeBoolForKey:@"MTMatrixHomogeneous"]; // Decode homogeneous.
	}
	return self; // Return itself.
}

// Encoder:
-(void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.vectors forKey:@"MTMatrixVectors"]; // Encode vectors.
	[aCoder encodeBool:self.homogeneous forKey:@"MTMatrixHomogeneous"]; // Encode homogeneous.
}

//  User NSCoding protocol to create a deepcopy of this object.
-(id)deepCopy
{
	return [NSKeyedUnarchiver unarchiveObjectWithData:
			[NSKeyedArchiver archivedDataWithRootObject:self]]; // Use NSKeyedUnarchive and NSKeyedArchiver to create a deep copy.
}

//************************ Coding Protocol Methods ***************************//

//************************ Helper Methods ***************************//

// Generate error message.
-(void)generateMatrixInitializationFailedMessage:(NSString *)errorReason
{
	NSLog(@"Matrix initialization failed: %@", errorReason); // Generate error message and reason.
}

//************************ Helper Methods ***************************//

//*******************************************************************************//
//************************ Tranformation & Projection ***************************//
//*******************************************************************************//

// Project from given axis.
-(MTMatrix *)matrixByProjectOnPlaneThroughAxis:(MT_AXIS)axis
								  withDistance:(float)d
							  handleOutOfRange:(BOOL)handleOutOfRange
{
	MTMatrix *res = [self deepCopy]; // Create a deep copy of this matrix.
	if (res.homogeneous == NO) [res toHomogeneousMatrix]; // If it's not a homogeneous matrix, change it to homogeneous matrix.

	// For hanling out of range problem:
	short int otherTwoIndexes1 = X;
	short int otherTwoIndexes2 = Y;

	MT3DPoint point; // The point projecting from.
	switch (axis) { // Switch between axises.
		case X: // If it's x-axis:
			point = MT3DPointMake(d, 0, 0); // x-axis point.
			otherTwoIndexes1 = Y; // For hanling out of range problem:
			otherTwoIndexes2 = Z; // For hanling out of range problem:
			break;
		case Y: // If it's x-axis:
			point = MT3DPointMake(0, d, 0); // y-axis point.
			otherTwoIndexes1 = X; // For hanling out of range problem:
			otherTwoIndexes2 = Z; // For hanling out of range problem:
			break;
		case Z: // If it's x-axis:
			point = MT3DPointMake(0, 0, d); // z-axis point.
			otherTwoIndexes1 = X; // For hanling out of range problem:
			otherTwoIndexes2 = Y; // For hanling out of range problem:
			break;
		default: // If none of above is the case:
			point = MT3DPointMake(0, 0, d); // Set the default to z-axis point.
			otherTwoIndexes1 = X; // For hanling out of range problem:
			otherTwoIndexes2 = Y; // For hanling out of range problem:
			break;
	}

	//********************************************************************************//
	//************************ Handle Out Of Range Problem ***************************//
	//********************************************************************************//
	
	if (handleOutOfRange == YES) { // If we choose to hanle out of range problem:
		for (size_t i = 0; i < [res.vectors count]; ++i) { // Iterate throu all the points.
			MTPoint *currentPoint = [res.vectors objectAtIndex:i]; // Create a pointer to current point.

			if ([currentPoint entryAtIndexAsFloat:axis] > d &&
				[currentPoint entryAtIndexAsFloat:otherTwoIndexes1] == 0 &&
				[currentPoint entryAtIndexAsFloat:otherTwoIndexes2] == 0) { // If it's out of range and it's two entris are 0's:
				NSArray *connectedPoints = currentPoint.pointsConnectingToAsArray; // Get all the connected points.

				for (size_t j = 0; j < [connectedPoints count]; ++j) { // Iterate connected points:
					if ([((MTPoint *)connectedPoints[j]) entryAtIndexAsFloat:axis] < d) { // If this connected point is in the range:
						MTPoint *newPoint = [[MTPoint alloc] initWithName:[NSString stringWithFormat:@"%@%lu", currentPoint.name, (j + 1)]]; // Initialize with replacement name.	(original + number)
						[newPoint connectToPoint:connectedPoints[j]]; // Connect the points.
						[newPoint addEntries: ((MTPoint *)connectedPoints[j]).entries]; // Make all the values the same as connected points.
						[newPoint replaceEntryAtIndex:axis withFloatValue:[currentPoint entryAtIndexAsFloat:axis]]; // Replace the value of out of range entry with out of range number.
						[newPoint replaceEntryAtIndex:3 withFloatValue:[currentPoint entryAtIndexAsFloat:3]]; // Replace the homogeneous value.

					[res.vectors addObject:newPoint]; // Add this new point to vectors.
					}
				}
				[currentPoint disconnectFromAllPoints]; // Disconnect all points it's connecting to.
				[res.vectors removeObject:currentPoint]; // Remove this point from vectors.
			}

//			if ( [currentPoint entryAtIndexAsFloat:axis] > d){ // If the entry value is out of range:
//				if ([currentPoint isKindOfClass:[MTPoint class]] == NO) { // If this is not a point:
//					NSLog(@"Cannot hadle out of range problem, because vectors are not MTPoints.\n"); // Generate log message.
//					break; // Break out of the loop.
//				}
//				NSMutableSet *replacement2DPointsForThisPoint = [NSMutableSet set]; // Create a set of replacement points for this point.
//				NSEnumerator *enumeratorForPointsConnectingTo = [currentPoint.pointsConnectingTo objectEnumerator]; // Enumerator for enumerate through points connecting to.
//				MTPoint *currentConnectedPoint;
//				while (currentConnectedPoint = [enumeratorForPointsConnectingTo nextObject]) { // While there are connected points in the enumerator:
//					if ([currentConnectedPoint entryAtIndexAsFloat:axis] < d) { // While the entry is inside the range, handle it, otherwise remove this connected point. (don't need to draw the line.)
//						MTPoint *currentReplacementPoint = [currentPoint deepCopy]; // Make a deep copy of current point.
//						[currentReplacementPoint replaceEntryAtIndex:axis withFloatValue:d - DISTANCE_ERROR]; // Set the new value of z.
//						// First entry:
//						float ratio = ([currentPoint entryAtIndexAsFloat:axis] - d)/([currentPoint entryAtIndexAsFloat:axis] - [currentConnectedPoint entryAtIndexAsFloat:axis]); // The ratio of x of changing. (z1 - d)/(z2 - z1)
//						float valueDifference = [currentConnectedPoint entryAtIndexAsFloat:otherTwoIndexes1] - [currentPoint entryAtIndexAsFloat:otherTwoIndexes1]; // The difference of value want to change. (x2 - x1)
//						[currentReplacementPoint replaceEntryAtIndex:otherTwoIndexes1 withFloatValue: (valueDifference * ratio + [currentPoint entryAtIndexAsFloat:otherTwoIndexes1])]; // (z1 - d)/(z1 - z2) * (x2 - x1) + x1
//						// Second entry:
//						valueDifference = [currentConnectedPoint entryAtIndexAsFloat:otherTwoIndexes2] - [currentPoint entryAtIndexAsFloat:otherTwoIndexes2]; // The difference of value want to change. (x2 - x1)
//						[currentReplacementPoint replaceEntryAtIndex:otherTwoIndexes2 withFloatValue: (valueDifference * ratio + [currentPoint entryAtIndexAsFloat:otherTwoIndexes2])]; // (z1 - d)/(z1 - z2) * (y2 - y1) + y1
//
//						[currentReplacementPoint connectToPoint:currentConnectedPoint]; // Connect it to current connected point.
//						[replacement2DPointsForThisPoint addObject:currentReplacementPoint]; // Add it to replacement set.]
//					}
//				}
//				[currentPoint disconnectFromPoints:[currentPoint pointsConnectingToAsArray]]; // Disconnect all the points.
//				[res.vectors removeObject:currentPoint]; // Remove the current point.
//				[res.vectors addObjectsFromArray:[replacement2DPointsForThisPoint allObjects]]; // Add new points to the result.
//			}
		}
	}

	//********************************************************************************//
	//************************ Handle Out Of Range Problem ***************************//
	//********************************************************************************//

	[res multiplyMatrix:[[MTMatrixCollection sharedCollection] projectionTransformationMatrixFromPoint: point
																							  fromAxis:axis] // Multiply the matrix by projection matrix.
			 inTheFront:YES]; // Put the matrix in the front.
	for (size_t i = 0; i < [res.vectors count]; ++i) { // Iterate through all vectors:
		[res.vectors[i] projectingTo2DPlaneFromAxis:axis]; // Project vectors.
	}
	return res; // Return the result.
}

// Project on y, z plane.
-(MTMatrix *)matrixByProjectOnPlaneThrough_xAxisWithDistance: (float) d
											handleOutOfRange:(BOOL)handleOutOfRange
{
	return [self matrixByProjectOnPlaneThroughAxis:X withDistance:d handleOutOfRange:handleOutOfRange]; // Call the other method.
}

// Project on x, z plane.
-(MTMatrix *)matrixByProjectOnPlaneThrough_yAxisWithDistance: (float) d
											handleOutOfRange:(BOOL)handleOutOfRange
{
	return [self matrixByProjectOnPlaneThroughAxis:Y withDistance:d handleOutOfRange:handleOutOfRange]; // Call the other method.
}

// Project on x, y plane.
-(MTMatrix *)matrixByProjectOnPlaneThrough_zAxisWithDistance: (float) d
											handleOutOfRange:(BOOL)handleOutOfRange
{
	return [self matrixByProjectOnPlaneThroughAxis:Z withDistance:d handleOutOfRange:handleOutOfRange]; // Call the other method.
}

// Move matrix with a specific distance along given axis.
-(void)moveAlongAxis: (MT_AXIS) axis withDistance: (float) d
{
	if (self.homogeneous == NO) [self toHomogeneousMatrix]; // If it's not a homogeneous matrix, change it to homogeneous matrix.
	switch (axis) { // Switch between axises.
		case X: // If it's x-axis:
			[self moveAlong_xAxisWithDistance:d]; // Move along x-axis.
			break;
		case Y: // If it's y-axis:
			[self moveAlong_yAxisWithDistance:d]; // Move along y-axis.
			break;
		case Z: // If it's z-axis:
			[self moveAlong_zAxisWithDistance:d]; // Move along z-axis.
			break;
		default: // Det default to z-axis.
			[self moveAlong_zAxisWithDistance:d]; // Move along z-axis.
			break;
	}
}

// Move matrix along x-axis with a specific distance.
-(void)moveAlong_xAxisWithDistance: (float) d
{
	if (self.homogeneous == NO) [self toHomogeneousMatrix]; // If it's not a homogeneous matrix, change it to homogeneous matrix.
	[self multiplyMatrix:[[MTMatrixCollection sharedCollection] translateTransformationMatrixWith_xValue:d // Move d along x-axis.
																							  and_yValue:0 // Keep y.
																							  and_zValue:0] // Keep z.
			  inTheFront:YES]; // Put the matrix in the front.
}

// Move matrix along y-axis with a specific distance.
-(void)moveAlong_yAxisWithDistance: (float) d
{
	if (self.homogeneous == NO) [self toHomogeneousMatrix]; // If it's not a homogeneous matrix, change it to homogeneous matrix.
	[self multiplyMatrix:[[MTMatrixCollection sharedCollection] translateTransformationMatrixWith_xValue:0 // Keep x.
																							  and_yValue:d // Move d along y-axis.
																							  and_zValue:0] // Keep z.
			  inTheFront:YES]; // Put the matrix in the front.
}

// Move matrix along z-axis with a specific distance.
-(void)moveAlong_zAxisWithDistance: (float) d
{
	if (self.homogeneous == NO) [self toHomogeneousMatrix]; // If it's not a homogeneous matrix, change it to homogeneous matrix.
	[self multiplyMatrix:[[MTMatrixCollection sharedCollection] translateTransformationMatrixWith_xValue:0 // Keep z.
																							  and_yValue:0 // Keep y.
																							  and_zValue:d] // Move d along x-axis.
			  inTheFront:YES]; // Put the matrix in the front.
}

// Rotate the matrix about x-axis, with a given radian.
-(void)rotateAbout_xAxisWithAngle: (double) radian
{
	if (self.homogeneous == NO) [self toHomogeneousMatrix]; // If it's not a homogeneous matrix, change it to homogeneous matrix.
	[self multiplyMatrix:[[MTMatrixCollection sharedCollection] rotationTransformationMatrixAboutAxis:X // Set axis to x.
																							  byAngle:radian] // Multiply the matrix by roation matrix.
			  inTheFront:YES]; // Put the matrix in the front.
}

// Rotate the matrix about y-axis, with a given radian.
-(void)rotateAbout_yAxisWithAngle: (double) radian
{
	if (self.homogeneous == NO) [self toHomogeneousMatrix]; // If it's not a homogeneous matrix, change it to homogeneous matrix.
	[self multiplyMatrix:[[MTMatrixCollection sharedCollection] rotationTransformationMatrixAboutAxis:Y // Set axis to y.
																							  byAngle:radian] // Multiply the matrix by roation matrix.
			  inTheFront:YES]; // Put the matrix in the front.
}

// Rotate the matrix about z-axis, with a given radian.
-(void)rotateAbout_zAxisWithAngle: (double) radian
{
	if (self.homogeneous == NO) [self toHomogeneousMatrix]; // If it's not a homogeneous matrix, change it to homogeneous matrix.
	[self multiplyMatrix:[[MTMatrixCollection sharedCollection] rotationTransformationMatrixAboutAxis:Z // Set axis to z.
																							  byAngle:radian] // Multiply the matrix by roation matrix.
			  inTheFront:YES]; // Put the matrix in the front.
}

// Scale the x-axis by a given percentage.
-(void)scale_xAxisByPercentge: (float) p
{
	if (self.homogeneous == NO) [self toHomogeneousMatrix]; // If it's not a homogeneous matrix, change it to homogeneous matrix.
	[self multiplyMatrix:[[MTMatrixCollection sharedCollection] scaleTransformationMatrixWithScalingPercentageOfX:p // Scale x-axis.
																											 andY:1 // Keep y.
																											 andZ:1] // Keep z.
			  inTheFront:YES]; // Put the matrix in the front.
}

// Scale the y-axis by a given percentage.
-(void)scale_yAxisByPercentge: (float) p
{
	if (self.homogeneous == NO) [self toHomogeneousMatrix]; // If it's not a homogeneous matrix, change it to homogeneous matrix.
	[self multiplyMatrix:[[MTMatrixCollection sharedCollection] scaleTransformationMatrixWithScalingPercentageOfX:1 // Keep x.
																											 andY:p // Scale y-axis.
																											 andZ:1] // Keep z.
			  inTheFront:YES]; // Put the matrix in the front.
}

// Scale the z-axis by a given percentage.
-(void)scale_zAxisByPercentge: (float) p
{
	if (self.homogeneous == NO) [self toHomogeneousMatrix]; // If it's not a homogeneous matrix, change it to homogeneous matrix.
	[self multiplyMatrix:[[MTMatrixCollection sharedCollection] scaleTransformationMatrixWithScalingPercentageOfX:1 // Keep x.
																											 andY:1 // Keep y.
																											 andZ:p] // Scale z-axis.
			  inTheFront:YES]; // Put the matrix in the front.
}

// Scale the whole matrix by a given percentage.
-(void)scale_allAxisesByPercentge: (float) p
{
	if (self.homogeneous == NO) [self toHomogeneousMatrix]; // If it's not a homogeneous matrix, change it to homogeneous matrix.
	[self multiplyMatrix:[[MTMatrixCollection sharedCollection] scaleTransformationMatrixWithScalingPercentageOfX:p // Scale z-axis.
																											 andY:p // Scale y-axis.
																											 andZ:p] // Scale z-axis.
			  inTheFront:YES]; // Put the matrix in the front.
}

//*******************************************************************************//
//************************ Tranformation & Projection ***************************//
//*******************************************************************************//

@end
