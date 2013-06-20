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

//************************ Property ***************************//

/** A vector holding the positon of point in the space. */
@property (strong, nonatomic) MTVector *vector;

/** Mutable set of points holding the points it connects to. */
@property (strong, nonatomic) NSMutableSet *pointsConnectingTo;

/** Whether the point is vistied during the graph traversal. */
@property (nonatomic) BOOL visited;

//************************ Property ***************************//

//************************ Methods ***************************//

/**
 @method Connect this point to another point, takes only one argument. Also connect the other point to itself.
 @param point Point connecting to.
 */
-(void)connectToPoint: (MTPoint *) point;

/** 
 @method Connect this point to multiple points, takes a NSArray as argument. Also connect other points to itself.
 @param points Points this point connecting to. (Should be a collection)
 */
-(void)connectToPoints: (id) points; // WARNING! points should be a collection!

//************************ Methods ***************************//



@end
