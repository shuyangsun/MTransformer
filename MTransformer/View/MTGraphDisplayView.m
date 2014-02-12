//
//  MTGraphDisplayView.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/25/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTGraphDisplayView.h"

#import "MTPoint.h"

@interface MTGraphDisplayView() // Class extention.

/**
 Helper method to draw the matrix.
 */
-(void)drawLines;

/**
 Helper method to convert this point to the point in this view.
 @param point The point to convert.
 */
-(CGPoint)convertedPoint: (CGPoint) point;

@end

@implementation MTGraphDisplayView

//************************ View Setup ***************************//

-(void) setup
{
	// Initialization code here...
	[self setBackgroundColor:[UIColor whiteColor]]; // Set the background color as clear color.
	self.opaque = NO; // Set the opaque to NO to get portantial transparency.
	self.scalar = 1; // Set the scalar to 1.
}

-(void)awakeFromNib
{
	[self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setup];
    }
    return self;
}

//************************ View Setup ***************************//

- (void)drawRect:(CGRect)rect
{
	//****************** Draw the Grids ******************//
	
	//// General Declarations
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();

	//// Color Declarations
	UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
	UIColor* strokeColor = [UIColor colorWithRed: 0.114 green: 0.706 blue: 1 alpha: 0.545];
	UIColor* shadowColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
	UIColor* color3 = [UIColor colorWithRed: 0.114 green: 0.705 blue: 1 alpha: 0];

	//// Gradient Declarations
	NSArray* gradient2Colors = [NSArray arrayWithObjects:
								(id)fillColor.CGColor,
								(id)[UIColor colorWithRed: 0.557 green: 0.852 blue: 1 alpha: 0.5].CGColor,
								(id)color3.CGColor, nil];
	CGFloat gradient2Locations[] = {0, 0.9, 1};
	CGGradientRef gradient2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient2Colors, gradient2Locations);

	//// Shadow Declarations
	UIColor* shadow = shadowColor2;
	CGSize shadowOffset = CGSizeMake(0.1, -0.1);
	CGFloat shadowBlurRadius = 5;

	//// Rounded Rectangle Drawing
	UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: self.bounds cornerRadius: 10];
	CGContextSaveGState(context);
	[roundedRectanglePath addClip];
	CGContextDrawRadialGradient(context, gradient2,
								CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2), 20,
								CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2), sqrtf(pow(MAX(self.bounds.size.height/2, self.bounds.size.width/2), 2)*2), // Gradiant
								kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	roundedRectanglePath.lineWidth = 1;
	[roundedRectanglePath stroke];
	CGContextRestoreGState(context);

	//// Bezier 2 Drawing
	UIBezierPath* crossHair = [UIBezierPath bezierPath];
	[crossHair moveToPoint: CGPointMake(self.bounds.size.width/2, 0)];
	[crossHair addLineToPoint: CGPointMake(self.bounds.size.width/2, self.bounds.size.height)];
	[crossHair moveToPoint:CGPointMake(0, self.bounds.size.height/2)];
	[crossHair addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height/2)];
	UIColor *color = [UIColor lightGrayColor];
	[color setStroke];
	crossHair.lineWidth = 1;
	CGFloat bezier2Pattern[] = {3, 3, 3, 3};
	[crossHair setLineDash: bezier2Pattern count: 4 phase: 0];
	[crossHair stroke];
	[crossHair closePath];

	//// Cleanup
	CGGradientRelease(gradient2);
	CGColorSpaceRelease(colorSpace);


	//****************** Draw the Grids ******************//

	//****************** Draw the Matrix ******************//
	[self drawLines]; // Call draw lines method.
	//****************** Draw the Matrix ******************//
}

// Draw the 2D matrix:
-(void)drawLines
{
	if (self.matrix) { // If there is a matrix to draw:
		MTMatrix *matrix = [self.matrix deepCopy]; // Make a deep copy of it's matrix. (We don't want to change connection data in it while we are drawing.)
		UIBezierPath *pen = [UIBezierPath bezierPath]; // Get a bezierpath.
		for (size_t i = 0; i < (size_t)[matrix.vectors count]; ++i) { // Loop through all the 2D vectors in this matrix.
			MTPoint *currentPoint = matrix.vectors[i]; // get the current point.
			NSArray *adjacentPoints = [currentPoint pointsConnectingToAsArray]; // Get the array version of points connected to.
			for (size_t j = 0; j < (size_t)[adjacentPoints count]; ++j) { // Iterate through adjacent points.
				[pen moveToPoint: [self convertedPoint:[currentPoint get2DPoint]]]; // Move to current point.
				[pen addLineToPoint: [self convertedPoint:[adjacentPoints[j] get2DPoint]]]; // Draw the line.
				[currentPoint disconnectFromPoint:adjacentPoints[j]]; // Disconnect this point.
			}
		}

		pen.lineWidth = 1; // Set line width.
		[[UIColor redColor] setStroke]; // Set the stroke color.

		// Shadow //
		
		//// General Declarations
		CGContextRef context = UIGraphicsGetCurrentContext();

		//// Color Declarations
		UIColor* shadowColor2 = [UIColor darkGrayColor];

		//// Shadow Declarations
		UIColor* shadow = shadowColor2;
		CGSize shadowOffset = CGSizeMake(0.1, -0.1);
		CGFloat shadowBlurRadius = 1.5;
		
		CGContextSaveGState(context);
		CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
		// Shadow //

		[pen stroke]; // Stroke the path.
		CGContextRestoreGState(context);
		[pen closePath]; // Close this bezier path.
		matrix = nil; // Release memory.
	}
}

// Overriding setter method for points.
-(void)setMatrix:(MTMatrix *)matrix
{
	_matrix = matrix; // Set the points property.
}

//  Helper method to convert this point to the point in this view.
-(CGPoint)convertedPoint: (CGPoint) point
{
	float originX = self.bounds.size.width/2; // Get the half of width.
	float originY = self.bounds.size.height/2; // Get the half of height
	originX += point.x * self.scalar; // New x value.
	originY -= point.y * self.scalar; // New y value.
	return CGPointMake(originX, originY);
}

@end
