//
//  ModuleListViewController.m
//  iPlan
//
//  Created by Zhao Cong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModuleListViewController.h"
#import	"ModuleInfoViewController.h"
#import "SharedAppDataObject.h"
#import "AppDelegateProtocol.h"


@implementation ModuleListViewController


#pragma mark -
#pragma mark synthesize
@synthesize moduleListTableView;
@synthesize moduleList;

#pragma mark -
#pragma mark instance method

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
	[super viewDidLoad];
	NSArray *array = [[NSArray alloc] initWithObjects:@"CH1101E",@"CS1102",nil];
	self.moduleList = array;
	[array release];
	

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (id)initWithTabBar{
	if (self = [super initWithNibName:@"ModuleListViewController" bundle:nil]){
		self.title = @"Builder";
		self.tabBarItem.image = [UIImage imageNamed:@"pencil.png"];
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
    return [self.moduleList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ModuleListTableIdentifier = @"ModuleListTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ModuleListTableIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ModuleListTableIdentifier] autorelease];
    }
	
    // Configure the cell...
    NSUInteger row = [indexPath row];
	cell.textLabel.text = [moduleList objectAtIndex:row];
	
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row_number = [indexPath row];
	UIViewController *viewController;
	viewController = [[ModuleInfoViewController alloc] initWithNibName:@"ModuleInfoViewController" bundle:nil];
	
	//set shared object
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	theDataObject.moduleCode = [moduleList objectAtIndex:row_number];
	
	[[self navigationController] pushViewController:viewController animated:YES];
	[viewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    NSLog(@"Memory Warning in ModuleListViewController.m!");
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.moduleListTableView =  nil;
	self.moduleList = nil;
	[super viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[moduleListTableView release];
	[moduleList release];
    [super dealloc];
}


@end

