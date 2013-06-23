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
#import "MTEntry.h"
#import "MatrixCollection.h"

@interface MTViewController ()

@end

@implementation MTViewController

-(void)setup
{
	// Initialization code here...
	float arr[2][2] = {1,2,
					   3,4};
	MTMatrix *matrix = [[MTMatrix alloc] initWithFloatValues:(float **)arr];

	for (size_t i = 0; i < [matrix.vectors[0] entryCount]; ++i) {
		for (size_t j = 0; j < [matrix.vectors count]; ++j) {
			printf("%.1f ", [(MTEntry*)matrix.vectors[j][i] floatValue]);
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

@end
