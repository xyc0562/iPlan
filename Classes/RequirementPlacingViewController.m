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
#define TITLE @"Which time do you want to have classes?"
#define SWITCH_YES @"YES"
#define SWITCH_NO @"NO"

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


- (void)cancelClicked:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
	//TODO: call model logic and go to calendar view
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.allowsSelection = NO;
	self.title = @"Requirements";
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	
	if ([theDataObject.requirements count]==0){
		// NSLog(@"123");
		for (int i = 0; i < 8; i ++ ){
			if (i == 0 || i == 6 || i == 7) {
				NSMutableArray *element = [[NSMutableArray alloc] initWithObjects:SWITCH_NO,SWITCH_NO,nil];
				[theDataObject.requirements addObject:element];
				[element release];
			}else {
				NSMutableArray *element = [[NSMutableArray alloc] initWithObjects:SWITCH_YES,SWITCH_YES,nil];
				[theDataObject.requirements addObject:element];
				[element release];
			}
//			NSLog([[theDataObject.requirements objectAtIndex:i] objectAtIndex:0]);
//			NSLog([[theDataObject.requirements objectAtIndex:i] objectAtIndex:1]);
		}
	}//else {
//		NSLog(@"456");
//		for (int i = 1; i < 6; i++){
//			NSMutableArray *element = [theDataObject.requirements objectAtIndex:i];
//			for (int j = 0; j< [element count]; j++){
//				NSLog([element objectAtIndex:j]);
//			}
//		}
//	}

	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)] autorelease];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return TITLE;
		default:
			return @"";
	}
}

- (void)switchToggled:(id)sender {
	UISwitch *switchEnabled = (UISwitch*)sender;
	NSInteger tag = [switchEnabled tag]+2;
	NSString *boool;
	if (switchEnabled.on == YES){
		boool = SWITCH_YES;
	}else {
		boool = SWITCH_NO;
	}

	SharedAppDataObject* theDataObject = [self theAppDataObject];
	[[theDataObject.requirements objectAtIndex:tag/2] replaceObjectAtIndex:tag%2 withObject:boool]; 
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
	
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	NSString *boool = [[theDataObject.requirements objectAtIndex:(indexPath.row+2)/2] objectAtIndex:(indexPath.row+2)%2];
	if ([boool isEqual:SWITCH_YES]){
		switchEnabled.on = YES;
	}else {
		switchEnabled.on = NO;
	}

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

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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

