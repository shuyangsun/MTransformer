//
//  MTSettingsTableViewController.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/28/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTSettingsTableViewController.h"
#import "GlobalMacro.h"
#import "MTViewController.h"

@interface MTSettingsTableViewController ()

-(void)synchronizeUserDefaults;
-(void)getUserDefaults;

@end

@implementation MTSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		[self setup];
    }
    return self;
}

-(void)setup
{
	// Initialization code here...
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return section == 0 ? 2:4;
}

-(void)viewDidLoad
{
	[super viewDidLoad];

	// Set the selection styles to NONE:
	self.axisLabelCell.selectionStyle = UITableViewCellSelectionStyleNone;
	self.scaleSingleAxisCell.selectionStyle = UITableViewCellSelectionStyleNone;
	self.shakeToResetCell.selectionStyle = UITableViewCellSelectionStyleNone;
	self.pointsInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self getUserDefaults]; // Get the user defaults animation.

	// Set the buttons:
	
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self synchronizeUserDefaults]; // Write the user defaults.
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) { // If it's an iPad:
		NSDictionary *defaults = [[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_NAME];
		BOOL hide = YES;
		if (defaults) {
			hide = [[defaults objectForKey:SETTINGS_AXIS_LABEL] boolValue];
		}
		for (size_t i = 0; i < (size_t)[self.displayViewControler.axisLabels count]; ++i) {
			((UILabel *)(self.displayViewControler.axisLabels[i])).hidden = hide;
		} // Hide (or not) axis labels.
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

	switch (indexPath.section) {
		case 0: // Section
			switch (indexPath.row) {
				case 0: // Row
					cell = self.modelCell;
					break;
				case 1: // Row
					cell = self.themeCell;
					break;
				default:
					cell = [[UITableViewCell alloc] init];
					break;
			}
			break;
		case 1: // Section
			switch (indexPath.row) {
				case 0: // Row
					cell = self.axisLabelCell;
					break;
				case 1: // Row
					cell = self.scaleSingleAxisCell;
					break;
				case 2: // Row
					cell = self.shakeToResetCell;
					break;
				case 3: // Row
					cell = self.pointsInfoCell;
					break;
				default:
					cell = [[UITableViewCell alloc] init];
					break;
			}
			break;
		default:
			cell = [[UITableViewCell alloc] init];
			break;
	}
    
    // Configure the cell...
    
    return cell;
}

// Get the property list.
-(NSArray *)settinsAsPropertyList
{
	NSMutableArray *res = [[NSMutableArray alloc] init];
	[res addObject:[NSNumber numberWithBool:self.axisLabelSwitch.on]];
	[res addObject:[NSNumber numberWithBool:self.scaleSingleAxisSwitch.on]];
	[res addObject:[NSNumber numberWithBool:self.ShakeToResetSwitch.on]];
	[res addObject:[NSNumber numberWithBool:self.PointsInformationSwitch.on]];
	return res;
}

-(void)synchronizeUserDefaults
{
	// Set the default settings:
	NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_NAME] mutableCopy];
	if (!settings) settings = [[NSMutableDictionary alloc] init];
	[settings setObject:[NSNumber numberWithBool:self.axisLabelSwitch.on] forKey:SETTINGS_AXIS_LABEL];
	[settings setObject:[NSNumber numberWithBool:self.scaleSingleAxisSwitch.on] forKey:SETTINGS_SCALE_SINGLE_AXIS];
	[settings setObject:[NSNumber numberWithBool:self.ShakeToResetSwitch.on] forKey:SETTINGS_SHAKE_TO_RESET];
	[settings setObject:[NSNumber numberWithBool:self.PointsInformationSwitch.on] forKey:SETTINGS_POINTS_INFORMATION];

	[[NSUserDefaults standardUserDefaults] setObject:settings forKey:SETTINGS_DICTIONARY_NAME];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)getUserDefaults
{
	NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_NAME] mutableCopy];
	if (settings) { // If there is a settings:
		self.axisLabelSwitch.on = [[settings objectForKey:SETTINGS_AXIS_LABEL] boolValue];
		self.scaleSingleAxisSwitch.on = [[settings objectForKey:SETTINGS_SCALE_SINGLE_AXIS] boolValue];
		self.ShakeToResetSwitch.on = [[settings objectForKey:SETTINGS_SHAKE_TO_RESET] boolValue];
		self.PointsInformationSwitch.on= [[settings objectForKey:SETTINGS_POINTS_INFORMATION] boolValue];
	} else { // If there is no settings, set all to NO.
		self.axisLabelSwitch.on = NO;
		self.scaleSingleAxisSwitch.on = NO;
		self.ShakeToResetSwitch.on = NO;
		self.PointsInformationSwitch.on = NO;
	}
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
@end
