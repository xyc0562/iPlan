//
//  LoadViewController.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-7-16.
//  Copyright 2011 NUS. All rights reserved.
//

#import "LoadViewController.h"
#import "ModelLogic.h"

@implementation LoadViewController
@synthesize namelist;
@synthesize table;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if(namelist)
		[namelist release];
	namelist = [[[ModelLogic modelLogic]getAllTimeTables] retain];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if(namelist) [namelist release];
	namelist = [[[ModelLogic modelLogic]getAllTimeTables] retain];
	[table reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.

	return [namelist count];
}




// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	int row = indexPath.row;
    NSString *CellIdentifier = [@"Cell" stringByAppendingFormat:@"%d",indexPath.row];
	if([namelist count]!=0)
		CellIdentifier = [CellIdentifier stringByAppendingString:[namelist objectAtIndex:row]];
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	
	cell.textLabel.text	 = [namelist objectAtIndex:row];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int row = indexPath.row;
	NSString *filename = [namelist objectAtIndex:row];
	[[ModelLogic modelLogic]loadFile:filename];
	UINavigationController *controller = [self.tabBarController.viewControllers objectAtIndex:0];
	[controller viewWillAppear:YES];
	self.tabBarController.selectedViewController = 	controller;
	
}


- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: animated];
    [table setEditing: editing animated:animated];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Determine if it's in editing mode
    if (table.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[ModelLogic modelLogic]deleteFile:[namelist objectAtIndex:indexPath.row]];
		[namelist release];
		namelist = [[[ModelLogic modelLogic]getAllTimeTables] retain]; 
		[tableView reloadData];
	}    
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
