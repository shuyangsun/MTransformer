//
//  MTViewController.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/19/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTViewController.h"

#import <unistd.h> // For sleep.

#import "GlobalMacro.h"
#import "MTVector.h"
#import "MTPoint.h"
#import "MTMatrix.h"
#import "MTMatrixCollection.h"
#import "MTThreeDModel.h"
#import "MTThreeDModelCollection.h"
#import "MTGraphDisplayView.h"
#import "MTSettingsTableViewController.h"
#import "MTModelChooseViewController.h"

@interface MTViewController ()

@property (strong, nonatomic) UIPopoverController *popoverConroller;

/**
 Update all displays.
 */
- (void)updateDisplays;

@end

@implementation MTViewController

-(void)setup
{
	// Initialization code here...
	NSMutableDictionary *dic = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_NAME] mutableCopy];
	if (!dic) {
		dic = [[NSMutableDictionary alloc] init];
		[dic setObject:[NSNumber numberWithInteger:0] forKey:SETTINGS_MODEL_INDEX];

		[[NSUserDefaults standardUserDefaults] setObject:dic forKey:SETTINGS_DICTIONARY_NAME];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	self.currentModel = [[MTThreeDModelCollection sharedCollection] modelWithIndex:[[dic objectForKey:SETTINGS_MODEL_INDEX] unsignedIntegerValue]];
	self.currentModelIndex = [[dic objectForKey:SETTINGS_MODEL_INDEX] unsignedIntegerValue];
}


// Detect motions:
-(void)motionEnded:(UIEventSubtype)motion
		 withEvent:(UIEvent *)event
{
	// If the motion is shaking:
	if(motion == UIEventSubtypeMotionShake && [self isViewLoaded])
    {
		// If shake to reset is on:
		if ([[[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_NAME] objectForKey:SETTINGS_SHAKE_TO_RESET] boolValue] == YES) {
			[self resetTapped:nil];
		}
    }
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

-(void)viewDidLoad
{
	[super viewDidLoad]; // Call the super method.
	
	//************************ Add Gesture Recognizers ***************************//
	[self.bottomDisplay addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self
																					   action:@selector(pinchOnBottomDisplay:)]];
	[self.bottomDisplay addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self
																					 action:@selector(panOnBottomDisplay:)]];
	[self.bottomDisplay addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self
																						  action:@selector(rotateOnBottomDisplay:)]];

	[self.upperLeftDisplay addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self
																						  action:@selector(pinchOnUpperLeftDisplay:)]];
	[self.upperLeftDisplay addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self
																						action:@selector(panOnUpperLeftDisplay:)]];
	[self.upperLeftDisplay addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self
																							 action:@selector(rotateOnUpperLeftDisplay:)]];

	[self.upperRightDisplay addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self
																						   action:@selector(pinchOnUpperRightDisplay:)]];
	[self.upperRightDisplay addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self
																						 action:@selector(panOnUpperRightDisplay:)]];
	[self.upperRightDisplay addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self
																							  action:@selector(rotateOnUpperRightDisplay:)]];
	//************************ Add Gesture Recognizers ***************************//
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated]; // Call the super method.

	// Initialize the model:
	NSUInteger indexOfModel;
	NSMutableDictionary *dic = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_NAME] mutableCopy];
	if (!dic) {
		dic = [[NSMutableDictionary alloc] init];
		[dic setObject:[NSNumber numberWithInteger:0] forKey:SETTINGS_MODEL_INDEX];
		
		[[NSUserDefaults standardUserDefaults] setObject:dic forKey:SETTINGS_DICTIONARY_NAME];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	indexOfModel = [[dic objectForKey:SETTINGS_MODEL_INDEX] unsignedIntegerValue];
	if (self.currentModelIndex != indexOfModel) {
		self.currentModel = [[MTThreeDModelCollection sharedCollection] modelWithIndex:indexOfModel];
		self.currentModelIndex = indexOfModel;
	}

	// Set navigation bar title.
	self.navigationItem.title = self.currentModel.name; // Set the navigation bar title.

	// Get the settings for scaling:
	self.scaleOnSingleAxis = [[[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_NAME] objectForKey:SETTINGS_SCALE_SINGLE_AXIS] boolValue];

	// If axis lable should not be hidden:
	if ([[[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_NAME] objectForKey:SETTINGS_AXIS_LABEL] boolValue] == YES) { // If we need to show the axis label:
		for (size_t i = 0; i < [self.axisLabels count]; ++i) { // Loop through all axis labels.
			[[self.axisLabels objectAtIndex:i] setHidden:NO]; // Set hidden for all axis labels to NO.
		}
	} else { // If axis lable should be hidden:
		for (size_t i = 0; i < [self.axisLabels count]; ++i) { // Loop through all axis labels.
			[[self.axisLabels objectAtIndex:i] setHidden:YES]; // Set hidden for all axis labels to YES.
		}
	}

	// Wether or not show points information.
	if ([[[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_NAME] objectForKey:SETTINGS_POINTS_INFORMATION] boolValue] == YES) { // If we need to show the points information:
		self.upperLeftDisplay.hidden = YES; // Hide upper left display
		self.upperRightDisplay.hidden = YES; // Hide upper right display
		self.pointsInfoTextView.hidden = NO; // Show the points info text view.
	} else { // If we don't need to show the points info:
		self.upperLeftDisplay.hidden = NO; // Show upper left display
		self.upperRightDisplay.hidden = NO; // Show upper right display
		self.pointsInfoTextView.hidden = NO; // Hide the points info text view.
	}
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated]; // Call the super method.
}

-(void)viewDidAppear:(BOOL)animated
{
	[self updateDisplays]; // Update displays when views apear.
}

// Redraw all displays.
- (void)updateDisplays
{
	// Bottom display:
	if (self.bottomDisplay.hidden == NO) { // If the bottom display is not hidden:
		self.bottomDisplay.matrix = [self.currentModel.realTimeModel matrixByProjectOnPlaneThrough_zAxisWithDistance:self.currentModel.desiredProjectionDistanceFor_zAxis
																									handleOutOfRange:YES];
		self.bottomDisplay.scalar = self.currentModel.desiredScalar;
		[self.bottomDisplay setNeedsDisplay];
	}

	// Upper left display:
	if (self.upperLeftDisplay.hidden == NO) { // If the upper left display is not hidden:
		self.upperLeftDisplay.matrix = [self.currentModel.realTimeModel matrixByProjectOnPlaneThrough_yAxisWithDistance:self.currentModel.desiredProjectionDistanceFor_yAxis
																									   handleOutOfRange:YES ];
		self.upperLeftDisplay.scalar = self.currentModel.desiredScalar;
		[self.upperLeftDisplay setNeedsDisplay];
	}

	// Upper right display:
	if (self.upperRightDisplay.hidden == NO) { // If the upper right display is not hidden:
		self.upperRightDisplay.matrix = [self.currentModel.realTimeModel matrixByProjectOnPlaneThrough_xAxisWithDistance:self.currentModel.desiredProjectionDistanceFor_xAxis
																										handleOutOfRange:YES ];
		self.upperRightDisplay.scalar = self.currentModel.desiredScalar;
		[self.upperRightDisplay setNeedsDisplay];
	}

	// Points info:
	if (self.pointsInfoTextView.hidden == NO) { // If the points info display is not hidden:
		NSMutableString *info = [NSMutableString string];
		for (size_t i = 0; i < [self.currentModel.realTimeModel.vectors count] ; ++i) { // Loop through all the 3D points.
			[info appendFormat:@"%@\n", [[self.currentModel.realTimeModel.vectors objectAtIndex:i] description]]; // Append current point's description.
		}
		self.pointsInfoTextView.text = info; // Set the text of points info view.
	}
	
}

- (IBAction)settingsTapped:(id)sender {
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self updateDisplays];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([sender isKindOfClass:[UIBarButtonItem class]]) { // If sender is a bar button item:
		UIBarButtonItem *button = (UIBarButtonItem *)sender; // Get a pointer of this item.
		if ([button.title isEqualToString:@"Settings"]) { // If the button is Settings:
			if ([segue.destinationViewController isKindOfClass:[MTModelChooseViewController class]]) { // If the destination is a settings view controller:
				if ([segue isKindOfClass:[UIPopoverController class]]) { // If segue is a popoverController:
					self.popoverConroller = ((UIStoryboardPopoverSegue *)segue).popoverController; // Get a pointer of popover controller.
				}
			}
		}
	}
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
	if ([identifier isEqualToString:@"Show Models"]) {
		return !self.popoverConroller;
	} else {
		return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
	}
}

//************************ Gesture Handler ***************************//

// Handle pinch on bottom display
-(void)pinchOnBottomDisplay:(UIPinchGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {	// Update displays only when finished pinching
		if (self.scaleOnSingleAxis == NO) { // If we want to scale all axises:
			[self.currentModel.realTimeModel scale_allAxisesByPercentge:gestureRecognizer.scale]; // Scale all axises.
			[self.currentModel.transformationMatrix scale_allAxisesByPercentge:gestureRecognizer.scale]; // Scale all axises.
		} else { // If we only want to scale the axis it's projecting from:
			[self.currentModel.transformationMatrix multiplyMatrix:[[MTMatrixCollection sharedCollection] scaleTransformationMatrixWithScalingPercentageOfX:1 andY:1 andZ:gestureRecognizer.scale] inTheFront:NO]; // Scale single axis
			self.currentModel.realTimeModel = self.currentModel.originalModel; // Reset current model.
			[self.currentModel.realTimeModel toHomogeneousMatrix]; // Convert to homogeneous entry.
			[self.currentModel.realTimeModel multiplyMatrix:self.currentModel.transformationMatrix inTheFront:YES]; // Multiply the matrix.
		}
		[self updateDisplays]; // Update all displays. (recalculate all projections)
		gestureRecognizer.scale = 1; // Reset the scale (don't want accumulative scaling.)
	}
}

-(void)pinchOnUpperLeftDisplay:(UIPinchGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) { // Update displays only when finished pinching
		if (self.scaleOnSingleAxis == NO) { // If we want to scale all axises:
			[self.currentModel.realTimeModel scale_allAxisesByPercentge:gestureRecognizer.scale]; // Scale all axises.
			[self.currentModel.transformationMatrix scale_allAxisesByPercentge:gestureRecognizer.scale]; // Scale all axises.
		} else { // If we only want to scale the axis it's projecting from:
			[self.currentModel.transformationMatrix multiplyMatrix:[[MTMatrixCollection sharedCollection] scaleTransformationMatrixWithScalingPercentageOfX:1 andY:gestureRecognizer.scale andZ:1] inTheFront:NO]; // Scale single axis
			self.currentModel.realTimeModel = self.currentModel.originalModel; // Reset current model.
			[self.currentModel.realTimeModel toHomogeneousMatrix]; // Convert to homogeneous entry.
			[self.currentModel.realTimeModel multiplyMatrix:self.currentModel.transformationMatrix inTheFront:YES]; // Multiply the matrix.
		}
		[self updateDisplays]; // Update all displays. (recalculate all projections)
		gestureRecognizer.scale = 1; // Reset the scale (don't want accumulative scaling.)
	}
}

-(void)pinchOnUpperRightDisplay:(UIPinchGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) { // Update displays only when finished pinching
		if (self.scaleOnSingleAxis == NO) { // If we want to scale all axises:
			[self.currentModel.realTimeModel scale_allAxisesByPercentge:gestureRecognizer.scale]; // Scale all axises.
			[self.currentModel.transformationMatrix scale_allAxisesByPercentge:gestureRecognizer.scale]; // Scale all axises.
		} else { // If we only want to scale the axis it's projecting from:
			[self.currentModel.transformationMatrix multiplyMatrix:[[MTMatrixCollection sharedCollection] scaleTransformationMatrixWithScalingPercentageOfX:gestureRecognizer.scale andY:1 andZ:1] inTheFront:NO]; // Scale single axis
			self.currentModel.realTimeModel = self.currentModel.originalModel; // Reset current model.
			[self.currentModel.realTimeModel toHomogeneousMatrix]; // Convert to homogeneous entry.
			[self.currentModel.realTimeModel multiplyMatrix:self.currentModel.transformationMatrix inTheFront:YES]; // Multiply the matrix.
		}
		[self updateDisplays]; // Update all displays. (recalculate all projections)
		gestureRecognizer.scale = 1; // Reset the scale (don't want accumulative scaling.)
	}
}

-(void)panOnBottomDisplay:(UIPanGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) { // Update displays only when finished pinching
		CGPoint translation = [gestureRecognizer translationInView:self.bottomDisplay]; // Get the translationg information of gesture.
		CGRect bounds = self.bottomDisplay.bounds; // Get the bounds of this display.
		float rotationAngleHorizontally = translation.x/bounds.size.width * M_PI; // Get the horizontal rotation angle.
		float rotationAngleVertically = translation.y/bounds.size.height * M_PI; // Get the vertical rotation angle.

		[self.currentModel.realTimeModel rotateAbout_yAxisWithAngle:rotationAngleHorizontally]; // Rotate horizontally.
		[self.currentModel.realTimeModel rotateAbout_xAxisWithAngle:rotationAngleVertically]; // Rotate vertically.
		[self.currentModel.transformationMatrix rotateAbout_yAxisWithAngle:rotationAngleHorizontally];
		[self.currentModel.transformationMatrix rotateAbout_xAxisWithAngle:rotationAngleVertically];

		[self updateDisplays]; // Recalculate all projections, and update displays.
	}
}

-(void)panOnUpperLeftDisplay:(UIPanGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) { // Update displays only when finished pinching
		CGPoint translation = [gestureRecognizer translationInView:self.upperLeftDisplay]; // Get the translationg information of gesture.
		CGRect bounds = self.upperLeftDisplay.bounds; // Get the bounds of this display.
		float rotationAngleHorizontally = translation.x/bounds.size.width * M_PI/2; // Get the horizontal rotation angle. (only half)
		float rotationAngleVertically = translation.y/bounds.size.height * M_PI; // Get the vertical rotation angle.

		[self.currentModel.realTimeModel rotateAbout_xAxisWithAngle:rotationAngleHorizontally]; // Rotate horizontally.
		[self.currentModel.realTimeModel rotateAbout_zAxisWithAngle:rotationAngleVertically]; // Rotate vertically.
		[self.currentModel.transformationMatrix rotateAbout_xAxisWithAngle:rotationAngleHorizontally]; // Rotate horizontally.
		[self.currentModel.transformationMatrix rotateAbout_zAxisWithAngle:rotationAngleVertically]; // Rotate vertically.

		[self updateDisplays]; // Recalculate all projections, and update displays.
	}
}

-(void)panOnUpperRightDisplay:(UIPanGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) { // Update displays only when finished pinching
		CGPoint translation = [gestureRecognizer translationInView:self.upperRightDisplay]; // Get the translationg information of gesture.
		CGRect bounds = self.upperRightDisplay.bounds; // Get the bounds of this display.
		float rotationAngleHorizontally = translation.x/bounds.size.width * M_PI/2; // Get the horizontal rotation angle. (only half)
		float rotationAngleVertically = translation.y/bounds.size.height * M_PI; // Get the vertical rotation angle.

		[self.currentModel.realTimeModel rotateAbout_zAxisWithAngle:rotationAngleHorizontally]; // Rotate horizontally.
		[self.currentModel.realTimeModel rotateAbout_yAxisWithAngle:rotationAngleVertically]; // Rotate vertically.
		[self.currentModel.transformationMatrix rotateAbout_zAxisWithAngle:rotationAngleHorizontally]; // Rotate horizontally.
		[self.currentModel.transformationMatrix rotateAbout_yAxisWithAngle:rotationAngleVertically]; // Rotate vertically.

		[self updateDisplays]; // Recalculate all projections, and update displays.
	}
}

-(void)rotateOnBottomDisplay:(UIRotationGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) { // Update displays only when finished pinching
		[self.currentModel.realTimeModel rotateAbout_zAxisWithAngle:-gestureRecognizer.rotation]; // Rotate about axis this display is projecting from.
		[self.currentModel.transformationMatrix rotateAbout_zAxisWithAngle:-gestureRecognizer.rotation]; // Rotate about axis this display is projecting from.

		[self updateDisplays]; // Recalculate all projections, and update displays.
	}
}

-(void)rotateOnUpperLeftDisplay:(UIRotationGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) { // Update displays only when finished pinching
		[self.currentModel.realTimeModel rotateAbout_yAxisWithAngle:-gestureRecognizer.rotation]; // Rotate about axis this display is projecting from.
		[self.currentModel.transformationMatrix rotateAbout_yAxisWithAngle:-gestureRecognizer.rotation]; // Rotate about axis this display is projecting from.

		[self updateDisplays]; // Recalculate all projections, and update displays.
	}
}

-(void)rotateOnUpperRightDisplay:(UIRotationGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) { // Update displays only when finished pinching
		[self.currentModel.realTimeModel rotateAbout_xAxisWithAngle:-gestureRecognizer.rotation]; // Rotate about axis this display is projecting from.
		[self.currentModel.transformationMatrix rotateAbout_xAxisWithAngle:-gestureRecognizer.rotation]; // Rotate about axis this display is projecting from.

		[self updateDisplays]; // Recalculate all projections, and update displays.
	}
}

//************************ Gesture Handler ***************************//

// Reset button tapped:
-(void)resetTapped:(UIBarButtonItem *)sender
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.currentModel.name
													message:@"Are you sure you want to reset this model?"
												   delegate:self
										  cancelButtonTitle:@"Cancle"
										  otherButtonTitles:@"Reset", nil];
	[alert show];
}

// Override protocol method.
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([alertView.title isEqualToString:self.currentModel.name]) { // If this is reset alert:
		if (buttonIndex == 1) { // If reset is tapped:
			self.currentModel.realTimeModel = nil; // Release the old real time model.
			self.currentModel.realTimeModel = self.currentModel.originalModel; // Reset the real time model as original model.
			self.currentModel.transformationMatrix = [[MTMatrixCollection sharedCollection] identityMatrix_4x4]; // Reset identiry matrix.

			[self updateDisplays]; // Recalculate all projections, and update displays.
		}
	}
}


@end
