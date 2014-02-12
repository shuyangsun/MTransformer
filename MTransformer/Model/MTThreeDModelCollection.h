//
//  MTThreeDModelCollection.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/26/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTThreeDModel; //Declare class.

@interface MTThreeDModelCollection : NSObject

//************************ Properties ***************************//

//************************ Properties ***************************//

//************************ Initializers  ***************************//

/**
 Return a unique object of this class.
 */
+(id)sharedCollection;

//************************ Initializers  ***************************//

//************************ Methods ***************************//

/**
 Return the number of model.
 */
-(NSUInteger) totalModelCount;

/**
 The default 3D model.
 */
-(MTThreeDModel *)defaultModel;

/**
 Return a 3D model of toyota.
 */
-(MTThreeDModel *)toyotaModel;

/**
 Return a 3D model of cube.
 */
-(MTThreeDModel *)cubeModel;

/**
 Return a 3D model with 3 lines.
 */
-(MTThreeDModel *)lineModel;

/**
 Return a model with specific index in settings.
 */
-(MTThreeDModel *)modelWithIndex: (NSUInteger) index;
//************************ Methods ***************************//
@end
