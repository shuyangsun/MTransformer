//
//  MTViewController.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/19/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTViewController.h"

#import "MTMatrix.h"
#import "MTVector.h"
#import "MatrixCollection.h"

@interface MTViewController ()

@end

@implementation MTViewController

-(void)setup
{
	// Initialization code here...
	MTMatrix *matrix = [[MatrixCollection sharedCollection] translateTransformationMatrixWith_xValue:2
																						  and_yValue:3
																						  and_zValue:4];

	NSMutableString *matrixDescription = [NSMutableString string];
	for (size_t i = 0; i < [matrix.vectors[0] entryCount]; ++i) {
		for (size_t j = 0; j < [matrix.vectors count]; ++j) {
			[matrixDescription appendString:[NSString stringWithFormat:@"%.1f ", [(NSNumber*)matrix.vectors[j][i] floatValue]]];
			printf("%.1f ", [(NSNumber*)matrix.vectors[j][i] floatValue]);
		}
		[matrixDescription appendString:@"\n"];
		putchar('\n');
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

@end
