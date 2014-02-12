//
//  MTViewController.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/19/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTThreeDModel;
@class MTGraphDisplayView;

@interface MTViewController : UIViewController <UIAlertViewDelegate> // As alert view's delegate

/**
 The property holding the current 3D model.
 */
@property (strong, nonatomic) MTThreeDModel *currentModel;

/**
 The botton display.
 */
@property (weak, nonatomic) IBOutlet MTGraphDisplayView *bottomDisplay;

/**
 The upper left display.
 */
@property (weak, nonatomic) IBOutlet MTGraphDisplayView *upperLeftDisplay;

/**
 The upper right display.
 */
@property (weak, nonatomic) IBOutlet MTGraphDisplayView *upperRightDisplay;

@property (weak, nonatomic) IBOutlet UITextView *pointsInfoTextView;

/**
 Boolean telling if should scale on single axis.
 */
@property (nonatomic) BOOL scaleOnSingleAxis;

/**
 The reset button.
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetButton;

@property (nonatomic) NSUInteger currentModelIndex;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *axisLabels;

/**
 If the reset button is tapped:
 */
- (IBAction)resetTapped:(UIBarButtonItem *)sender;

//************************ Gesture Handler ***************************//

-(void)pinchOnBottomDisplay: (UIPinchGestureRecognizer *)gestureRecognizer;
-(void)pinchOnUpperLeftDisplay: (UIPinchGestureRecognizer *)gestureRecognizer;
-(void)pinchOnUpperRightDisplay: (UIPinchGestureRecognizer *)gestureRecognizer;

-(void)panOnBottomDisplay: (UIPanGestureRecognizer *)gestureRecognizer;
-(void)panOnUpperLeftDisplay: (UIPanGestureRecognizer *)gestureRecognizer;
-(void)panOnUpperRightDisplay: (UIPanGestureRecognizer *)gestureRecognizer;

-(void)rotateOnBottomDisplay: (UIRotationGestureRecognizer *)gestureRecognizer;
-(void)rotateOnUpperLeftDisplay: (UIRotationGestureRecognizer *)gestureRecognizer;
-(void)rotateOnUpperRightDisplay: (UIRotationGestureRecognizer *)gestureRecognizer;

//************************ Gesture Handler ***************************//

@end
