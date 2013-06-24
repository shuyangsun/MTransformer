//
//  MTMatrix.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/21/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "GlobalMacro.h" // Include global macro to get MTCStyleMatrix.

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

@end

