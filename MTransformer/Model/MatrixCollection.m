//
//  MatrixCollection.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/22/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MatrixCollection.h"

#import "MTMatrix.h" // Import header file for MTMatrix

#include "GlobalMacro.h" // Include global macros.

@interface MatrixCollection() // Class extension

@end

@implementation MatrixCollection

// Return the unique sharedCollection of matrix collection.
+(id)sharedCollection
{
	static MatrixCollection *res = nil; // Set the result to be static and nil.
	if (!res) res = [[super allocWithZone:nil] init]; // If not initialized, initialize it.
	return res; // Return the res.
}

// Override allocWithZone method to return the sharedCollection, becomes a dummy method.
+(id)allocWithZone:(struct _NSZone *)zone
{
	return [MatrixCollection sharedCollection]; // Return the shared collection.
}

/**

 | 1 0   0  0 |
 | 0 1   0  0 |
 | 0 0   0  0 |
 | 0 0 -1/d 0 |

 */
-(MTMatrix *)projectionTransformationMatrixWithDistanceAtZAxis: (float) d
{
	float fVals[4][4] =
	   {1, 0,	0,	   0, // Keep x value.
		0, 1,	0,	   0, // Keep y value.
		0, 0,	0,	   0, // Clear z value. (projecting to 2D, so there is no z value)
		0, 0, -(1.0/d), 0}; // Set the scale parameter.

	return [[MTMatrix alloc] initWithFloatValues: (float **)fVals]; // Return initialized matrix. (need to cast fVals to type (float **) )
}

/**

 | 1 0 -b/d 0 |
 | 0 1 -c/d 0 |
 | 0 0   0  0 |
 | 0 0 -1/d 0 |

 */
-(MTMatrix *)projectionTransformationMatrixFromX: (float) b
											andY: (float) c
											andD: (float) d
{
	float fVals[4][4] =
	   {1, 0, -(b/d),   0, // Chaneg x value.
	    0, 1, -(c/d),   0, // Change y value.
	    0, 0,	0,     0, // Keep z value.
	    0, 0, -(1.0/d), 0}; // Set the scale parameter.

	return [[MTMatrix alloc] initWithFloatValues: (float **)fVals]; // Return initialized matrix. (need to cast fVals to type (float **) )
}

/**

 | 1 0 0 h |
 | 0 1 0 k |
 | 0 0 1 l |
 | 0 0 0 1 |

 */
-(MTMatrix *)mtranslateTransformationMatrixWith_xValue: (float) h
											and_yValue: (float) k
											and_zValue: (float) l
{
	float fVals[4][4] =
		{1, 0,	0,	h, // Change x value.
		 0, 1,	0,	k, // Change y value.
		 0, 0,	1,	l, // Change z value.
		 0, 0,	0,	1}; // Keep the scale parameter.

	return [[MTMatrix alloc] initWithFloatValues: (float **)fVals]; // Return initialized matrix. (need to cast fVals to type (float **) )
}

@end
