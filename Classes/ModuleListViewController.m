//
//  ModuleListViewController.m
//  iPlan
//
//  Created by Zhao Cong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModuleListViewController.h"
#import	"ModuleInfoViewController.h"
#import "BasketTableViewController.h"
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
	BasketTableViewController *basketController = [[BasketTableViewController alloc] initWithStyle:UITableViewStylePlain];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:basketController];
	[basketController release];
    [[self navigationController] presentModalViewController:navController animated:YES];
    [navController release];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	NSArray *array = [[NSArray alloc] initWithObjects:@"CH1101E",@"CS1102",nil];
	self.moduleList = array;
	[array release];
	
	// initialize the copy array
	copyModuleList = [[NSMutableArray alloc] init];
	pathForAlert = [[NSIndexPath alloc]	init];
	
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
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Continue" style:UIBarButtonItemStyleBordered target:self action:@selector(forwardToRequirement:)];
	[self.navigationItem setRightBarButtonItem:addButton];
	[addButton release];
}


- (void)viewWillAppear:(BOOL)animated{
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	
	for (NSString *key in theDataObject.removedCells) {
		NSIndexPath *path = [theDataObject.removedCells objectForKey:key];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
		UIButton *button = (UIButton *)cell.accessoryView;
		
		UIImage *newImage = [UIImage imageNamed:@"unchecked.png"];
		[button setBackgroundImage:newImage forState:UIControlStateNormal];
	}
	[theDataObject.removedCells removeAllObjects];
	[moduleListTableView reloadData];
}


- (id)initWithTabBar{
	if (self = [super initWithNibName:@"ModuleListViewController" bundle:nil]){
		self.title = @"Modules";
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
    
	static NSString *moduleListCellIdentifier = @"moduleListCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moduleListCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moduleListCellIdentifier] autorelease];
    }
	
    // Configure the cell...
	SharedAppDataObject* theDataObject = [self theAppDataObject];
    NSUInteger row = [indexPath row];
	NSString *addedModule;
	
	if (searching){
		addedModule = [copyModuleList objectAtIndex:row];
	}else{
		addedModule = [moduleList objectAtIndex:row];
	}
	
	cell.textLabel.text = addedModule;
	
	BOOL checked = [theDataObject.basket containsObject:addedModule];

	UIImage *image = (checked) ? nil : [UIImage imageNamed:@"unchecked.png"];
	
	UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
	CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
	addButton.frame = frame;

	[addButton setBackgroundImage:image forState:UIControlStateNormal];
	
	if(image == nil){
		[addButton addTarget:self action:@selector(nullButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
	}else{
		[addButton addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
	}
	addButton.backgroundColor = [UIColor clearColor];
	
	cell.accessoryView = addButton;
	
    return cell;
}

- (void) nullButtonTapped:(id)sender event:(id)event{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
	if(indexPath != nil){
		[self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
	}
}


- (void) checkButtonTapped:(id)sender event:(id)event{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
	if(indexPath != nil){
		[self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
	}
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	NSString *addedModule = [moduleList objectAtIndex:indexPath.row];
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	
	
	//Can add module name duplicate checking here
	BOOL checked = [theDataObject.basket containsObject:addedModule];
	
	
	
	if(!checked){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Confirm to select this module?"
											  delegate:self
											  cancelButtonTitle:@"Cancel" 
											  otherButtonTitles:@"OK",nil];
							  
		[alert show];
		[alert release];
		
		NSLog(@"test 2");
		
		pathForAlert = indexPath;
	}else {
		[self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
	}
	
	[addedModule release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
 	
	NSString *addedModule = [moduleList objectAtIndex:pathForAlert.row];
	SharedAppDataObject* theDataObject = [self theAppDataObject];

	if ([button isEqual:@"OK"]) {
		[theDataObject.basket addObject:addedModule];
		
		
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:pathForAlert];
		[theDataObject.moduleCells setObject:pathForAlert forKey:addedModule];
		
		UIButton *button = (UIButton *)cell.accessoryView;

		UIImage *newImage = nil;
		
		NSLog(@"test 3");
		
		[button setBackgroundImage:newImage forState:UIControlStateNormal];
	}
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row_number = [indexPath row];
	
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	if (searching){
		theDataObject.moduleCode = [copyModuleList objectAtIndex:row_number];
	}else {
		//set shared object
		theDataObject.moduleCode = [moduleList objectAtIndex:row_number];
	}
	
	UIViewController *viewController;
	viewController = [[ModuleInfoViewController alloc] initWithNibName:@"ModuleInfoViewController" bundle:nil];
	
	[[self navigationController] pushViewController:viewController animated:YES];
	[viewController release];
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView resignFirstResponder];
	if(letUserSelectRow){
		return indexPath;
	}else{
		return nil;
	}
}


#pragma mark -
#pragma mark Search Bar 

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = NO;
	
	// add the cancel button for search
	[theSearchBar setShowsCancelButton:YES];
	//NSLog(@"search begin");
}

-(void)searchBarCancelButtonClicked:(UISearchBar *) theSearchBar{
	searchBar.text = @"";
	letUserSelectRow = YES;
	searching = NO;
	[theSearchBar setShowsCancelButton:NO];
	[theSearchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
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


- (IBAction) Edit:(id)sender{
	if(self.editing){
		[super setEditing:NO animated:YES]; 
		[moduleListTableView setEditing:NO animated:YES];
		[moduleListTableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Add to Basket"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
		[self.navigationItem.leftBarButtonItem setEnabled:YES];
	}else{
		[super setEditing:YES animated:YES]; 
		[moduleListTableView setEditing:YES animated:YES];
		[moduleListTableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
		[self.navigationItem.leftBarButtonItem setEnabled:NO];
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
#pragma mark Go To RequirementPlacingViewController

- (IBAction)forwardToRequirement:(id)sender{
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
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

