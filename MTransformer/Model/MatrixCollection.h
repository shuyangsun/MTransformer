//
//  MatrixCollection.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/22/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTMatrix; // Define class MTMatrix.

/**
 A class for getting pre-defined matrices. Including matrices required for projection.
 */
@interface MatrixCollection : NSObject

/**
 Class method return a unique MatrixCollection object, MatrixCollection can only be created once and can only have one unique instance at the time. 
 Methods allocWithZone are overriden to a dumy method, return the same result as this method.
 */
+(id)sharedCollection;

/**
 A matrix to project 3D graph from point (0, 0, d).
 Returns matrix: 
 
 | 1 0   0  0 |
 | 0 1   0  0 |
 | 0 0   0  0 |
 | 0 0 -1/d 0 |
 
 @param d distance from the view point to projection plane.
 @return The matrix for projection transformation.
 */
-(MTMatrix *)projectionTransformationMatrixWithDistanceAtZAxis: (float) d;

/**
 A matrix to project 3D graph from point (b, c, d). 
 Returns matrix:

 | 1 0 -b/d 0 |
 | 0 1 -c/d 0 |
 | 0 0   0  0 |
 | 0 0 -1/d 0 |

 @param b x value of view point.
 @param c y value of view point.
 @param d z value of view point.
 @return The matrix for projection transformation.
 */
-(MTMatrix *)projectionTransformationMatrixFromX: (float) b
											andY: (float) c
											andD: (float) d;

/**
 A matrix perform the transformation 
 Returns matrix: 

 | 1 0 0 h |
 | 0 1 0 k |
 | 0 0 1 l |
 | 0 0 0 1 |

 @param h Distance want to move in x axis.
 @param k Distance want to move along y axis.
 @param l Distance want to move along z axis.
 @return The matrix for movement transformation.
 */
-(MTMatrix *)mtranslateTransformationMatrixWith_xValue: (float) h
											and_yValue: (float) k
											and_zValue: (float) l;

@end
