//
//  MTSettingsTableViewController.h
//  MTransformer
//
//  Created by Shuyang Sun on 6/28/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTViewController;

@interface MTSettingsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableViewCell *modelCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *themeCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *axisLabelCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *scaleSingleAxisCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *shakeToResetCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *pointsInfoCell;

@property (weak, nonatomic) IBOutlet UISwitch *axisLabelSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *scaleSingleAxisSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *ShakeToResetSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *PointsInformationSwitch;

@property (strong, nonatomic) MTViewController *displayViewControler;

/**
 Convert settings in section 2 to property list.
 */
-(NSArray *)settinsAsPropertyList;

@end
