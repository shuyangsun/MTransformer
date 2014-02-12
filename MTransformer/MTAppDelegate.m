//
//  MTAppDelegate.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/19/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTAppDelegate.h"
#import "GlobalMacro.h"

// For Demo:
#import "MTVector.h"
#import "MTMatrix.h"
#import "MTMatrixCollection.h"
#import "MTThreeDModel.h"
#import "MTThreeDModelCollection.h"

@interface MTAppDelegate()

/**
 A method to demostration matrix transformation and projection.
 */
-(void)demo;

@end

@implementation MTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

	// Demo:
//	[self demo];

	// Set the default settings:
	NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_NAME] mutableCopy];
	if (!settings) {settings = [[NSMutableDictionary alloc] init];
		[settings setObject:[NSNumber numberWithBool:NO] forKey:SETTINGS_AXIS_LABEL];
		[settings setObject:[NSNumber numberWithBool:NO] forKey:SETTINGS_SCALE_SINGLE_AXIS];
		[settings setObject:[NSNumber numberWithBool:NO] forKey:SETTINGS_SHAKE_TO_RESET];
		[settings setObject:[NSNumber numberWithBool:NO] forKey:SETTINGS_POINTS_INFORMATION];
		[settings setObject:[NSNumber numberWithUnsignedInteger:0] forKey:SETTINGS_MODEL_INDEX];
	}

	[[NSUserDefaults standardUserDefaults] setObject:settings forKey:SETTINGS_DICTIONARY_NAME];
	[[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[[NSUserDefaults standardUserDefaults] synchronize]; // Synchronize setttings.
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//************************ Demo For Transformation & Projection ***************************//

// A private helper method to demostrate matrix transformation and projection.
-(void)demo
{
	printf("%s", "\n\n*****************************************************************************************\
		   \n*************************************  DEMO  ********************************************\
		   \n*****************************************************************************************\n\n"); // Print out DEMO symbol.

	//************************ Initialization Demo ***************************//

	//************************ Toyota Initializer ***************************//
	MTMatrix *matrix = [[[MTThreeDModelCollection sharedCollection] toyotaModel].originalModel deepCopy];
	//************************ Toyota Initializer ***************************//

	//************************ Out of Range Initializer ***************************//
//	float fVals[] = {0, 0,
//					 0, 1,
//					 2, 0};
//	
//	char connectionData[] = {0, 1,
//							 1, 0};
//	
//	MTMatrix *matrix = [[MTMatrix alloc] initWithFloatValues:MTCStyleMatrixMake(3, 2, fVals)
//									 andPointsConnectionData:connectionData]; // Make the C style matrix for initialization, and connect points.
	//************************ Out of Range Initializer ***************************//
	NSLog(@"Original matrix: \n%@\n", matrix); // Pint out the original matrix.
	//************************ Initialization Demo ***************************//

	// For questions:
	[matrix toHomogeneousMatrix];
	[matrix multiplyMatrix:[[MTMatrixCollection sharedCollection] projectionTransformationMatrixFromPoint: MT3DPointMake(-5, 10, 10) fromAxis:Z] inTheFront:YES]; // Put the matrix in the front.
	for (size_t i = 0; i < [matrix.vectors count]; ++i) { // Iterate through all vectors:
		[matrix.vectors[i] projectingTo2DPlaneFromAxis:Z]; // Project vectors.
	}
	NSLog(@"Projecting on (-5, 10, 10): \n%@\n", matrix);

	matrix = [[[MTThreeDModelCollection sharedCollection] toyotaModel].originalModel deepCopy];
	[matrix toHomogeneousMatrix];
	[matrix multiplyMatrix:[[MTMatrixCollection sharedCollection] projectionTransformationMatrixFromPoint: MT3DPointMake(0, 10, 25) fromAxis:Z] inTheFront:YES]; // Put the matrix in the front.
	for (size_t i = 0; i < [matrix.vectors count]; ++i) { // Iterate through all vectors:
		[matrix.vectors[i] projectingTo2DPlaneFromAxis:Z]; // Project vectors.
	}
	NSLog(@"Projecting on (0, 10, 25): \n%@\n", matrix);

	matrix = [[[MTThreeDModelCollection sharedCollection] toyotaModel].originalModel deepCopy];
	[matrix toHomogeneousMatrix];
	[matrix rotateAbout_yAxisWithAngle:1.0/6.0*M_PI];
	[matrix multiplyMatrix:[[MTMatrixCollection sharedCollection] projectionTransformationMatrixFromPoint: MT3DPointMake(0, 10, 25) fromAxis:Z] inTheFront:YES]; // Put the matrix in the front.
	for (size_t i = 0; i < [matrix.vectors count]; ++i) { // Iterate through all vectors:
		[matrix.vectors[i] projectingTo2DPlaneFromAxis:Z]; // Project vectors.
	}
	NSLog(@"Rotate 30 degrees about y-axis, then projecting on (0, 10, 25): \n%@\n", matrix);

	matrix = [[[MTThreeDModelCollection sharedCollection] toyotaModel].originalModel deepCopy];
	[matrix toHomogeneousMatrix];
	[matrix rotateAbout_zAxisWithAngle:1.0/4.0*M_PI];
	[matrix multiplyMatrix:[[MTMatrixCollection sharedCollection] projectionTransformationMatrixFromPoint: MT3DPointMake(0, 10, 25) fromAxis:Z] inTheFront:YES]; // Put the matrix in the front.
	for (size_t i = 0; i < [matrix.vectors count]; ++i) { // Iterate through all vectors:
		[matrix.vectors[i] projectingTo2DPlaneFromAxis:Z]; // Project vectors.
	}
	NSLog(@"Rotate 45 degrees about z-axis, then projecting on (0, 10, 25): \n%@\n", matrix);

	matrix = [[[MTThreeDModelCollection sharedCollection] toyotaModel].originalModel deepCopy];
	[matrix toHomogeneousMatrix];
	[matrix scale_allAxisesByPercentge:1.5];
	[matrix multiplyMatrix:[[MTMatrixCollection sharedCollection] projectionTransformationMatrixFromPoint: MT3DPointMake(0, 10, 25) fromAxis:Z] inTheFront:YES]; // Put the matrix in the front.
	for (size_t i = 0; i < [matrix.vectors count]; ++i) { // Iterate through all vectors:
		[matrix.vectors[i] projectingTo2DPlaneFromAxis:Z]; // Project vectors.
	}
	NSLog(@"Zoom in for 150%%, then projecting on (0, 10, 25): \n%@\n", matrix);
	// For questions.

	//************************ Transformation Demo ***************************//
//	[matrix rotateAbout_yAxisWithAngle:(M_PI * 1/6.0)]; // Rotate along y-axis countercockwise for 1/6 Pi.
//	NSLog(@"After rotate about Y-axis with 1/6 Pi: \n%@\n", matrix); // Print out matrix after moving.
//	[matrix rotateAbout_xAxisWithAngle:(M_PI * 1/6.0)]; // Rotate along x-axis countercockwise for 1/6 Pi.
//	NSLog(@"After rotate about X-axis with 1/6 Pi: \n%@\n", matrix); // Print out matrix after moving.
//	[matrix moveAlong_xAxisWithDistance:1.5]; // Move on x-axis for 1.5 points.
//	NSLog(@"After move along X-axis by 1.5 point: \n%@\n", matrix); // Print out matrix after moving.
//	[matrix rotateAbout_zAxisWithAngle:(M_PI * 0.25)]; // Rotate along z-axis countercockwise for 1/4 Pi.
//	NSLog(@"After rotate about Z-axis with 1/4 Pi: \n%@\n", matrix); // Print out matrix after rotation.
//	[matrix scale_allAxisesByPercentge:1.5]; // Scale the matrix by 1.5 percentage.
//	NSLog(@"After scaled by 1.5 percentage: \n%@\n", matrix); // Print out the matrix after scaling 1.5 percentage.
//	//************************ Transformation Demo ***************************//
	
//	//************************ Projection Demo ***************************//
//	float distanceFromViewPoint = 100; // Specify the distance from view point to the plane.
//	[self printDescriptionForProjectingMatrix:matrix FromAxis:X withDistance:distanceFromViewPoint]; // Print the 2D matrix on the lane.
//	distanceFromViewPoint = 50; // Change the distance to 50.
//	[self printDescriptionForProjectingMatrix:matrix FromAxis:X withDistance:distanceFromViewPoint]; // Print the 2D matrix on the lane.
//	distanceFromViewPoint = 40; // Change the distance to 40.
//	[self printDescriptionForProjectingMatrix:matrix FromAxis:Z withDistance:distanceFromViewPoint]; // Print the 2D matrix on the lane.
//	distanceFromViewPoint = 30; // Change the distance to 30.
//	[self printDescriptionForProjectingMatrix:matrix FromAxis:Z withDistance:distanceFromViewPoint]; // Print the 2D matrix on the lane.
//	distanceFromViewPoint = 20; // Change the distance to 20.
//	[self printDescriptionForProjectingMatrix:matrix FromAxis:Z withDistance:distanceFromViewPoint]; // Print the 2D matrix on the lane.
//	distanceFromViewPoint = 15; // Change the distance to 15.
//	[self printDescriptionForProjectingMatrix:matrix FromAxis:Z withDistance:distanceFromViewPoint]; // Print the 2D matrix on the lane.
//	distanceFromViewPoint = 10; // Change the distance to 10.
//	[self printDescriptionForProjectingMatrix:matrix FromAxis:Z withDistance:distanceFromViewPoint]; // Print the 2D matrix on the lane.
//	distanceFromViewPoint = 5.4; // Change the distance to 5.4.
//	[self printDescriptionForProjectingMatrix:matrix FromAxis:Z withDistance:distanceFromViewPoint]; // Print the 2D matrix on the lane.
//	distanceFromViewPoint = 5; // Change the distance to 5.
//	[self printDescriptionForProjectingMatrix:matrix FromAxis:Z withDistance:distanceFromViewPoint]; // Print the 2D matrix on the lane.
//	distanceFromViewPoint = 1; // Change the distance to 1.
//	[self printDescriptionForProjectingMatrix:matrix FromAxis:Z withDistance:distanceFromViewPoint]; // Print the 2D matrix on the lane.
//	distanceFromViewPoint = 0.5; // Change the distance to 0.5.
//	[self printDescriptionForProjectingMatrix:matrix FromAxis:Z withDistance:distanceFromViewPoint]; // Print the 2D matrix on the lane.
	//************************ Projection Demo ***************************//

	printf("%s", "\n\n*****************************************************************************************\
		   \n*************************************  DEMO  ********************************************\
		   \n*****************************************************************************************\n\n"); // Print out DEMO symbol.
}

// Helper method for printing message to print the information of projecting.
-(void)printDescriptionForProjectingMatrix: (MTMatrix *) theMatrix
								  FromAxis: (MT_AXIS) axis
							  withDistance: (float) distance
{
	MTMatrix *matrix = [theMatrix matrixByProjectOnPlaneThroughAxis: axis // Calculate projected matrix.
													   withDistance: distance
												   handleOutOfRange: YES]; // !!! Change the BOOL value here to determine whether it should handle out of range problem or not. !!! //
	NSMutableString *message = [NSMutableString stringWithString:@"Project on 2D plane from "]; // Create mutable string to append information.
	NSString *axisFrom; // Create a string representing the axis.
	NSString *firstAxisOfPlane; // The first axis of plane.
	NSString *secondAxisOfPlane; // Second axis of plane.
	switch (axis) { // Switch between different axises.
		case X: // If it's from x-axis:
			axisFrom = @"X"; // Assign value of axisFrom to @"X".
			firstAxisOfPlane = @"Y"; // Assign @"Y" to firstAxisOfPlane.
			secondAxisOfPlane = @"Z"; // Assign @"Z" to secondAxisOfPlane.
			break;
		case Y: // If it's from y-axis:
			axisFrom = @"Y"; // Assign value of axisFrom to @"Y".
			firstAxisOfPlane = @"X"; // Assign @"X" to firstAxisOfPlane.
			secondAxisOfPlane = @"Z"; // Assign @"Z" to secondAxisOfPlane.
			break;
		case Z: // If it's from z-axis:
			axisFrom = @"Z"; // Assign value of axisFrom to @"Z".
			firstAxisOfPlane = @"X"; // Assign @"X" to firstAxisOfPlane.
			secondAxisOfPlane = @"Y"; // Assign @"Y" to secondAxisOfPlane.
			break;
		default: // If none of the above is the case:
			axisFrom = @"N/A"; // Set the default to N/A.
			break;
	}
	[message appendFormat:@"%@ axis with distance: %.1f\n", axisFrom, distance]; // Append axis from and other messages.
	[message appendFormat:@"%@: ", firstAxisOfPlane]; // Append the first axis of plane.
	int indexOfFirstNewLineCharacter = [[matrix description] rangeOfString:@"\n"].location; // Get the index of first new line character.
	[message appendFormat:@"%@", [[matrix description]
								  substringWithRange:NSMakeRange(0, indexOfFirstNewLineCharacter + 1)]]; // Append the first part of matrix decription.
	[message appendFormat:@"%@: ", secondAxisOfPlane]; // Append the description of second axis of plane.
	[message appendFormat:@"%@", [[matrix description]
								  substringWithRange:NSMakeRange(indexOfFirstNewLineCharacter + 1,[[matrix description] length] - (indexOfFirstNewLineCharacter + 1))]]; // Append string second part of matrix description.
	[message appendString:@"\n"]; // Append a new line character.

	printf("%s", [message UTF8String]); // Print out the message.
}

//************************ Demo For Transformation & Projection ***************************//

@end
