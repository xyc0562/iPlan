//
//  ModuleListViewController.m
//  iPlan
//
//  Created by Zhao Cong on 6/28/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModuleListViewController.h"
#import	"ModuleInfoViewController.h"
#import "BasketTableViewController.h"
#import "RequirementPlacingViewController.h"
#import "SharedAppDataObject.h"
#import "AppDelegateProtocol.h"
#import "ModelLogic.h"
#import "ConstantFile.h"
#import "CalendarViewController.h"
#define SELECT_MODULE @"Do you want to add the module into basket?"
#define DESELECT_MODULE @"Do you want to remove the module from basket?"
#define SURE_TO_CHANGE_TO_CALENDAR @"Do you want to switch to Calendar? Calendar Content will be modified."
#define NO_SOLUTION @"Sorry there is no possible Timetable based on your selection."

@implementation ModuleListViewController

#pragma mark -
#pragma mark synthesize
@synthesize moduleListTableView;
@synthesize moduleList;
@synthesize copyModuleList;
@synthesize pathForAlert;

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
	//searching = NO;
	BasketTableViewController *basketController = [[BasketTableViewController alloc] initWithStyle:UITableViewStylePlain];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:basketController];
	[basketController release];
    [[self navigationController] presentModalViewController:navController animated:YES];
    [navController release];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	//ModelLogic *ml = [[ModelLogic alloc] init];
	
    //NSMutableArray *arr = (NSMutableArray*)[ml getAllModuleCodes];
	NSMutableArray *arr = (NSMutableArray*)[[ModelLogic modelLogic] getAllModuleCodes];
	
	NSArray *array = [[NSArray alloc] initWithArray:arr];
	self.moduleList = array;
	
	[array release];
	//[ml release];
	
	// initialize the copy array
	copyModuleList = [[NSMutableArray alloc] initWithArray:moduleList];
	
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;

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
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [copyModuleList count];
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
	
	addedModule = [copyModuleList objectAtIndex:row];
	
	cell.textLabel.text = addedModule;
	
	BOOL checked = [theDataObject.basket containsObject:addedModule];

	UIImage *image = (checked) ? [UIImage imageNamed:@"checked.png"] : [UIImage imageNamed:@"unchecked.png"];
	
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
	CGPoint currentTouchPosition = [touch locationInView:moduleListTableView];
	NSIndexPath *indexPath = [moduleListTableView indexPathForRowAtPoint:currentTouchPosition];
	if(indexPath != nil){
		[self tableView:moduleListTableView didSelectRowAtIndexPath:indexPath];
	}
}


- (void) checkButtonTapped:(id)sender event:(id)event{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:moduleListTableView];
	NSIndexPath *indexPath = [moduleListTableView indexPathForRowAtPoint:currentTouchPosition];
	if(indexPath != nil){
		[self tableView:moduleListTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
	}
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	[moduleListTableView becomeFirstResponder];
	[searchBar resignFirstResponder];
	NSString *addedModule = [copyModuleList objectAtIndex:indexPath.row];
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	
	
	//Can add module name duplicate checking here
	BOOL checked = [theDataObject.basket containsObject:addedModule];

	if(!checked){
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:SELECT_MODULE
//											  delegate:self
//											  cancelButtonTitle:@"Cancel" 
//											  otherButtonTitles:@"OK",nil];
//							  
//		[alert show];
//		[alert release];
		self.pathForAlert = indexPath;
		NSString *addedModule = [copyModuleList objectAtIndex:pathForAlert.row];
		
		[theDataObject.basket addObject:addedModule];
		
		// set the added module as active (defaultly)
		if ([theDataObject.activeModules count] <MODULE_ACTIVE_NUMBER){
			[theDataObject.activeModules addObject:addedModule];
		}
		
		UITableViewCell *cell = [moduleListTableView cellForRowAtIndexPath:pathForAlert];
		[theDataObject.moduleCells setObject:pathForAlert forKey:addedModule];
		
		UIButton *button = (UIButton *)cell.accessoryView;
		
		UIImage *newImage = [UIImage imageNamed:@"checked.png"];
		
		[button setBackgroundImage:newImage forState:UIControlStateNormal];
		
		NSLog(@"test 2");
		
	}
	else 
	{
		//[self tableView:moduleListTableView didSelectRowAtIndexPath:indexPath];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:DESELECT_MODULE
//													   delegate:self
//											  cancelButtonTitle:@"Cancel" 
//											  otherButtonTitles:@"OK",nil];
//		
//		[alert show];
//		[alert release];
		self.pathForAlert = indexPath;
		NSString *addedModule = [copyModuleList objectAtIndex:pathForAlert.row];
		[theDataObject.basket removeObject:addedModule];
		if ([theDataObject.activeModules containsObject:addedModule]){
			[theDataObject.activeModules removeObject:addedModule];
		}
		
		UITableViewCell *cell = [moduleListTableView cellForRowAtIndexPath:pathForAlert];
		[theDataObject.removedCells setObject:pathForAlert forKey:addedModule];
		UIButton *button = (UIButton *)cell.accessoryView;
		
		UIImage *newImage = [UIImage imageNamed:@"unchecked.png"];
		
		[button setBackgroundImage:newImage forState:UIControlStateNormal];
		
		NSLog(@"test deselect");
		
	}
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSLog(@"haha");
	NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
 	NSLog(@"abc");
	NSLog(@"test for 1, path for alert: %@",pathForAlert);

	NSString *addedModule = [copyModuleList objectAtIndex:pathForAlert.row];
	NSLog(@"def");

	SharedAppDataObject* theDataObject = [self theAppDataObject];

	if ([button isEqual:@"OK"]) 
	{
		
		if (alertView.message == SELECT_MODULE)
		{
			[theDataObject.basket addObject:addedModule];
			
			// set the added module as active (defaultly)
			if ([theDataObject.activeModules count] <MODULE_ACTIVE_NUMBER){
				[theDataObject.activeModules addObject:addedModule];
			}
			
			UITableViewCell *cell = [moduleListTableView cellForRowAtIndexPath:pathForAlert];
			[theDataObject.moduleCells setObject:pathForAlert forKey:addedModule];
			
			UIButton *button = (UIButton *)cell.accessoryView;
			
			UIImage *newImage = [UIImage imageNamed:@"checked.png"];
						
			[button setBackgroundImage:newImage forState:UIControlStateNormal];
			
		}
		else if (alertView.message == DESELECT_MODULE)
		{
			[theDataObject.basket removeObject:addedModule];
			if ([theDataObject.activeModules containsObject:addedModule]){
				[theDataObject.activeModules removeObject:addedModule];
			}
			
			UITableViewCell *cell = [moduleListTableView cellForRowAtIndexPath:pathForAlert];
			[theDataObject.removedCells setObject:pathForAlert forKey:addedModule];
			UIButton *button = (UIButton *)cell.accessoryView;
			
			UIImage *newImage = [UIImage imageNamed:@"unchecked.png"];
						
			[button setBackgroundImage:newImage forState:UIControlStateNormal];
		}
		else if(alertView.message == SURE_TO_CHANGE_TO_CALENDAR)
		{
			ModelLogic* modelLogic = [ModelLogic modelLogic];
			[modelLogic syncModulesWithBasket:[theDataObject activeModules]];
			if ([[ModelLogic modelLogic] generateDefaultTimetableWithRequirements:[theDataObject requirements]])
			{
				UINavigationController *controller = [self.tabBarController.viewControllers objectAtIndex:0];
				self.tabBarController.selectedViewController = 	controller;
			}
			else 
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:NO_SOLUTION
															   delegate:self
													  cancelButtonTitle:@"Sure" otherButtonTitles:nil];
				
				[alert show];
				[alert release];
				
			}
			theDataObject.continueToCalendar = NO;
		}else if (alertView.message == NO_SOLUTION) {
			theDataObject.continueToCalendar = NO;
		}else {
			theDataObject.continueToCalendar = NO;
		}

	}else{
		theDataObject.continueToCalendar = NO;
	}

}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.view resignFirstResponder];
	//searching = NO;
    NSUInteger row_number = [indexPath row];
	
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	
	theDataObject.moduleCode = [copyModuleList objectAtIndex:row_number];
	
	UIViewController *viewController;
	viewController = [[ModuleInfoViewController alloc] initWithNibName:@"ModuleInfoViewController" bundle:nil];
	
	[[self navigationController] pushViewController:viewController animated:YES];
	[viewController release];
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[moduleListTableView resignFirstResponder];
	return indexPath;
}


#pragma mark -
#pragma mark Search Bar 

- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar 
{
	[theSearchBar setShowsCancelButton:YES];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)theSearchBar
{	
	theSearchBar.text = @"";
	[theSearchBar setShowsCancelButton:NO];
	[theSearchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	//Remove all objects first.
	[copyModuleList removeAllObjects];

	if([searchText length] > 0) {
		[self searchTableView];
	}
	else {
		[copyModuleList release];
		copyModuleList = [[NSMutableArray alloc] initWithArray:moduleList];
	}
	[moduleListTableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	[self searchTableView];
	[theSearchBar setShowsCancelButton:NO];
	[theSearchBar resignFirstResponder];
}

- (void) searchTableView {
	
	NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [NSArray arrayWithArray:moduleList];
	
	for (NSString *sTemp in searchArray){
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		if (titleResultsRange.location==0 && titleResultsRange.length > 0 && ![copyModuleList containsObject:sTemp])
			[copyModuleList addObject:sTemp];
	}
	for (NSString *sTemp in searchArray){
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		if (titleResultsRange.location!=0 && titleResultsRange.length > 0 && ![copyModuleList containsObject:sTemp])
			[copyModuleList addObject:sTemp];
	}
	searchArray = nil;
}

- (void) doneSearching_Clicked:(id)sender {
	
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	self.navigationItem.rightBarButtonItem = nil;
	
	[moduleListTableView reloadData];
}

#pragma mark -
#pragma mark Add modules to the basket

//- (IBAction)AddButtonAction:(id)sender{
//	SharedAppDataObject* theDataObject = [self theAppDataObject];
//	UIButton *button = (UIButton*) sender;
//	[theDataObject.basket addObject:button.titleLabel];
//	
//	// set the added module as active (defaultly)
//	if ([theDataObject.activeModules count] <MODULE_ACTIVE_NUMBER){
//		[theDataObject.activeModules addObject:button.titleLabel];
//	}
//	
//	
//	[moduleListTableView reloadData];
//}


//- (IBAction) Edit:(id)sender{
//	if(self.editing){
//		[super setEditing:NO animated:YES]; 
//		[moduleListTableView setEditing:NO animated:YES];
//		[moduleListTableView reloadData];
//		[self.navigationItem.rightBarButtonItem setTitle:@"Add to Basket"];
//		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
//		[self.navigationItem.leftBarButtonItem setEnabled:YES];
//	}else{
//		[super setEditing:YES animated:YES]; 
//		[moduleListTableView setEditing:YES animated:YES];
//		[moduleListTableView reloadData];
//		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
//		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
//		[self.navigationItem.leftBarButtonItem setEnabled:NO];
//	}
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

	SharedAppDataObject* theDataObject = [self theAppDataObject];
	UITableViewCell *cell = (UITableViewCell *)[moduleListTableView cellForRowAtIndexPath:indexPath];
	NSString *addedModule = cell.textLabel.text;
	if ([theDataObject.basket containsObject:addedModule]){
		return UITableViewCellEditingStyleNone;
	}else {
		return UITableViewCellEditingStyleInsert;
	}
}


//- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
//forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//	UITableViewCell *cell = (UITableViewCell *)[moduleListTableView cellForRowAtIndexPath:indexPath];
//
//	if (editingStyle == UITableViewCellEditingStyleInsert) {
//		SharedAppDataObject* theDataObject = [self theAppDataObject];
//		
//		// only add the same module once
//		NSString *addedModule = cell.textLabel.text;
//		if (![theDataObject.basket containsObject:addedModule]){
//			[theDataObject.basket insertObject:addedModule atIndex:[theDataObject.basket count]];
//			cell.editing = NO;
//			[moduleListTableView reloadData];
//		}
//		NSLog(@"haha: %i %@", [theDataObject.basket count],cell.textLabel.text); 
//    }
//}



#pragma mark -
#pragma mark Go To RequirementPlacingViewController

- (void)moveToCalendar
{
	// check whether user clicks cancel or continue in the requirements view
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	if (theDataObject.continueToCalendar == YES)
	{
		// call the model logic and direct to the calendar view
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:SURE_TO_CHANGE_TO_CALENDAR
													   delegate:self
											  cancelButtonTitle:@"Cancel" 
											  otherButtonTitles:@"OK",nil];
		
		[alert show];
		[alert release];
		
	}
	else 
	{
		theDataObject.continueToCalendar = NO;
		//NSLog(theDataObject.continueToCalendar?@"cancel: Y":@"cancel: N");
		// do nothing
	}
	
}


- (IBAction)forwardToRequirement:(id)sender{
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	//NSLog(theDataObject.requirementEnabled?@"Y":@"N");
	if (theDataObject.requirementEnabled == NO){
		theDataObject.continueToCalendar = NO;
		RequirementPlacingViewController *reqController = [[RequirementPlacingViewController alloc] initWithStyle:UITableViewStyleGrouped];
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:reqController];
		[reqController release];
		[[self navigationController] presentModalViewController:navController animated:YES];
		[navController release];
	}else {
		// call ZYB's alert view function
		theDataObject.continueToCalendar = YES;
		[self moveToCalendar];
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

- (void)viewWillDisappear:(BOOL)animated {
	
    [super viewWillDisappear:animated];
	// to dismiss the keyboard
	[moduleListTableView becomeFirstResponder];
	[searchBar setShowsCancelButton:NO];
    [searchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.view becomeFirstResponder];
	[moduleListTableView resignFirstResponder];
	
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	
	for (NSString *key in theDataObject.removedCells) {
		NSIndexPath *path = [theDataObject.removedCells objectForKey:key];
		UITableViewCell *cell = [moduleListTableView cellForRowAtIndexPath:path];
		UIButton *button = (UIButton *)cell.accessoryView;
		
		UIImage *newImage = [UIImage imageNamed:@"unchecked.png"];
		[button setBackgroundImage:newImage forState:UIControlStateNormal];
	}
	[theDataObject.removedCells removeAllObjects];
	[moduleListTableView reloadData];
	[self moveToCalendar];
}

- (void)dealloc {
	[moduleListTableView release];
	[moduleList release];
	[copyModuleList release];
	[pathForAlert release];
    [super dealloc];
}


@end

