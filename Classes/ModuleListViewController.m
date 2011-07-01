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

- (SharedAppDataObject*) theAppDataObject{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}


#pragma mark -
#pragma mark View lifecycle

-(void) cartButtonClicked:(id)sender {
	NSLog(@"haha");
}

- (void)viewDidLoad {
	[super viewDidLoad];
	NSArray *array = [[NSArray alloc] initWithObjects:@"CH1101E",@"CS1102",nil];
	self.moduleList = array;
	[array release];
	
	// initialize the copy array
	copyModuleList = [[NSMutableArray alloc] init];
	
	//Add the search bar
	self.tableView.tableHeaderView = searchBar;
	//self.navigationItem.titleView = searchBar;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	
	searching = NO;
	letUserSelectRow = YES;
	
	// the shopping cart button
	UIImage *cartImage = [UIImage imageNamed:@"shopping_cart.png"];
	UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[aButton setImage:cartImage forState:UIControlStateNormal];
	aButton.frame = CGRectMake(0.0, 0.0, cartImage.size.width, cartImage.size.height);
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:aButton];
	[aButton addTarget:self action:@selector(cartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = item;
	[item release];
	
	// insert buttons
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add to Basket" style:UIBarButtonItemStyleBordered target:self action:@selector(Edit:)];
	[self.navigationItem setRightBarButtonItem:addButton];
	[addButton release];
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
		//NSLog(@"a");
		theDataObject.moduleCode = [copyModuleList objectAtIndex:row_number];
	}else {
		//set shared object
		//NSLog(@"b");
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

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	//return UITableViewCellAccessoryDetailDisclosureButton;
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}


#pragma mark -
#pragma mark Search Bar 

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = NO;
	
	// add the cancel button for search
	//[theSearchBar setShowsCancelButton:YES];
	//NSLog(@"search begin");
}

-(void)searchBarCancelButtonClicked:(UISearchBar *) theSearchBar{
	[theSearchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	//NSLog(@"text did change begin");
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
	//NSLog(@"text did change end");
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	[self searchTableView];
}

- (void) searchTableView {
	
	NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [NSArray arrayWithArray:moduleList];
	
	for (NSString *sTemp in searchArray){
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		if (titleResultsRange.length > 0)
			[copyModuleList addObject:sTemp];
	}
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
#pragma mark Add modules to the basket

- (IBAction)AddButtonAction:(id)sender{
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	UIButton *button = (UIButton*) sender;
	[theDataObject.basket addObject:button.titleLabel];
	[moduleListTableView reloadData];
}

- (IBAction)DeleteButtonAction:(id)sender{
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	[theDataObject.basket removeLastObject];
	[moduleListTableView reloadData];
}

- (IBAction) Edit:(id)sender{
	if(self.editing){
		[super setEditing:NO animated:NO]; 
		[moduleListTableView setEditing:NO animated:NO];
		[moduleListTableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}else{
		[super setEditing:YES animated:YES]; 
		[moduleListTableView setEditing:YES animated:YES];
		[moduleListTableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

	SharedAppDataObject* theDataObject = [self theAppDataObject];
	UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	NSString *addedModule = cell.textLabel.text;
	if ([theDataObject.basket containsObject:addedModule]){
		return UITableViewCellEditingStyleNone;
	}else {
		return UITableViewCellEditingStyleInsert;
	}

}


- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];

	if (editingStyle == UITableViewCellEditingStyleInsert) {
		SharedAppDataObject* theDataObject = [self theAppDataObject];
		
		// only add the same module once
		NSString *addedModule = cell.textLabel.text;
		if (![theDataObject.basket containsObject:addedModule]){
			[theDataObject.basket insertObject:addedModule atIndex:[theDataObject.basket count]];
			cell.editing = NO;
			[moduleListTableView reloadData];
		}
		NSLog(@"haha: %i %@", [theDataObject.basket count],cell.textLabel.text); 
    }
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    //NSLog(@"Memory Warning in ModuleListViewController.m!");
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

