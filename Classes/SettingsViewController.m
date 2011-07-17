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
#import "LoadViewController.h"
#import "ListViewController.h"

#import "AppDelegateProtocol.h"
#import "SharedAppDataObject.h"

@implementation SettingsViewController


#define OPTION_NAME @"Option"
#define HELP_NAME @"Help"
#define ABOUT_NAME @"About"
#define LOAD @"Load Other TimeTables"
#define UIVIEW_LIST @"List View of Current Calendar"
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
	NSArray *array = [[NSArray alloc] initWithObjects:OPTION_NAME, HELP_NAME, ABOUT_NAME, LOAD,UIVIEW_LIST,nil];
	self.settingsList = array;
	[array release];
    [super viewDidLoad];
}



- (id)initWithTabBar{
	if (self = [super initWithNibName:@"SettingsViewController" bundle:nil]){
		self.title = @"Settings";
		self.tabBarItem.image = [UIImage imageNamed:@"gear.png"];
		self.navigationController.title = @"nav title";
	}
	return self;
}


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
	}else if(row_number == 3){
		viewController = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
	}else if(row_number ==4){
		viewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
	}else {
		//printf("Error");
	}
	
	//set shared object
	//NSLog(@"Hello World! %d", row_number);
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	theDataObject.settingsIdentity = [[[NSString alloc] initWithFormat:@"%d", row_number] autorelease];
	//NSLog(@"Hello World! %d", row_number);
	[[self navigationController] pushViewController:viewController animated:YES];
	[viewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
   // NSLog(@"Memory Warning!");
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	//self.settingsTableView = nil;
	//self.settingsList = nil;
	[super viewDidLoad];
}


- (void)dealloc {
	[settingsTableView release];
	[settingsList release];
    [super dealloc];
}


@end

