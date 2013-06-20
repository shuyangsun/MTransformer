//
//  MTPoint.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/20/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTVector; // Define class MTVector


/**
 @interface A MTPoint object that holds a vector representing the posistion in the space, and other data such as the points it connects to, and the visit information for graph triversal.
 */
@interface MTPoint : NSObject

/**
 A vector holding the positon of point in the space.
 */
@property (strong, nonatomic) MTVector *vector;
/**
 Array of points holding the points it connects to.
 */
@property (strong, nonatomic) NSMutableArray *connectedPoints;
/**
 If the point is vistied during the graph traversal.
 */
@property (nonatomic) BOOL visited;

@end
