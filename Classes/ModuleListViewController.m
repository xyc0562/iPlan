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
	
	// initialize the copy array
	copyModuleList = [[NSMutableArray alloc] init];
	
	//Add the search bar
	self.tableView.tableHeaderView = searchBar;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	
	searching = NO;
	letUserSelectRow = YES;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if (searching){
		return 1;
	}else {
		return 1;
	}

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (searching){
		return [copyModuleList count];
	}else {
		return [self.moduleList count];
	}
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
	
	if (searching){
		cell.textLabel.text = [copyModuleList objectAtIndex:row];
	}else{
		cell.textLabel.text = [moduleList objectAtIndex:row];
	}

	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row_number = [indexPath row];
	
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	if (searching){
		NSLog(@"a");
		theDataObject.moduleCode = [copyModuleList objectAtIndex:row_number];
	}else {
		//set shared object
		NSLog(@"b");
		theDataObject.moduleCode = [moduleList objectAtIndex:row_number];
	}
	
	UIViewController *viewController;
	viewController = [[ModuleInfoViewController alloc] initWithNibName:@"ModuleInfoViewController" bundle:nil];
	
	[[self navigationController] pushViewController:viewController animated:YES];
	[viewController release];
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow){
		return indexPath;
	}else{
		return nil;
	}
}
//
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
//	//return UITableViewCellAccessoryDetailDisclosureButton;
//	return UITableViewCellAccessoryDisclosureIndicator;
//}
//
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
//	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
//}


#pragma mark -
#pragma mark Search Bar 

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = NO;
	
	//Add the done button.
	UIBarButtonItem *item = [[UIBarButtonItem alloc]
							 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
							 target:self action:@selector(doneSearching_Clicked:)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];
	NSLog(@"search begin");
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	NSLog(@"text did change begin");
	//Remove all objects first.
	[copyModuleList removeAllObjects];
	
	if([searchText length] > 0) {
		searching = YES;
		letUserSelectRow = YES;
		self.tableView.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = NO;
	}
	[self.tableView reloadData];
	NSLog(@"text did change end");
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	[self searchTableView];
}

- (void) searchTableView {
	
	NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
//	for (NSDictionary *dictionary in moduleList){
//		NSArray *array = [dictionary objectForKey:@"Countries"];
//		[searchArray addObjectsFromArray:array];
//	}
//	
	searchArray = [NSArray arrayWithArray:moduleList];
	
	for (NSString *sTemp in searchArray)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0)
			[copyModuleList addObject:sTemp];
	}
	
	//[searchArray release];
	searchArray = nil;
}

- (void) doneSearching_Clicked:(id)sender {
	
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	self.tableView.scrollEnabled = YES;
	
	[self.tableView reloadData];
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

