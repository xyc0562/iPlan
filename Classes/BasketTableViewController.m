//
//  BasketTableViewController.m
//  iPlan
//
//  Created by Zhang Ying on 7/1/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import "BasketTableViewController.h"
#import "SharedAppDataObject.h"
#import "AppDelegateProtocol.h"


@implementation BasketTableViewController

#pragma mark -
#pragma mark instance method

- (SharedAppDataObject*) theAppDataObject{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}


#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)cancelClicked:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)] autorelease];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	SharedAppDataObject* theDataObject = [self theAppDataObject];
    return [theDataObject.basket count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	cell.textLabel.text = [theDataObject.basket objectAtIndex:indexPath.row];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[DetailViewController alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}

#pragma mark -
#pragma mark Delete modules from the basket

//- (IBAction)DeleteButtonAction:(id)sender{
//	SharedAppDataObject* theDataObject = [self theAppDataObject];
//	[theDataObject.basket removeLastObject];
//	[moduleListTableView reloadData];
//}

- (IBAction) Edit:(id)sender{
	if(self.editing){
		[super setEditing:NO animated:NO]; 
		[self.tableView setEditing:NO animated:NO];
		[self.tableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Delete"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
		[self.navigationItem.leftBarButtonItem setEnabled:YES];
	}else{
		[super setEditing:YES animated:YES]; 
		[self.tableView setEditing:YES animated:YES];
		[self.tableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
		[self.navigationItem.leftBarButtonItem setEnabled:NO];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;	
}


- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		SharedAppDataObject* theDataObject = [self theAppDataObject];
		
		// only add the same module once
		NSString *deletedModule = cell.textLabel.text;
		if ([theDataObject.basket containsObject:deletedModule]){
			//SharedData manipulation
			[theDataObject.basket removeObject:deletedModule];
			
			[theDataObject.removedCells setObject:[theDataObject.moduleCells objectForKey:deletedModule]  forKey:deletedModule];
			[theDataObject.moduleCells removeObjectForKey:deletedModule];
			
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
		}
		//NSLog(@"haha: %i %@", [theDataObject.basket count],cell.textLabel.text); 
    }
}

#pragma mark -
#pragma mark Row reordering

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
	  toIndexPath:(NSIndexPath *)toIndexPath {
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	NSMutableArray *bkt = theDataObject.basket;
	NSString *item = [[bkt objectAtIndex:fromIndexPath.row] retain];
	[bkt removeObject:item];
	[bkt insertObject:item atIndex:toIndexPath.row];
	[item release];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

