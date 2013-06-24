//
//  MatrixCollection.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/22/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GlobalMacro.h" // Include global macros.

@class MTMatrix; // Define class MTMatrix.

/**
 A class for getting pre-defined matrices. Including matrices required for projection.
 */
@interface MatrixCollection : NSObject

//************************ Initializers  ***************************//

/**
 Class method return a unique MatrixCollection object, MatrixCollection can only be created once and can only have one unique instance at the time.
 Methods allocWithZone are overriden to a dumy method, return the same result as this method.
 */
+(id)sharedCollection;

//************************ Initializers  ***************************//

//************************ Methods ***************************//

/**
 A matrix to project 3D graph from point (b, c, d).
 Returns matrix:

 | 1 0 -b/d 0 |
 | 0 1 -c/d 0 |
 | 0 0   0  0 |
 | 0 0 -1/d 0 |

 @param point The values are (b, c, d).
 @return The matrix for projection transformation.
 */
-(MTMatrix *)projectionTransformationMatrixFromPoint: (MT3DPoint) point;

/**
 A matrix perform the transformation
 Returns matrix:

 | 1 0 0 h |
 | 0 1 0 k |
 | 0 0 1 l |
 | 0 0 0 1 |

 @param h Distance want to move in x-axis.
 @param k Distance want to move along y-axis.
 @param l Distance want to move along z-axis.
 @return The matrix for movement transformation.
 */
-(MTMatrix *)translateTransformationMatrixWith_xValue: (float) h
										   and_yValue: (float) k
										   and_zValue: (float) l;

/**
 Get the matrix to rotate about a specific axis by some radian angle.
 Return matrix:

 X: | 1	  0		  0	   0 |  Y: |  cos(⨚) 0 sin(⨚) 0 |  Z: | cos(⨚) -sin(⨚) 0 0 |
	| 0 cos(⨚) -sin(⨚) 0 |	   |	0	 1   0	  0 |	  | sin(⨚)	cos(⨚) 0 0 |
	| 0 sin(⨚)	cos(⨚) 0 |	   | -sin(⨚) 0 cos(⨚) 0 |	  |	  0		 0	   1 0 |
	| 0	  0		  0	   0 |	   |	0	 0   0	  1 |	  |	  0		 0	   0 1 |

 @param axis The axis to rotate, can be X, Y or Z. Typedefed in GlobalMacro.h, bit fields calculation involved.
 @param radian The radian of angle want to rotate.
 @return The matrix for rotation transformation.
 */
-(MTMatrix *)rotationTransformationMatrixAboutAxis: (MT_AXIS) axis
										   byAngle: (double) radian;


/**
 A matrix which scale each axis by given percentage.
 Reuturn matrix:
 
 | w 0 0 0 |
 | 0 p 0 0 |
 | 0 0 q 0 |
 | 0 0 0 1 |

 @param w The scaling percentage for x-axis.
 @param p The scaling percentage for y-axis.
 @param q The scaling percentage for z-axis.
 @return The matrix for scaling transformation.
 */
-(MTMatrix *)scaleTransformationMatrixWithScalingPercentageOfX: (float) w
														  andY: (float) p
														  andZ: (float) q;

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
-(MTMatrix *)scaleTransformationMatrixForAllAxisesWithScalingPercentage: (float) p;

//************************ Methods ***************************//


@end
