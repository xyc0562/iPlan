//
//  ListViewController.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-7-16.
//  Copyright 2011 NUS. All rights reserved.
//

#import "ListViewController.h"
#import "SlotViewController.h"
@implementation ListViewController
@synthesize newSlotViewControllers;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{
        // Custom initialization.
    }
    return self;
}

- (SharedAppDataObject*) theAppDataObject
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}
	
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if(newSlotViewControllers!=nil)
	{
		[newSlotViewControllers removeAllObjects];
		[newSlotViewControllers release];
	}
	
	newSlotViewControllers = [[NSMutableArray alloc]init];
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	NSMutableArray* slotViewControllers = theDataObject.slotViewControllers;
	if([slotViewControllers count]>0)
	[newSlotViewControllers addObject:[slotViewControllers objectAtIndex:0]];
	for(int i=0;i<[slotViewControllers count];i++)
	{
		SlotViewController* slot = [slotViewControllers objectAtIndex:i];
		for(int j=0;j<[newSlotViewControllers count];j++)
		{
			SlotViewController* slot2 = [newSlotViewControllers objectAtIndex:j];
			if ([slot.moduleCode isEqualToString:slot2.moduleCode]&&
				[slot.classTypeName isEqualToString:slot2.classTypeName]&&
				[slot.classGroupName isEqualToString:slot2.classGroupName]);
			else 
			{
				[newSlotViewControllers addObject:slot];
			}
		}
	}
	printf("new count %d\n",[newSlotViewControllers count]);
	printf("count %d\n",[theDataObject.slotViewControllers count]);
	printf("count2 %d\n",[slotViewControllers count]);
	[table reloadData];
	
}
/*
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	

}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
	return [newSlotViewControllers count];
}




// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{

	int row = indexPath.row;
    NSString *CellIdentifier = [@"Cell" stringByAppendingFormat:@"%d",indexPath.row];
	if([newSlotViewControllers count]!=0)
		CellIdentifier = [CellIdentifier stringByAppendingString:[[newSlotViewControllers objectAtIndex:row]moduleCode]];
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    
	

    // Configure the cell...
	NSString* displayInfo = @"";
	SlotViewController* slot = [newSlotViewControllers objectAtIndex:row];
	displayInfo = [displayInfo stringByAppendingString:[slot moduleCode]];
	displayInfo = [displayInfo stringByAppendingString:@" "];
	displayInfo = [displayInfo stringByAppendingString:[slot classTypeName]];
	displayInfo = [displayInfo stringByAppendingString:@" "];
	displayInfo = [displayInfo stringByAppendingString:[slot classGroupName]];
	displayInfo = [displayInfo stringByAppendingString:@"\n"];
	displayInfo = [displayInfo stringByAppendingString:[slot venue]];
	displayInfo = [displayInfo stringByAppendingString:@" "];
	
	if([[slot dayNumber]intValue]==1)
		displayInfo = [displayInfo stringByAppendingString:@"MON"];
	else if([[slot dayNumber]intValue]==2)
		displayInfo = [displayInfo stringByAppendingString:@"TUE"];
	else if([[slot dayNumber]intValue]==3)
		displayInfo = [displayInfo stringByAppendingString:@"WED"];
	else if([[slot dayNumber]intValue]==4)
		displayInfo = [displayInfo stringByAppendingString:@"THU"];
	else if([[slot dayNumber]intValue]==5)
		displayInfo = [displayInfo stringByAppendingString:@"FRI"];
	
	displayInfo = [displayInfo stringByAppendingString:@" "];
	displayInfo = [displayInfo stringByAppendingString:[[slot startTime]stringValue]];
	displayInfo = [displayInfo stringByAppendingString:@"-"];
	displayInfo = [displayInfo stringByAppendingString:[[slot endTime]stringValue]];
	
	
	
	cell.textLabel.text	 = displayInfo;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
	
    return cell;
}

//end of table view adjustment


- (void)dealloc {
    if(newSlotViewControllers)
		[newSlotViewControllers release];
	[super dealloc];
	
}


@end
