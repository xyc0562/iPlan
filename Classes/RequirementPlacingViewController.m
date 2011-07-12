//
//  RequirementPlacingViewController.m
//  iPlan
//
//  Created by HQ on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RequirementPlacingViewController.h"
#import "SharedAppDataObject.h"
#import "AppDelegateProtocol.h"

#define	MORNING @"Morning"
#define AFTERNOON @"Afternoon"
#define MONDAY @"Monday"
#define TUESDAY @"Tuesday"
#define WEDNESDAY @"Wednesday"
#define THURSDAY @"Thursday"
#define FRIDAY @"Friday"

@implementation RequirementPlacingViewController


#pragma mark -
#pragma mark instance method

- (SharedAppDataObject*) theAppDataObject{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 10;
}

- (void)switchToggled:(id)sender {
	UISwitch *switchEnabled = (UISwitch*)sender;
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	//theDataObject.requirements = 
	NSLog(@"tag: %i",[switchEnabled tag]);
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	CGRect frameSwitch = CGRectMake(215.0, 10.0, 94.0, 27.0);
	UISwitch *switchEnabled = [[UISwitch alloc] initWithFrame:frameSwitch];
	switchEnabled.tag = indexPath.row;
	[switchEnabled addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
	cell.accessoryView = switchEnabled;
	[switchEnabled release];
	
	switch (indexPath.row){
		case 0:
			cell.textLabel.text= MONDAY;
			cell.detailTextLabel.text = MORNING;
			break;
		case 1:
			cell.textLabel.text= MONDAY;
			cell.detailTextLabel.text = AFTERNOON;
			break;
		case 2:
			cell.textLabel.text= TUESDAY;
			cell.detailTextLabel.text = MORNING;
			break;
		case 3:
			cell.textLabel.text= TUESDAY;
			cell.detailTextLabel.text = AFTERNOON;
			break;
		case 4:
			cell.textLabel.text= WEDNESDAY;
			cell.detailTextLabel.text = MORNING;
			break;
		case 5:
			cell.textLabel.text= WEDNESDAY;
			cell.detailTextLabel.text = AFTERNOON;
			break;
		case 6:
			cell.textLabel.text= THURSDAY;
			cell.detailTextLabel.text = MORNING;
			break;
		case 7:
			cell.textLabel.text= THURSDAY;
			cell.detailTextLabel.text = AFTERNOON;
			break;
		case 8:
			cell.textLabel.text= FRIDAY;
			cell.detailTextLabel.text = MORNING;
			break;
		case 9:
			cell.textLabel.text= FRIDAY;
			cell.detailTextLabel.text = AFTERNOON;
			break;
	}
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

