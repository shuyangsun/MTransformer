//
//  MTThreeDModelCollection.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/26/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTThreeDModelCollection.h"

#import "MTThreeDModel.h" // Import header file for 3D model.
#import "MTMatrix.h" // Import header file for matrix.

@implementation MTThreeDModelCollection

// Return a unique object.
+(id)sharedCollection
{
	static MTThreeDModelCollection *res = nil; // Set it to nil, only excuted once.
	if (!res) res = [[super allocWithZone:nil] init]; // Call alloc init of super class. (NSObject)
	return res; // Return the result.
}

// Override allocWithZone, dummy method.
+(id)allocWithZone:(struct _NSZone *)zone
{
	return [self sharedCollection]; // Call another method.
}

// Return the number of model.
-(NSUInteger)totalModelCount
{
	return 3;
}

// Return the defaul model.
-(MTThreeDModel *)defaultModel
{
	return [[MTThreeDModelCollection sharedCollection] toyotaModel]; // Return the toyota model.
}

// Return a 3D model of Toyota.
-(MTThreeDModel *)toyotaModel
{
	float fVals[] =
	   {-6.5, -6.5, -6.5, -6.5, -2.5, -2.5, -0.75, -0.75,  3.25, 3.25,  4.5, 4.5,  6.5, 6.5,  6.5,  6.5,
		-2.0, -2.0,  0.5,  0.5,  0.5,  0.5,  2.0,   2.0,   2.0,  2.0,   0.5, 0.5,  0.5, 0.5, -2.0, -2.0,
		-2.5,  2.5,  2.5, -2.5, -2.5,  2.5, -2.5,   2.5,  -2.5,  2.5,  -2.5, 2.5, -2.5, 2.5,  2.5, -2.5 }; // Initialize Toyota matrix with given values.

	
	char connectionData[] =
	//			  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16
		/*  1 */ {0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		/*  2 */  1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
		/*  3 */  0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		/*  4 */  1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		/*  5 */  0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		/*  6 */  0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
		/*  7 */  0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0,
		/*  8 */  0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0,
		/*  9 */  0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0,
		/* 10 */  0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0,
		/* 11 */  0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0,
		/* 12 */  0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0,
		/* 13 */  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1,
		/* 14 */  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0,
		/* 15 */  0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1,
		/* 16 */  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0 }; // Initialize connection data with 2D array.

	MTMatrix *matrix = [[MTMatrix alloc] initWithFloatValues:MTCStyleMatrixMake(3, 16, fVals)
									 andPointsConnectionData:connectionData]; // Make the C style matrix for initialization, and connect points.
	MTThreeDModel *res = [MTThreeDModel modelWithOriginalMatrix:matrix]; // Create a model, set the original matrix.
	res.name = @"Toyota";
	res.desiredScalar = 15; // Set the desired scalar for this model.
	res.desiredProjectionDistanceFor_zAxis = 80; // Set desired projection distance for z-axis
	res.desiredProjectionDistanceFor_yAxis = 80; // Set desired projection distance for y-axis
	res.desiredProjectionDistanceFor_xAxis = 80; // Set desired projection distance for x-axis
	return res; // Return the result.
}

// Return a 3D model of cube.
-(MTThreeDModel *)cubeModel
{
	float fVals[] =
	{-8, -8, -8, -8,  8, 8,  8,  8,
	 -8,  8,  8, -8, -8, 8,  8, -8,
	  8,  8, -8, -8,  8, 8, -8, -8}; // Initialize Toyota matrix with given values.


	char connectionData[] =
	//			  1  2  3  4  5  6  7  8 
		/*  1 */ {0, 1, 0, 1, 1, 0, 0, 0,
		/*  2 */  1, 0, 1, 0, 0, 1, 0, 0,
		/*  3 */  0, 1, 0, 1, 0, 0, 1, 0,
		/*  4 */  1, 0, 1, 0, 0, 0, 0, 1,
		/*  5 */  1, 0, 0, 0, 0, 1, 0, 1,
		/*  6 */  0, 1, 0, 0, 1, 0, 1, 0,
		/*  7 */  0, 0, 1, 0, 0, 1, 0, 1,
		/*  8 */  0, 0, 0, 1, 1, 0, 1, 0}; // Initialize connection data with 2D array.

	MTMatrix *matrix = [[MTMatrix alloc] initWithFloatValues:MTCStyleMatrixMake(3, 8, fVals)
									 andPointsConnectionData:connectionData]; // Make the C style matrix for initialization, and connect points.
	MTThreeDModel *res = [MTThreeDModel modelWithOriginalMatrix:matrix]; // Create a model, set the original matrix.
	res.name = @"Cube";
	res.desiredScalar = 7; // Set the desired scalar for this model.
	res.desiredProjectionDistanceFor_zAxis = 100; // Set desired projection distance for z-axis
	res.desiredProjectionDistanceFor_yAxis = 100; // Set desired projection distance for y-axis
	res.desiredProjectionDistanceFor_xAxis = 100; // Set desired projection distance for x-axis
	return res; // Return the result.

}

// Return a 3D model with 3 lines.
-(MTThreeDModel *)lineModel
{
	float fVals[] =
	{ 0,   0, 10, -10,  0,   0,
	  0,   0,  0,   0, 10, -10,
	 10, -10,  0,   0,  0,   0 }; // Initialize Toyota matrix with given values.


	char connectionData[] =
	//			  1  2  3  4  5  6
		/*  1 */ {0, 1, 1, 1, 1, 1,
		/*  2 */  1, 0, 1, 1, 1, 1,
		/*  3 */  1, 1, 0, 1, 1, 1,
		/*  4 */  1, 1, 1, 0, 1, 1,
		/*  5 */  1, 1, 1, 1, 0, 1,
		/*  6 */  1, 1, 1, 1, 1, 0 }; // Initialize connection data with 2D array.

	MTMatrix *matrix = [[MTMatrix alloc] initWithFloatValues:MTCStyleMatrixMake(3, 6, fVals)
									 andPointsConnectionData:connectionData]; // Make the C style matrix for initialization, and connect points.
	MTThreeDModel *res = [MTThreeDModel modelWithOriginalMatrix:matrix]; // Create a model, set the original matrix.
	res.name = @"Weirdo";
	res.desiredScalar = 7; // Set the desired scalar for this model.
	res.desiredProjectionDistanceFor_zAxis = 80; // Set desired projection distance for z-axis
	res.desiredProjectionDistanceFor_yAxis = 80; // Set desired projection distance for y-axis
	res.desiredProjectionDistanceFor_xAxis = 80; // Set desired projection distance for x-axis
	return res; // Return the result.
}

// Return a model with specific index in settings.
-(MTThreeDModel *)modelWithIndex:(NSUInteger)index
{
	MTThreeDModel *res;
	switch (index) { // Switch between indexes.
		case 0:
			res = [self toyotaModel];
			break;
		case 1:
			res = [self cubeModel];
			break;
		case 2:
			res = [self lineModel];
			break;
		default:
			res = [self defaultModel]; // Set the default to toyota model.
			break;
	}
	return res;
}

@end
