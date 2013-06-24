//
//  MTViewController.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/19/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTViewController.h"

#import "GlobalMacro.h"
#import "MTVector.h"
#import "MTPoint.h"
#import "MTMatrix.h"

@interface MTViewController ()

//************************ Demo For Transformation & Projection ***************************//
/**
 A method to demostration matrix transformation and projection.
 */
-(void)demo;
//************************ Demo For Transformation & Projection ***************************//

@end

@implementation MTViewController

-(void)setup
{
	// Initialization code here...
	[self demo]; // Demostrate the transformation and projection.
}

-(void)awakeFromNib
{
	[self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

//*****************************************************************************************//
//************************ Demo For Transformation & Projection ***************************//
//*****************************************************************************************//

// A private helper method to demostrate matrix transformation and projection.
-(void)demo
{
	float fVals[] = {1, 4, 7,
		2, 5, 8,
		3, 6, 9};
	MTMatrix *matrix = [[MTMatrix alloc] initWithFloatValues:MTCStyleMatrixMake(3, 3, fVals)];
	NSLog(@"Original matrix: \n%@", matrix);
	[matrix moveAlong_xAxisWithDistance:1];
	NSLog(@"After move along x-axis by 1 point: \n%@", matrix);
	[matrix rotateAbout_zAxisWithAngle:(M_PI * 0.25)];
	NSLog(@"After rotate about z with 1/4 Pi: \n%@", matrix);
}

//*****************************************************************************************//
//************************ Demo For Transformation & Projection ***************************//
//*****************************************************************************************//

@end
