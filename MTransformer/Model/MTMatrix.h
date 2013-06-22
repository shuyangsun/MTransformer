//
//  MTMatrix.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/21/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTVector; // Class declaration for MTVector.

@interface MTMatrix : NSObject <NSCopying, NSMutableCopying> // Satisfied protocols.

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
 @param fVals A two dimensional C style float array used to initialize matrix. First index is column (index of vector), secone is row.
 */
-(id)initWithFloatValues: (float **) fVals; // C involved.

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
-(BOOL)multiplyMatrix: (MTMatrix *) anotherMatrix inTheFront: (BOOL) front;

//************************ Linear Algebra Calculation ***************************//

@end

