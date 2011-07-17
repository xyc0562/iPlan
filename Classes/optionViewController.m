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
#import	"LAPIStudentTimeTableToiCalExporter.h"
#import "IVLEWebViewController.h"


#define EXPORT_TO_ICAL_SUCCESS @"Export iPlan calendar to iCal is successful!"
#define EXPORT_TO_ICAL_FAIL @"Sorry, no calendar to export!"
#define DELETE_FROM_ICAL_SUCCESS @"Delete iPLan calendar from iCal successfully"
#define DELETE_FROM_ICAL_FAIL @"error when deleting calendar"


@implementation OptionViewController

#pragma mark -
#pragma mark synthesize

@synthesize optionTableView;
@synthesize optionsList;
@synthesize switchEnabled;

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
	
	optionsList = [[NSArray alloc] initWithObjects:@"Export IVLE to iCal", @"Export to iCal", @"Delete exported events",@"Disable requirements", nil];
	
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
	
	if (row == 3) {	
		SharedAppDataObject* theDataObject = [self theAppDataObject];
		theDataObject.requirementEnabled = NO;
		CGRect frameSwitch = CGRectMake(215.0, 10.0, 94.0, 35.0);
		switchEnabled = [[UISwitch alloc] initWithFrame:frameSwitch];
		switchEnabled.on = NO;
		[switchEnabled addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];		
		cell.accessoryView = switchEnabled;
	}else if(row == 0 || row == 1){
		UIButton *exportBUtton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
		CGRect frame = CGRectMake(215.0, 10.0, 94.0, 27.0);
		exportBUtton.frame = frame;
		[exportBUtton setTitle:@"Export" forState:UIControlStateNormal];
		[exportBUtton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
		if(row == 0)
			[exportBUtton addTarget:self action:@selector(exportFromIvle:event:) forControlEvents:UIControlEventTouchUpInside];
		else 
			[exportBUtton addTarget:self action:@selector(exportFromiPlan:event:) forControlEvents:UIControlEventTouchUpInside];
		cell.accessoryView = exportBUtton;
	}else if (row == 2) {
		UIButton *exportBUtton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
		CGRect frame = CGRectMake(215.0, 10.0, 94.0, 27.0);
		exportBUtton.frame = frame;
		[exportBUtton setTitle:@"Delete" forState:UIControlStateNormal];
		[exportBUtton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
		[exportBUtton addTarget:self action:@selector(deleteFromiPlan:event:) forControlEvents:UIControlEventTouchUpInside];
		cell.accessoryView = exportBUtton;
	}else {
		//NSLog(@"No implementation yet!");
	}
    return cell;
}


- (void) exportFromIvle:(id)sender event:(id)event{
	NSInteger row = 0;
	[self tableView:optionTableView accessoryButtonTappedForRow:row];
}

- (void) exportFromiPlan:(id)sender event:(id)event{
	NSUInteger row = 1;
	NSLog(@"Need to export from iPlan to iCal");
	[self tableView:optionTableView accessoryButtonTappedForRow:row];
}

- (void) deleteFromiPlan:(id)sender event:(id)event{
	NSInteger row = 2;
	[self tableView:optionTableView accessoryButtonTappedForRow:row];
}
 
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRow:(NSInteger)row{
	//SharedAppDataObject* theDataObject = [self theAppDataObject];
	
	NSLog(@"clicked row %d", row);
	if(row == 0){
		IVLEWebViewController *ivlewebController = [[IVLEWebViewController alloc] init];
		[[self navigationController] pushViewController:ivlewebController animated:YES];
		[ivlewebController release];
	}if(row == 1) {
		NSLog(@"THE API is then called!");
		if ([[ModelLogic modelLogic] exportTimetableToiCalendar]) 
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:EXPORT_TO_ICAL_SUCCESS
														   delegate:self
												  cancelButtonTitle:@"Ok" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:EXPORT_TO_ICAL_FAIL
														   delegate:self
												  cancelButtonTitle:@"Ok" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}else if (row == 2) {
		if([[ModelLogic modelLogic] resetCalender]){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:DELETE_FROM_ICAL_SUCCESS
														   delegate:self
												  cancelButtonTitle:@"Ok" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:DELETE_FROM_ICAL_FAIL
														   delegate:self
												  cancelButtonTitle:@"Ok" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
}

- (void)switchToggled:(id)sender {
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	theDataObject.requirementEnabled = switchEnabled.on;
	//NSLog(switchEnabled.on?@"s:y":@"s:n");
}




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
   // NSLog(@"Memory Warning in OptionViewController.m!");
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	//NSLog(@"Option ‰View Unload");
	[super viewDidUnload];
}


- (void)dealloc {
	[optionTableView release];
	[optionsList release];
	[switchEnabled release];

    [super dealloc];
}


@end

