//
//  MTMatrix.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/21/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GlobalMacro.h" // Include global macro to get MTCStyleMatrix.

@class MTVector; // Class declaration for MTVector.

/**
 A class representing a matrix, contains a array of vectors.
 */
@interface MTMatrix : NSObject <NSCopying, NSMutableCopying, NSCoding> // Satisfied protocols.

//************************ Properties ***************************//

/** A array holding all the vectors in the matrix. */
@property (strong, nonatomic) NSMutableArray *vectors;

/** Property indicating whether this matrix is a homogeneous matrix. */
@property (readonly, nonatomic, getter = isHomogeneous) BOOL homogeneous;

//************************ Properties ***************************//

//************************ Initializers  ***************************//

/** 
 Initialize this matrix with given vectors.
 @param theVectors Vectors initializing matrix.
 */
-(id)initWithVectors: (NSArray *) theVectors;

/**
 Initialize this matrix with given two dimensional array.
 @param cStyleMatrix A C style matrix defined in header file "GlobalMacros".
 */
-(id)initWithFloatValues: (MTCStyleMatrix) cStyleMatrix;

//************************ Initializers  ***************************//
 
//************************ Methods ***************************//

/**
 Convert this matrix to a homogeneous matrx.
 */
-(void)toHomogeneousMatrix;

/** 
 Get the homogeneous version of this matrix.
 @return Return the homogeneous version of this matrix.
 */
-(MTMatrix *)getHomogeneousMatrix;

/**
 User NSCoding protocol to create a deepcopy of this object.
 */
-(id)deepCopy;

//************************ Methods ***************************//

//************************ Linear Algebra Calculation ***************************//

/**
 Add this matrix to another one. Return NO if plus operation is not defined, YES if succeed.
 @param anotherMatrix The matrix adding to this one.
 @return Whether the plus operation if defined or not.
 */
-(BOOL)addMatrix: (MTMatrix *) anotherMatrix;

/**
 Substract another matrix by this one. Return NO if minus operation is not defined, YES if succeed.
 @param anotherMatrix The matrix substracting by this one.
 @return Whether the minus operation if defined or not.
 */
-(BOOL)substractMatrix: (MTMatrix *) anotherMatrix;

/**
 Multiply this matrix by a vector, return YES if it's possible, NO otherwise. (After multiplication, this matrix will become a vector.)
 @param vector Vector to multiply.
 @return If the multiplication is defined, multiply and return YES, NO otherwise.
 */
-(MTVector *)multiplyVector: (MTVector *) vector;

/**
 Multiply this matrix by another matrix, return YES if it's possible, NO otherwise.
 @param anotherMatrix Matrix to multiply.
 @param front Boolean value indicate whether the other matrix should be in the front of this matrix.
 @return If the multiplication is defined, multiply and return YES, NO otherwise.
 */
-(BOOL)multiplyMatrix: (MTMatrix *) anotherMatrix
		   inTheFront: (BOOL) front;

//************************ Linear Algebra Calculation ***************************//

//*******************************************************************************//
//************************ Tranformation & Projection ***************************//
//*******************************************************************************//

/**
 Method return transformed 2 x n matrix.
 @param axis Axis to project from.
 @param d Distance of view point from given axis.
 @return A transformed matrix ready for display on 2D graph through given axis.
 */
-(MTMatrix *)matrixByProjectOnPlaneThroughAxis: (MT_AXIS) axis withDistance: (float) d;

/**
 Method return transformed 2 x n matrix, vectors are coresponding points on plane formed by y-axis and z-axis.
 @param d Distance of view point from x-axis.
 @return A transformed matrix ready for display on 2D graph through x-axis.
 */
-(MTMatrix *)matrixByProjectOnPlaneThrough_xAxisWithDistance: (float) d;
/**
 Method return transformed 2 x n matrix, vectors are coresponding points on plane formed by x-axis and z-axis.
 @param d Distance of view point from y-axis.
 @return A transformed matrix ready for display on 2D graph through y-axis.
 */
-(MTMatrix *)matrixByProjectOnPlaneThrough_yAxisWithDistance: (float) d;
/**
 Method return transformed 2 x n matrix, vectors are coresponding points on plane formed by x-axis and y-axis.
 @param d Distance of view point from z-axis.
 @return A transformed matrix ready for display on 2D graph through z-axis.
 */
-(MTMatrix *)matrixByProjectOnPlaneThrough_zAxisWithDistance: (float) d;

/**
 Move matrix with a specific distance along given axis.
 @param axis Axis to move.
 @param d Distance to move.
 @para
 */
-(void)moveAlongAxis: (MT_AXIS) axis withDistance: (float) d;
/**
 Move matrix along x-axis with a specific distance.
 @param d Distance to move.
 */
-(void)moveAlong_xAxisWithDistance: (float) d;
/**
 Move matrix along y-axis with a specific distance.
 @param d Distance to move.
 */
-(void)moveAlong_yAxisWithDistance: (float) d;
/**
 Move matrix along z-axis with a specific distance.
 @param d Distance to move.
 */
-(void)moveAlong_zAxisWithDistance: (float) d;

/**
 Rotate the matrix about x-axis, with a given radian.
 @param radian Radian to rotate.
 */
-(void)rotateAbout_xAxisWithAngle: (double) radian;
/**
 Rotate the matrix about y-axis, with a given radian.
 @param radian Radian to rotate.
 */
-(void)rotateAbout_yAxisWithAngle: (double) radian;
/**
 Rotate the matrix about z-axis, with a given radian.
 @param radian Radian to rotate.
 */
-(void)rotateAbout_zAxisWithAngle: (double) radian;

/**
 Scale the x-axis by a given percentage.
 @param p Percentage to scale.
 */
-(void)scale_xAxisByPercentge: (float) p;
/**
 Scale the y-axis by a given percentage.
 @param p Percentage to scale.
 */
-(void)scale_yAxisByPercentge: (float) p;
/**
 Scale the z-axis by a given percentage.
 @param p Percentage to scale.
 */
-(void)scale_zAxisByPercentge: (float) p;
/**
 Scale the whole matrix by a given percentage.
 @param p Percentage to scale.
 */
-(void)scale_allAxisesByPercentge: (float) p;

//*******************************************************************************//
//************************ Tranformation & Projection ***************************//
//*******************************************************************************//

@end

