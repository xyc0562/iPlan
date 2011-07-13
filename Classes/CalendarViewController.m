//
//  CalendarViewController.m
//  iPlan
//
//  Created by Zhang Ying on 6/21/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import "CalendarViewController.h"
#import "UIViewWithLine.h"
// #import "ControllerConstant.h" //Temply disable to build
#import "SharedAppDataObject.h"
#import "AppDelegateProtocol.h"
#import "ModelLogic.h"

// import parser to check
#import "ModuleXMLParser.h"

#define SERVER_URL @"https://ivle.nus.edu.sg/api/login/?apikey=K6vDt3tA51QC3gotLvPYf"


@interface CalendarViewController (UtilityMethods)


@end

@implementation CalendarViewController

@synthesize scrollView;
@synthesize theWeb;
@synthesize displayViewController;
@synthesize slotViewControllers;
@synthesize tableChoices;
@synthesize availableSlots;
@synthesize table;
@synthesize imageView;


- (SharedAppDataObject*) theAppDataObject{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}


- (void) configureView 
{
	//read in data from Model Logic
	
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	NSMutableArray* defaultAnswer = [[ModelLogic modelLogic] getSelectedGroupsInfo];
	
	[scrollView addSubview:imageView];

	
	for (NSDictionary* dict in defaultAnswer) 
	{
		NSString* moduleCode = [dict objectForKey:@"moduleCode"];
		UIColor* color = [dict objectForKey:@"color"];
		NSString* classTypeName = [dict objectForKey:@"classTypeName"];
		NSString* classGroupName = [dict objectForKey:@"classGroupName"];
		NSMutableArray* slots = [dict objectForKey:@"slots"];
		for(NSDictionary* dictInner in slots)
		{
			
			SlotViewController* slotView = [[SlotViewController alloc]initWithModuleCode:moduleCode 
																			   WithVenue:[dictInner objectForKey:@"venue"]
																		   WithStartTime:[dictInner objectForKey:@"startTime"]
																			 WithEndTime:[dictInner objectForKey:@"endTime"]
																				 WithDay:[dictInner objectForKey:@"day"]
																	  WithClassGroupName:classGroupName 
																		 WithModuleColor:color
																	   WithClassTypeName:classTypeName];
			[slotViewControllers addObject:slotView];
		}
		
		
	}
	
	
		

	
	//for each slotView in displaySlots
	
	[scrollView setContentSize:CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
	
		
	for (SlotViewController* slot in slotViewControllers ) 
	{
		slot.scroll = scrollView;
		slot.table = table;
		slot.tableChoices = tableChoices;
		slot.availableSlots = availableSlots;
		[imageView addSubview:slot.view];
		slot.view.backgroundColor = [slot moduleColor];
		[imageView	bringSubviewToFront:slot.view];
		[[slot view]setFrame:[slot calculateDisplayProperty]];
		slot.view.userInteractionEnabled = YES;
		slot.view.multipleTouchEnabled = YES;
		//slot.view.alpha = 0.3;
	}
	
	for (SlotViewController* slot1 in slotViewControllers ) 
		for(SlotViewController* slot2 in slotViewControllers)
			if(slot1!=slot2&&[slot1.dayNumber intValue]==[slot2.dayNumber intValue])
			{
				if([slot1.startTime intValue]>=[slot2.endTime intValue]||[slot1.endTime intValue]<=[slot2.startTime intValue]);
				else 
				{
					slot1.view.alpha = 0.3;
					slot2.view.alpha = 0.3;
					for(UIView*any in [slot1.view subviews])
						[any removeFromSuperview];
					for (UIView*any in [slot2.view subviews])
						[any removeFromSuperview];
				}
			}
		
			
	
	
	
	theDataObject.slotControllers = slotViewControllers;
}

- (void) configureToolBar
{ 	
	if([slotViewControllers count]!=0)
	{
		SharedAppDataObject* theDataObject = [self theAppDataObject];
		NSMutableArray* active = [theDataObject activeModules];
		CGRect frame = CGRectMake(NAV_FRAME_X,NAV_FRAME_Y,NAV_FRAME_W,NAV_FRAME_H);
		UIView* temp = [[UIView alloc]initWithFrame:frame];
		float cellWidth = (NAV_FRAME_W-3*NAV_BORDER_X)/(float)(NAV_COL);
		float cellHight = (NAV_FRAME_H-3*NAV_BORDER_Y)/(float)(NAV_ROW);
		
		for (int i=0;i<[active count];i++) 
		{
			int col = i%NAV_COL;
			int row = i/NAV_COL;
			NSString* selectedModule = [active objectAtIndex:i];
			UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(col*cellWidth,NAV_BORDER_Y*(row+1)+cellHight*row,cellWidth-CELL_BORDER,cellHight)];
			[titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:NAV_FONT_SIZE]];
			
			//[titleLabel setBackgroundColor:[[ModelLogic modelLogic]getModuleColorWithModuleCode:[slot moduleCode]];
			[titleLabel setBackgroundColor:[UIColor blueColor]];
			[titleLabel setTextColor:[UIColor whiteColor]];
			[titleLabel setText:selectedModule];
			[titleLabel setTextAlignment:UITextAlignmentCenter];
			[temp addSubview:titleLabel];
		}
		self.navigationItem.titleView = temp;
	}
	else 
	{
		self.title = @"Calendar";
	}
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
	if ([button isEqual:@"Update"]){
		ModuleXMLParser *aParser = [[ModuleXMLParser alloc] initWithURLStringAndParse:@"http://cors.i-cro.net/cors.xml"];	[aParser release];
	}
}

- (void)alertForUpdate {
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	if (theDataObject.needUpdate == YES){
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Update Reminder" message:@"The new course schedules are out. Do you want to update now? This may take some time." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Update",nil];
		[alertView show];
		[alertView release];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view addSubview: scrollView];
	scrollView.multipleTouchEnabled = YES;
	scrollView.userInteractionEnabled = YES;
	scrollView.frame = CGRectMake(SCROLL_X, SCROLL_Y, SCROLL_W, SCROLL_H);
	scrollView.bounces = NO;
	scrollView.showsVerticalScrollIndicator = YES;
	scrollView.showsHorizontalScrollIndicator = YES;
	
	//Lapi issue
	NSURL *url = [NSURL URLWithString:SERVER_URL];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	[theWeb loadRequest:requestObj];
	theWeb.opaque = NO;
	theWeb.backgroundColor = [UIColor clearColor];
	[theWeb loadHTMLString:@"<html><body style='background-color: transparent'></body></html>" baseURL:nil];

	
	[self.view addSubview:theWeb];
	[self.view addSubview: scrollView];
	[self.view addSubview:table];
	[self.view sendSubviewToBack:theWeb];
	
	[self configureView];
	[self configureToolBar];
	
	table.frame = CGRectMake(TABLE_X, TABLE_Y, TABLE_W,TABLE_H);
	[table reloadData];
	// ZY: alert for update the xml file or not
	[self alertForUpdate];

}


- (id)initWithTabBar 
{
	if (self = [super initWithNibName:@"CalendarViewController" bundle:nil]) 
	{
		
		self.tabBarItem.image =[UIImage imageNamed:@"calendar.png"];
		self.navigationController.title = @"nav title";
		self.tableChoices = [[NSMutableArray alloc]init];
		self.slotViewControllers = [[NSMutableArray alloc]init];
		self.imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"timetable with days.png"]];
		self.imageView.frame =  CGRectMake(TIMETABLE_X,TIMETABLE_Y,TIMETABLE_W,TIMETABLE_H);
		self.imageView.multipleTouchEnabled = YES;
		self.imageView.userInteractionEnabled = YES;
		self.availableSlots = [[NSMutableArray alloc]init];
	}
	return self;
}


#pragma mark -
#pragma mark table view 


//table View Adjustment
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.

		return [tableChoices count]+1;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *CellIdentifier = [@"Cell" stringByAppendingFormat:@"%d",indexPath.row];
	if([tableChoices count]!=0)
	CellIdentifier = [CellIdentifier stringByAppendingString:[tableChoices objectAtIndex:[tableChoices count]-1]];
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    

	
    // Configure the cell...
	if([tableChoices count]==0)
		cell.textLabel.text = @"Only One Slot Avaiable";
	
	else
	{
		
		NSUInteger row = [indexPath row]-1;
		if(row!=-1&&row!=[tableChoices count]-1)
		cell.textLabel.text = [tableChoices objectAtIndex:row];
		
		
		
		//DISPLAY CLASH CHOICES
				
		//DISPLAY AVALIABLE SLOTS
		if([[tableChoices objectAtIndex:[tableChoices count]-1]isEqualToString:SLOTS])
		{
			if(row==-1)
			{	
				cell.textLabel.text = @"Other available slots";
			}
			else if(row!=[tableChoices count]-1)
			{	
				UIImage *image =  [UIImage imageNamed:@"refresh.png"];
				UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
				CGRect frame = CGRectMake(0.0, 0.0, 30, 30);
				addButton.frame = frame;
				
				[addButton setBackgroundImage:image forState:UIControlStateNormal];
				
				[addButton addTarget:self action:@selector(refreshButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
				
				addButton.backgroundColor = [UIColor clearColor];
				
				cell.accessoryView = addButton;
			}
		}
		
		else if([[tableChoices objectAtIndex:[tableChoices count]-1]isEqualToString:CLASH])
		{
			if(row==-1)
			{
				cell.textLabel.text = @"Select one Crashed Module";
			}

		}
			
	}
	
    return cell;
}


- (void) refreshButtonTapped:(id)sender event:(id)event
{
	
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:table];
	NSIndexPath *indexPath = [table indexPathForRowAtPoint:currentTouchPosition];
	SlotViewController* select = [availableSlots objectAtIndex:indexPath.row-1];
	for(SlotViewController* slot in availableSlots)
	{
		[slot.view removeFromSuperview];
	}
	
	//remove from slotviewcontrollers
	//remove previous selected
	
	for (int i =0;i<[slotViewControllers count];i++) 
	{
		SlotViewController* slot = [slotViewControllers objectAtIndex:i];
		if([slot.moduleCode isEqual:select.moduleCode]&&[slot.classTypeName isEqual:select.classTypeName])
		{
			[slot.view removeFromSuperview];
			[slotViewControllers removeObjectAtIndex:i];
		}
	}
	
	
	//add in new slots selected
	for(SlotViewController* slot in availableSlots)
	{
		if([slot.moduleCode isEqual:select.moduleCode]&&[slot.classTypeName isEqual:select.classTypeName]&&[slot.classGroupName isEqual:select.classGroupName])
		{
			[slotViewControllers addObject:slot];
		}
	}
	
	

	//refresh whole table to set to original color
	for(SlotViewController* slot in slotViewControllers)
	{
		[slot.view removeFromSuperview];
		[imageView addSubview:slot.view];
		slot.view.backgroundColor = [slot moduleColor];
		slot.view.multipleTouchEnabled = YES;
		slot.view.userInteractionEnabled = YES;
		[slot.view setFrame:[slot calculateDisplayProperty]];
	}
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	theDataObject.selectSlot = nil;
	[tableChoices removeAllObjects];
	[availableSlots removeAllObjects];
	[table reloadData];
}

- (void)getAvailableSlotsWithSlot:(SlotViewController*)slot
{
	[tableChoices removeAllObjects];
	[availableSlots removeAllObjects];
	NSMutableArray* availableAnswer = [[ModelLogic modelLogic] getOtherAvailableGroupsWithModuleCode:[slot moduleCode]
																				  WithClassTypeIndex:[slot classTypeName]
																					   WithGroupName:[slot classGroupName]];
	
	for (NSDictionary* dict in availableAnswer) 
	{
		NSString* code = [dict objectForKey:@"moduleCode"];
		UIColor* color = [dict objectForKey:@"color"];
		NSString* typeName = [dict objectForKey:@"classTypeName"];
		NSString* groupName = [dict objectForKey:@"classGroupName"];
		NSMutableArray* slots = [dict objectForKey:@"slots"];
		for(NSDictionary* dictInner in slots)
		{
			
			SlotViewController* slot = [[SlotViewController alloc]initWithModuleCode:code 
																		   WithVenue:[dictInner objectForKey:@"venue"]
																	   WithStartTime:[dictInner objectForKey:@"startTime"]
																		 WithEndTime:[dictInner objectForKey:@"endTime"]
																			 WithDay:[dictInner objectForKey:@"day"]
																  WithClassGroupName:groupName 
																	 WithModuleColor:color
																   WithClassTypeName:typeName];
			[availableSlots addObject:slot];
		}
	}
	
	for(int i=0;i<[availableSlots count];i++)
	{
		SlotViewController* slot = [availableSlots objectAtIndex:i];
		NSString* displayInfo = [NSString stringWithString:[slot moduleCode]];
		displayInfo = [displayInfo stringByAppendingString:@" "];
		displayInfo = [displayInfo stringByAppendingString:[[slot dayNumber]stringValue]];
		displayInfo = [displayInfo stringByAppendingString:@" "];
		displayInfo = [displayInfo stringByAppendingString:[[slot startTime]stringValue]];
		displayInfo = [displayInfo stringByAppendingString:@"-"];
		displayInfo = [displayInfo stringByAppendingString:[[slot endTime]stringValue]];
		[tableChoices addObject:displayInfo];
	}
	
	if([availableSlots count]!=0)
		[tableChoices addObject:SLOTS];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if([tableChoices count]!=0)
	{
		//Handle Available Slot
		if([[tableChoices objectAtIndex:[tableChoices count]-1]isEqualToString:SLOTS])
		{
			for(SlotViewController* slot in availableSlots)
			{
				[slot.view removeFromSuperview];
			}
			int row = indexPath.row-1;
			SlotViewController* slot = [availableSlots objectAtIndex:row];
			[imageView addSubview:slot.view];
			slot.view.frame = [slot calculateDisplayProperty];
			slot.view.backgroundColor = [UIColor darkGrayColor];
			slot.view.alpha = 1;
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:3];
			[slot.view setAlpha:0.2];
			[UIView commitAnimations];
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:3];
			[slot.view setAlpha:1];
			[UIView commitAnimations];
			[slot.view setAlpha:1];
		/*	SharedAppDataObject* theDataObject = [self theAppDataObject];
			SlotViewController* select = [theDataObject selectSlot];
			for (int i =0;i<[slotViewControllers count];i++) 
			{
				
				SlotViewController* slot = [slotViewControllers objectAtIndex:i];
				if([slot.moduleCode isEqual:select.moduleCode]&&[slot.classTypeName isEqual:select.classTypeName]&&[slot.classGroupName isEqual:select.classGroupName])
				{
					[slot.view removeFromSuperview];
					[slotViewControllers removeObjectAtIndex:i];
				}
			}
			theDataObject.selectSlot = nil;
		 */
		}
		
		//Handle Clash
		else if([[tableChoices objectAtIndex:[tableChoices count]-1]isEqualToString:CLASH])
		{
			SharedAppDataObject* theDataObject = [self theAppDataObject];
			SlotViewController* slotSelect = [theDataObject selectSlot];
			int row = indexPath.row - 1;
			int count = 0;
			for (SlotViewController* slot in slotViewControllers) 
			{
				if ([slot.dayNumber intValue]==[slotSelect.dayNumber intValue]&&slot!=slotSelect) 
				{
					if([slot.startTime intValue]>=[slotSelect.endTime intValue]||[slot.endTime intValue]<=[slotSelect.startTime intValue]);
					else 
					{
						if(count==row)
						{
							[self getAvailableSlotsWithSlot:slot];
							break;
							
							
						}
						count = count + 1;
					}
					
				}
			}
			if(count == row)
				[self getAvailableSlotsWithSlot:slotSelect];
			[table reloadData];
		
		}
		
	}
 }
			
							
				
				


//end of table view adjustment

#pragma mark -
#pragma mark memory management


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	theWeb.delegate = nil;
}

- (void)dealloc {
	[scrollView release];
	[theWeb release];
	[displayViewController release];
	[availableSlots release];
    [super dealloc];
}


@end
