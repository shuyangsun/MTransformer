//
//  MTModelChooseViewController.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/30/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTModelChooseViewController : UITableViewController

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *modelCells;

@property (nonatomic) NSUInteger currentSelectedModelIndex;

@end
