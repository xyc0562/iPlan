//
//  OptionViewController.m
//  iPlan
//
//  Created by Zhao Cong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OptionViewController.h"
#import "SharedAppDataObject.h"
#import "AppDelegateProtocol.h"
#import "ModelLogic.h"


#define EXPORT_TO_ICAL_SUCCESS @"Thanks! Export calendar to iCal is successful!"
#define EXPORT_TO_ICAL_FAIL @"Sorry, can not connect server!"


@implementation OptionViewController

#pragma mark -
#pragma mark synthesize

@synthesize optionTableView;
@synthesize optionsList;
@synthesize switchEnabled;
@synthesize exportIVLEButton;
@synthesize exportICALBUtton;

#pragma mark -
#pragma mark instance methods

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
	self.tableView.allowsSelection = NO;
	
	optionsList = [[NSArray alloc] initWithObjects:@"Export to IVLE", @"Export to iCal", @"Disable requirements", nil];
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [optionsList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *moduleListCellIdentifier = @"moduleListCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moduleListCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moduleListCellIdentifier] autorelease];
    }
	
    // Configure the cell...
    NSUInteger row = [indexPath row];
	NSString *optionName;
	
	optionName = [optionsList objectAtIndex:row];
	
	cell.textLabel.text = optionName;
	CGRect frame = CGRectMake(215.0, 10.0, 94.0, 27.0);
	
	if(row == 0){
		exportIVLEButton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
		exportIVLEButton.frame = frame;
		[exportIVLEButton setTitle:@"Export" forState:UIControlStateNormal];
		[exportIVLEButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
		[exportIVLEButton addTarget:self action:@selector(ivleButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
		cell.accessoryView = exportIVLEButton;
	}else if(row == 1){
		exportICALBUtton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
		exportICALBUtton.frame = frame;
		[exportICALBUtton setTitle:@"Export" forState:UIControlStateNormal];
		[exportICALBUtton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
		[exportICALBUtton addTarget:self action:@selector(iCalButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
		cell.accessoryView = exportICALBUtton;
	}else if (row == 2) {	
		SharedAppDataObject* theDataObject = [self theAppDataObject];
		theDataObject.requirementEnabled = NO;
		CGRect frameSwitch = CGRectMake(215.0, 10.0, 94.0, 27.0);
		switchEnabled = [[UISwitch alloc] initWithFrame:frameSwitch];
		switchEnabled.on = NO;
		[switchEnabled addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];		
		cell.accessoryView = switchEnabled;
	}
	
    return cell;
}

- (void) ivleButtonTapped:(id)sender event:(id)event{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:optionTableView];
	NSIndexPath *indexPath = [optionTableView indexPathForRowAtPoint:currentTouchPosition];
	if(indexPath != nil){
		[self tableView:optionTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
	}
}


- (void) iCalButtonTapped:(id)sender event:(id)event{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:optionTableView];
	NSIndexPath *indexPath = [optionTableView indexPathForRowAtPoint:currentTouchPosition];
	if(indexPath != nil){
		[self tableView:optionTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = indexPath.row;
	//SharedAppDataObject* theDataObject = [self theAppDataObject];
	
	NSLog(@"clicked row %d", row);
	if(row == 0){
		//Lapi issue
		
	}else if (row == 1) {
		if ([[ModelLogic modelLogic]exportTimetableToiCalendar]) 
		{
			//success
		}else 
		{
			//fail
		}

		
		
	}
}

- (void)switchToggled:(id)sender {
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	theDataObject.requirementEnabled = switchEnabled.on;
	//NSLog(switchEnabled.on?@"s:y":@"s:n");
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    NSLog(@"Memory Warning in OptionViewController.m!");
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.optionTableView = nil;
	self.optionsList = nil;
	NSLog(@"Option ‰View Unload");
	[super viewDidUnload];
}


- (void)dealloc {
	[optionTableView release];
	[optionsList release];
	[switchEnabled release];
	[exportIVLEButton release];
	[exportICALBUtton release];
    [super dealloc];
}


@end

