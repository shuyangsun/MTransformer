//
//  MTPoint.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/20/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MTVector.h" // Import MTVector header file for super class.

/**
 A MTPoint object that holds a vector representing the posistion in the space, and other data such as the points it connects to, and the visit information for graph triversal.
 */
@interface MTPoint : MTVector <NSCoding> // Super class is MTVector, satisfy NSCoding protocol.

//************************ Properties ***************************//

/** The name of the point. */
@property (copy, nonatomic) NSString *name;

/** Mutable set of points holding the points it connects to. */
@property (strong, nonatomic) NSMutableSet *pointsConnectingTo;

/** Whether the point is vistied during the graph traversal. */
@property (nonatomic, getter = isVisited) BOOL visited;

//************************ Properties ***************************//

//************************ Initializers  ***************************//

/** 
 @method Initialize the point with a name.
 @param theName Name of the point.
 */
-(id)initWithName: (NSString *)theName;

/**
 @method Get a point with a name.
 @param theName Name of the point.
 */
+(id)pointWithName: (NSString *)theName;

//************************ Initializers  ***************************//

//************************ Methods ***************************//

/**
 @method Connect this point to another point, takes only one argument. Also connect the other point to itself.
 @param point Point connecting to.
 */
-(void)connectToPoint: (MTPoint *) point;

/**
 @method Disconnect this point from another point, takes only one argument. Also disconnect the other point from itself.
 @param point Point disconnecting from.
 */
-(void)disconnectFromPoint: (MTPoint *) point;

/** 
 @method Connect this point to multiple points, takes an id as argument. Also connect other points to itself.
 @param points Points this point connecting to. (Should be a collection)
 */
-(void)connectToPoints: (id) points; // WARNING! points should be a collection!

/**
 @method Disconnect this point from multiple points, takes an id as argument. Also disconnect other points from itself.
 @param points Points this point is disconnecting from. (Should be a collection)
 */
-(void)disconnectFromPoints: (id) points; // WARNING! points should be a collection!

/**
 @method Disconnect this point from all points connected. Also disconnect other points from itself.
 */
-(void)disconnectFromAllPoints; // WARNING! points should be a collection!

/** 
 @method Get the array version of pointsConnectingToProperty.
 @return A NSArray containing all the points connecting to.
 */
-(NSArray *)pointsConnectingToAsArray;

/**
 User NSCoding protocol to create a deepcopy of this object.
 */
-(id)deepCopy;

//************************ Methods ***************************//



@end
