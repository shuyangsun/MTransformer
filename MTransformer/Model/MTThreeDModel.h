//
//  MTThreeDModel.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/25/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTMatrix; // Declare class MTMatrix.

/**
 A class represents a 3D model object. It holds two status of matrix: \n
 1. Original Matrix. (3D) \n
 2. Realtime 3D model. (3D) \n
 For projection, it holds pme model:
 1. Truncated 3D model. (3D) \n\n
 It has a C float Array holding the points connecting to eachother.
 */
@interface MTThreeDModel : NSObject <NSCoding>

/**
 Data holds the original matrix.
 */
@property (strong, nonatomic) MTMatrix *originalModel;

/**
 A matrix holding all the transformation matrix
 */
@property (strong, nonatomic) MTMatrix *transformationMatrix;

/**
 Data holds the real time 3D model.
 */
@property (strong, nonatomic) MTMatrix *realTimeModel;

/**
 A desired distance to project project from z-axis.
 */
@property (nonatomic) float desiredProjectionDistanceFor_zAxis;

/**
 A desired distance to project project from y-axis.
 */
@property (nonatomic) float desiredProjectionDistanceFor_yAxis;

/**
 A desired distance to project project from x-axis.
 */
@property (nonatomic) float desiredProjectionDistanceFor_xAxis;

/**
 The desired scalar for this model.
 */
@property (nonatomic) float desiredScalar;

/**
 The name of this Model.
 */
@property (copy, nonatomic) NSString *name;

/**
 Initialize with a original matrix.
 @param Original matrix.
 */
-(id)initWithOriginalMatrix: (MTMatrix *) original;

/**
 Get a model with a original matrix.
 @param Original matrix.
 */
+(id)modelWithOriginalMatrix: (MTMatrix *) original;

/**
 Use NSCoding protocol to create a deepcopy of this object.
 */
-(id)deepCopy;

@end
