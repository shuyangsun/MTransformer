//
//  MTModelChooseViewController.m
//  MTransformer
//
//  Created by Shuyang Sun on 6/30/13.
//  Copyright (c) 2013 Shuyang Sun. All rights reserved.
//

#import "MTModelChooseViewController.h"
#import "MTThreeDModelCollection.h"
#import "GlobalMacro.h"

@interface MTModelChooseViewController ()

@end

@implementation MTModelChooseViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	NSUInteger modelInteger;
	NSNumber *num = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_NAME] objectForKey:SETTINGS_MODEL_INDEX];
	if (!num) {
		modelInteger = 0;
	} else {
		modelInteger = [num unsignedIntegerValue];
	}
	self.currentSelectedModelIndex = modelInteger;
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	NSMutableDictionary *dic = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_NAME]  mutableCopy];
	if (!dic) dic = [[NSMutableDictionary alloc] init];
	[dic setObject:[NSNumber numberWithUnsignedInteger: self.currentSelectedModelIndex] forKey:SETTINGS_MODEL_INDEX];

	[[NSUserDefaults standardUserDefaults] setObject:dic forKey:SETTINGS_DICTIONARY_NAME];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[MTThreeDModelCollection sharedCollection] totalModelCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
	for (size_t i = 0; i < (size_t)[self.modelCells count]; ++i) { // Loop through cells.
		if (((UITableViewCell *)[self.modelCells objectAtIndex:i]).tag == indexPath.row) { // Find the right cell using tag.
			cell = [self.modelCells objectAtIndex:i]; // Assign cell.
			break;
		}
	}
	
	if (self.currentSelectedModelIndex == [indexPath row]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark; // Set the accessory type to checkmark.
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.currentSelectedModelIndex = [indexPath row]; // Set the current selected path if one of them is selected.
	[tableView reloadData]; // Reload tableview's data.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
