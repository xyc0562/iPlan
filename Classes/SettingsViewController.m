//
//  SettingsViewController.m
//  iPlan
//
//  Created by Zhao Cong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "HelpViewController.h"
#import "OptionViewController.h"

#import "AppDelegateProtocol.h"
#import "SharedAppDataObject.h"

@implementation SettingsViewController


#define OPTION_NAME @"Option"
#define HELP_NAME @"Help"
#define ABOUT_NAME @"About"

@synthesize settingsTableView;
@synthesize settingsList;



#pragma mark -
#pragma mark instance methods

- (SharedAppDataObject*) theAppDataObject
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	//load info with dummy array: array
	NSArray *array = [[NSArray alloc] initWithObjects:OPTION_NAME, HELP_NAME, ABOUT_NAME, nil];
	self.settingsList = array;
	[array release];
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (id)initWithTabBar{
	if (self = [super initWithNibName:@"SettingsViewController" bundle:nil]){
		self.title = @"Settings";
		self.tabBarItem.image = [UIImage imageNamed:@"gear.png"];
		self.navigationController.title = @"nav title";
	}
	return self;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.settingsList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SettingsTableIdentifier = @"SettingsTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingsTableIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SettingsTableIdentifier] autorelease];
    }

    // Configure the cell...
    NSUInteger row = [indexPath row];
	cell.textLabel.text = [settingsList objectAtIndex:row];
	
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
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
	NSUInteger row_number = [indexPath row];
	UIViewController *viewController;
	if(row_number == 0){
		viewController = [[OptionViewController alloc] initWithNibName:@"OptionViewController" bundle:nil];
	}else if (row_number == 1) {
		viewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
	}else if (row_number == 2){
		viewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
	}else{
		printf("Error");
	}
	
	//set shared object
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	theDataObject.settingsIdentity = [[[NSString alloc] initWithFormat:@"%d", row_number] autorelease];
	
	[[self navigationController] pushViewController:viewController animated:YES];
	[viewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    NSLog(@"Memory Warning!");
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.settingsTableView = nil;
	self.settingsList = nil;
	[super viewDidLoad];
}


- (void)dealloc {
	[settingsTableView release];
	[settingsList release];
    [super dealloc];
}


@end

