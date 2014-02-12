//
//  MTThreeDModel.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/25/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTThreeDModel.h"

#import "MTMatrix.h"
#import "MTMatrixCollection.h"

@implementation MTThreeDModel

// Initialize with original matrix.
-(id)initWithOriginalMatrix:(MTMatrix *)original
{
	self = [super init];
	if (self) {
		self.originalModel = original; // Set the original model. (also set realTime model with a deep copy)
		self.transformationMatrix = [[MTMatrixCollection sharedCollection] identityMatrix_4x4];
	}
	return self;
}

// Designated initializer
-(id)init
{
	return [self initWithOriginalMatrix:nil];
}

// Class method.
+(id)modelWithOriginalMatrix:(MTMatrix *)original
{
	return [[MTThreeDModel alloc] initWithOriginalMatrix:original];
}

// Override the setter for original model, set the realTimeModel too.
-(void)setOriginalModel:(MTMatrix *)originalModel
{
	_originalModel = originalModel; // Set original model.
	self.transformationMatrix = [[MTMatrixCollection sharedCollection] identityMatrix_4x4];
	self.realTimeModel = originalModel; // Set the realTimeModel as a deep copy.
}

// Override the setter for realTimeModel, make a deep copy.
-(void)setRealTimeModel:(MTMatrix *)realTimeModel
{
	_realTimeModel = [realTimeModel deepCopy]; // Make a deep copy of model.
}

//************************ Coding Protocol Methods ***************************//

-(MTMatrix *)transformationMatrix
{
	if (!_transformationMatrix) self.transformationMatrix = [[MTMatrixCollection sharedCollection] identityMatrix_4x4];
	return _transformationMatrix;
}

// Decoder: 
-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self) {
		self.originalModel = [aDecoder decodeObjectForKey:@"MTThreeDModelOriginalModel"];
		self.transformationMatrix = [aDecoder decodeObjectForKey:@"MTThreeDModeltransformationMatrix"];
		self.realTimeModel = [aDecoder decodeObjectForKey:@"MTThreeDModelRealTimeModel"];
		self.desiredScalar = [aDecoder decodeFloatForKey:@"MTThreeDModelDesiredScalar"];
		self.desiredProjectionDistanceFor_xAxis = [aDecoder decodeFloatForKey:@"MTThreeDModelDesiredProjectionDistanceFor_xAxis"];
		self.desiredProjectionDistanceFor_yAxis = [aDecoder decodeFloatForKey:@"MTThreeDModelDesiredProjectionDistanceFor_yAxis"];
		self.desiredProjectionDistanceFor_zAxis = [aDecoder decodeFloatForKey:@"MTThreeDModelDesiredProjectionDistanceFor_zAxis"];
		self.name = [aDecoder decodeObjectForKey:@"MTThreeDModelName"];
	}
	return self;
}

// Encoder:
-(void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.originalModel forKey:@"MTThreeDModelOriginalModel"];
	[aCoder encodeObject:self.transformationMatrix forKey:@"MTThreeDModeltransformationMatrix"];
	[aCoder encodeObject:self.realTimeModel forKey:@"MTThreeDModelRealTimeModel"];
	[aCoder encodeFloat:self.desiredScalar forKey:@"MTThreeDModelDesiredScalar"];
	[aCoder encodeFloat:self.desiredProjectionDistanceFor_xAxis forKey:@"MTThreeDModelDesiredProjectionDistanceFor_xAxis"];
	[aCoder encodeFloat:self.desiredProjectionDistanceFor_yAxis forKey:@"MTThreeDModelDesiredProjectionDistanceFor_yAxis"];
	[aCoder encodeFloat:self.desiredProjectionDistanceFor_zAxis forKey:@"MTThreeDModelDesiredProjectionDistanceFor_zAxis"];
	[aCoder encodeObject:self.name forKey:@"MTThreeDModelName"];
}

// Use NSCoding protocol to create a deepcopy of this object.
-(id)deepCopy
{
	return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

//************************ Coding Protocol Methods ***************************//

@end
