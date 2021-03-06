//
//  MatrixCollection.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/22/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTMatrixCollection.h"

#import "MTMatrix.h" // Import header file for MTMatrix
// "GlobalMacro.h" imported in header file.

@interface MTMatrixCollection() // Class extension

@end

@implementation MTMatrixCollection

// Return the unique sharedCollection of matrix collection.
+(id)sharedCollection
{
	static MTMatrixCollection *res = nil; // Set the result to be static and nil.
	if (!res) res = [[super allocWithZone:nil] init]; // If not initialized, initialize it.
	return res; // Return the res.
}

// Override allocWithZone method to return the sharedCollection, becomes a dummy method.
+(id)allocWithZone:(struct _NSZone *)zone
{
	return [MTMatrixCollection sharedCollection]; // Return the shared collection.
}

/**
 Return a 4x4 identiry matrix

 | 1 0 0 0 |
 | 0 1 0 0 |
 | 0 0 1 0 |
 | 0 0 0 1 |
 */
-(MTMatrix *)identityMatrix_4x4
{
	float fVals[] =
	{1, 0, 0, 0,
	 0, 1, 0, 0,
	 0, 0, 1, 0,
	 0, 0, 0, 1};
	
	MTMatrix *res = [[MTMatrix alloc] initWithFloatValues:MTCStyleMatrixMake(4, 4, fVals)];
	res.homogeneous = YES;
	return res;
}

/**

 | 1 0 -b/d 0 |
 | 0 1 -c/d 0 |
 | 0 0   0  0 |
 | 0 0 -1/d 0 |

 */
-(MTMatrix *)projectionTransformationMatrixFromPoint: (MT3DPoint) point fromAxis: (MT_AXIS) axis
{
	float b = 0.0f;
	float c = 0.0f;
	float d = 0.0f;
	switch (axis) {
		case Z:
			b = point.x;
			c = point.y;
			d = point.z;
			float fVals1[] =
			{1, 0, -(b/d), 0, // Chaneg x value.
			0, 1, -(c/d), 0, // Change y value.
			0, 0,	 0,   0, // Keep z value.
			0, 0, -(1/d), 1}; // Set the scale parameter.

			return [[MTMatrix alloc] initWithFloatValues: MTCStyleMatrixMake(SIZE_OF_TRANSFORMATION_MATRIX,
																			 SIZE_OF_TRANSFORMATION_MATRIX,
																			 fVals1)]; // Return initialized matrix.
			break;
		case Y:
			b = point.z;
			c = point.x;
			d = point.y;
			float fVals2[] =
			{0, -(b/d), 1, 0, // Chaneg x value.
			 1, -(c/d), 0, 0, // Change y value.
			 0,	  0,	0, 0, // Keep z value.
			 0, -(1/d), 0, 1}; // Set the scale parameter.

			return [[MTMatrix alloc] initWithFloatValues: MTCStyleMatrixMake(SIZE_OF_TRANSFORMATION_MATRIX,
																			 SIZE_OF_TRANSFORMATION_MATRIX,
																			 fVals2)]; // Return initialized matrix.
			break;
		case X:
			b = point.y;
			c = point.z;
			d = point.x;
			float fVals3[] =
			{-(b/d), 1, 0, 0, // Chaneg x value.
			 -(c/d), 0, 1, 0, // Change y value.
				0,	 0,	0, 0, // Keep z value.
			 -(1/d), 0, 0, 1}; // Set the scale parameter.

			return [[MTMatrix alloc] initWithFloatValues: MTCStyleMatrixMake(SIZE_OF_TRANSFORMATION_MATRIX,
																			 SIZE_OF_TRANSFORMATION_MATRIX,
																			 fVals3)]; // Return initialized matrix.
			break;
		default:
			break;
	}
	return nil; // Never gonna happen!!!
}

// Dummy method.
-(MTMatrix *)projectionTransformationMatrixTo_xAxisFromPoint:(MT3DPoint)point
{
	return [self projectionTransformationMatrixFromPoint:point fromAxis:X];
}

// Dummy method.
-(MTMatrix *)projectionTransformationMatrixTo_yAxisFromPoint:(MT3DPoint)point
{
	return [self projectionTransformationMatrixFromPoint:point fromAxis:Y];
}

// Dummy method.
-(MTMatrix *)projectionTransformationMatrixTo_zAxisFromPoint:(MT3DPoint)point
{
	return [self projectionTransformationMatrixFromPoint:point fromAxis:Z];
}

/**

 | 1 0 0 h |
 | 0 1 0 k |
 | 0 0 1 l |
 | 0 0 0 1 |

 */
-(MTMatrix *)translateTransformationMatrixWith_xValue: (float) h
										   and_yValue: (float) k
										   and_zValue: (float) l
{
	float fVals[] =
	   {1, 0,	0,	h, // Change x value.
		0, 1,	0,	k, // Change y value.
		0, 0,	1,	l, // Change z value.
		0, 0,	0,	1}; // Keep the scale parameter for final projection.

	return [[MTMatrix alloc] initWithFloatValues: MTCStyleMatrixMake(SIZE_OF_TRANSFORMATION_MATRIX,
																	 SIZE_OF_TRANSFORMATION_MATRIX,
																	 fVals)]; // Return initialized matrix.
}

/**

 X: | 1	  0		  0	   0 |  Y: |  cos(⨚) 0 sin(⨚) 0 |  Z: | cos(⨚) -sin(⨚) 0 0 |
	| 0 cos(⨚) -sin(⨚) 0 |	   |	0	 1   0	  0 |	  | sin(⨚)	cos(⨚) 0 0 |
	| 0 sin(⨚)	cos(⨚) 0 |	   | -sin(⨚) 0 cos(⨚) 0 |	  |	  0		 0	   1 0 |
	| 0	  0		  0	   1 |	   |	0	 0   0	  1 |	  |	  0		 0	   0 1 |

 */
-(MTMatrix *)rotationTransformationMatrixAboutAxis: (MT_AXIS) axis
										   byAngle: (double) radian
{
	MTMatrix *res = nil; // Declare result, set to nil for now.
	double r = radian; // Use r instead of radian.

	// Cannot use switch statement, don't know why...
	if (axis == X) { // If it's rorating about X axis:
		float fVals[] = {1,	  0,	  0,	 0,
						 0, cos(r),	-sin(r), 0,
						 0, sin(r),	 cos(r), 0,
						 0,	  0,	  0,	 1}; // Set values of the 2D float array.
		res = [[MTMatrix alloc] initWithFloatValues: MTCStyleMatrixMake(SIZE_OF_TRANSFORMATION_MATRIX,
																		SIZE_OF_TRANSFORMATION_MATRIX,
																		fVals)]; // Return initialized matrix.
	} else if (axis == Y) { // If it's rotating about Y axis:
		float fVals[] = { cos(r), 0, sin(r), 0,
							0,	  1,   0,	 0,
						 -sin(r), 0, cos(r), 0,
							0,	  0,   0,	 1}; // Set values of the 2D float array.
		res = [[MTMatrix alloc] initWithFloatValues: MTCStyleMatrixMake(SIZE_OF_TRANSFORMATION_MATRIX,
																		SIZE_OF_TRANSFORMATION_MATRIX,
																		fVals)]; // Return initialized matrix.
	} else if (axis == Z) { // If it's rorating about Z axis:
		float fVals[] = {cos(r), -sin(r), 0, 0,
						 sin(r),  cos(r), 0, 0,
						  0,		0,	  1, 0,
						  0,		0,	  0, 1}; // Set values of the 2D float array.
		res = [[MTMatrix alloc] initWithFloatValues: MTCStyleMatrixMake(SIZE_OF_TRANSFORMATION_MATRIX,
																		SIZE_OF_TRANSFORMATION_MATRIX,
																		fVals)]; // Return initialized matrix.
	}
	return res; // Return the result.
}

/**

 | w 0 0 0 |
 | 0 p 0 0 |
 | 0 0 q 0 |
 | 0 0 0 1 |

 */
-(MTMatrix *)scaleTransformationMatrixWithScalingPercentageOfX: (float) w
														  andY: (float) p
														  andZ: (float) q
{
	float fVals[] = {w, 0,	0,	0, // Scale x-axis.
					 0, p,	0,	0, // Scale y-axis.
					 0, 0,	q,	0, // Scale z-axis.
					 0, 0,	0,	1}; // Keep the scale parameter for final projection.

	return [[MTMatrix alloc] initWithFloatValues: MTCStyleMatrixMake(SIZE_OF_TRANSFORMATION_MATRIX,
																	 SIZE_OF_TRANSFORMATION_MATRIX,
																	 fVals)]; // Return initialized matrix.
}

/**
 A matrix which scale all axises by given percentage.
 Reuturn matrix:

 | p 0 0 0 |
 | 0 p 0 0 |
 | 0 0 p 0 |
 | 0 0 0 1 |

 @param p The scaling percentage for all axises.
 @return The matrix for scaling transformation.
 */
-(MTMatrix *)scaleTransformationMatrixForAllAxisesWithScalingPercentage: (float) p
{
	// Call another method to scale each one individually.
	return [self scaleTransformationMatrixWithScalingPercentageOfX:p // Scale x-axis by p.
															  andY:p // Scale y-axis by p.
															  andZ:p]; // Scale z-axis by p.
}

@end
