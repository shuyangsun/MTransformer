//
//  MTGraphDisplayView.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/25/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTMatrix.h" // Import matrix header file.
#import "MTVector.h" // Import vector header file.
#import "MTPoint.h" // Import point header file.

@interface MTGraphDisplayView : UIView

/**
 A matrix property holding the points of this graph.
 */
@property (strong, nonatomic) MTMatrix *matrix;

/**
 The scalar for displaying.
 */
@property (nonatomic) float scalar;

@end
