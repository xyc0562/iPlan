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
@synthesize tableChoices;
@synthesize availableSlots;
@synthesize table;


- (SharedAppDataObject*) theAppDataObject{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}


- (void) configureView 
{
	//ModelLogic* ml = [[ModelLogic alloc]init];
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	//NSMutableArray* defaultAnswer = [ml getSelectedGroupsInfo];
	NSMutableArray* defaultAnswer = [[ModelLogic modelLogic] getSelectedGroupsInfo];
	displayViewController = [[DisplayViewController alloc]init];
	NSMutableArray* displaySlots = displayViewController.slotViewControllers;
	
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
																	   WithClassTypeName:classTypeName
																			   WithIndex:[displaySlots count]
																		  WithGroupIndex:[[dictInner objectForKey:@"groupIndex"]intValue]];
			[displaySlots addObject:slotView];
		}
		
		
	}
		
	//for each slotView in displaySlots
	
	[scrollView setContentSize:CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
	
	for (int i = 0; i < NUMBER_OF_ROW_LINES; i++){
		UIViewWithLine *line = [[UIViewWithLine alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000) 
															 Point1X:HEADER_ORIGIN_X 
															 Point1Y:(HEADER_ORIGIN_Y+i*GAP_HEIGHT) 
															 Point2X:HEADER_ORIGIN_X+TOTAL_WIDTH 
															 Point2Y:(HEADER_ORIGIN_Y+i*GAP_HEIGHT)];
		[line setTag:LINE_TAG];
		[[displayViewController view]addSubview:line];
		[line release];
		if (i != NUMBER_OF_ROW_LINES -1){
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(HEADER_ORIGIN_X,(HEADER_ORIGIN_Y+i*GAP_HEIGHT), GAP_WIDTH, GAP_HEIGHT)];
			if(i!=0)
			{
				label.text = [NSString stringWithFormat:@"%d:00",i+7];
			}
			else {
				label.text = @"Class";
			}
			
			label.textColor = [UIColor whiteColor];
			label.backgroundColor = [UIColor blackColor];
			[label setTag:LABEL_TAG];
			[[displayViewController view]addSubview:label];
			[label release];			
		}
	}
	for (int i = 0; i < NUMBER_OF_COL_LINES; i++){
		UIViewWithLine *line = [[UIViewWithLine alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000) 
															 Point1X:(HEADER_ORIGIN_X+i*GAP_WIDTH)
															 Point1Y:HEADER_ORIGIN_Y
															 Point2X:(HEADER_ORIGIN_X+i*GAP_WIDTH) 
															 Point2Y:HEADER_ORIGIN_Y+TOTAL_HEIGHT ];
		[line setTag:LINE_TAG];
		[[displayViewController view] addSubview:line];
		
		[line release];
	}
	
	for (SlotViewController* slotView in displaySlots ) 
	{
		[[displayViewController view] addSubview:slotView.view];
		[[displayViewController view] bringSubviewToFront:slotView.view];
		[slotView.view setFrame:slotView.displayProperty];
		slotView.scroll = scrollView;
		slotView.displayView = [displayViewController view];
		slotView.table = table;
		slotView.tableChoices = tableChoices;
		//slotView.view.userInteractionEnabled = NO;
	}
	
	
	
	//	[scrollView setCenter:CGPointMake(SCROLL_BEFORE_ZOOM_X, SCROLL_BEFORE_ZOOM_Y)];
	[scrollView addSubview:[displayViewController view]];
	//	[[displayViewController view]setCenter:scrollView.center];
	[[displayViewController view]setTag:DISPLAY_TAG];
	scrollView.canCancelContentTouches = YES;
	
	theDataObject.slotControllers = displaySlots;
}

- (void) configureToolBar
{ 	
	
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	NSMutableArray* modules = theDataObject.basket;
	
	NSMutableArray* activeindexes = theDataObject.activeIndexes;
	
	modules = [[NSMutableArray alloc]init];
	activeindexes = [[NSMutableArray alloc]init];
	for(int i=0;i<10;i++)
	{
		[modules addObject:@"CMA1101"];
		[activeindexes addObject:[NSNumber numberWithInt:i]];
		printf("count %d",[activeindexes count]);
	}
	
	if([activeindexes count]!=0)
	{
		CGRect frame = CGRectMake(NAV_FRAME_X,NAV_FRAME_Y,NAV_FRAME_W,NAV_FRAME_H);
		UIView* temp = [[UIView alloc]initWithFrame:frame];
		float cellWidth = (NAV_FRAME_W-3*NAV_BORDER_X)/(float)(NAV_COL);
		float cellHight = (NAV_FRAME_H-3*NAV_BORDER_Y)/(float)(NAV_ROW);
		for (int i=0;i<[activeindexes count];i++) 
		{
			int col = i%NAV_COL;
			int row = i/NAV_COL;
			
			NSString* selectedModule = [modules objectAtIndex:[[activeindexes objectAtIndex:i]intValue]];
			UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(col*cellWidth,NAV_BORDER_Y*(row+1)+cellHight*row,cellWidth-CELL_BORDER,cellHight)];
			[titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:NAV_FONT_SIZE]];
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
	NSLog(@"compile Lapi connection!");
	
	[self.view addSubview:theWeb];
	[self.view addSubview: scrollView];
	[self.view addSubview:table];
	[self.view sendSubviewToBack:theWeb];
	
	table.frame = CGRectMake(TABLE_X, TABLE_Y, TABLE_W,TABLE_H);
	[table reloadData];
	[self configureToolBar];
	[self configureView];
	
	// ZY: alert for update the xml file or not
	[self alertForUpdate];
	NSLog(@"%@", theWeb.loading ? @"YES":@"NO");
	NSLog(@"%@", theWeb.request.URL.absoluteString);
}

/*
 - (void) viewWillAppear:(BOOL)animated
 {
 [self.navigationController setNavigationBarHidden:YES animated:animated];
 [super viewWillAppear:animated];
 }
 
 - (void) viewWillDisappear:(BOOL)animated
 {
 [self.navigationController setNavigationBarHidden:NO animated:animated];
 [super viewWillDisappear:animated];
 
 }
 */
/*
 - (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
 
 
 
 // zoom in
 SharedAppDataObject* theDataObject = [self theAppDataObject];
 if(![theDataObject zoomed])
 {
 [UIView beginAnimations:nil context:nil]; 
 [UIView setAnimationDuration:0.3]; 
 [[displayViewController view]removeFromSuperview];
 [[displayViewController view]setTransform:CGAffineTransformMakeScale(2.0, 2.0)];
 //NSMutableArray* displaySlots = displayViewController.slotViewControllers;
 //		for (SlotViewController* slotView in displaySlots ) 
 //		{
 //			slotView.view.userInteractionEnabled = YES;
 //		}
 //		
 [scrollView setContentSize:CGSizeMake(SCROLLVIEW_WIDTH_ZOOM, SCROLLVIEW_HEIGHT_ZOOM)];
 [scrollView setContentOffset:CGPointMake(0, 0)];
 [scrollView addSubview:[displayViewController view]];
 [[displayViewController view] setCenter:CGPointMake(SCROLL_AFTER_ZOOM_X, SCROLL_AFTER_ZOOM_Y)];
 
 [UIView commitAnimations];
 
 }
 else 
 {
 [UIView beginAnimations:nil context:nil]; 
 [UIView setAnimationDuration:0.3]; 
 [[displayViewController view]removeFromSuperview];
 [[displayViewController view]setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
 [scrollView setContentSize:CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
 [scrollView setContentOffset:CGPointMake(0, 0)];
 [scrollView addSubview:[displayViewController view]];
 [[displayViewController view] setCenter:CGPointMake(SCROLL_BEFORE_ZOOM_X, SCROLL_BEFORE_ZOOM_Y)];
 //NSMutableArray* displaySlots = displayViewController.slotViewControllers;
 //		for (SlotViewController* slotView in displaySlots ) 
 //		{
 //			slotView.view.userInteractionEnabled = NO;
 //		}
 [UIView commitAnimations];
 
 }
 
 theDataObject.zoomed = !theDataObject.zoomed;
 
 }
 
 
 /*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (id)initWithTabBar 
{
	if (self = [super initWithNibName:@"CalendarViewController" bundle:nil]) 
	{
		
		self.tabBarItem.image =[UIImage imageNamed:@"calendar.png"];
		self.navigationController.title = @"nav title";
		self.tableChoices = [[NSMutableArray alloc]init];
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
	if([tableChoices count]==0)
		return 1;
	else
		return [tableChoices count]-1;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *CellIdentifier = [@"Cell" stringByAppendingFormat:@"%d",indexPath.row];
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    

	
    // Configure the cell...
	//if([tableChoices count]==0)
		cell.textLabel.text = @"Only One Slot Avaiable";
	//else
/*	{
		
		NSUInteger row = [indexPath row];
		cell.textLabel.text = [tableChoices objectAtIndex:row];
		UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
		if([[tableChoices objectAtIndex:[tableChoices count]-1]isEqualToString:CLASH])
		{
			UIImage *image =  [UIImage imageNamed:@"next.png"];
			CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
			addButton.frame = frame;
			
			[addButton setBackgroundImage:image forState:UIControlStateNormal];
			
			[addButton addTarget:self action:@selector(nextButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
			
			addButton.backgroundColor = [UIColor clearColor];
			
			cell.accessoryView = addButton;
		}
		else if([[tableChoices objectAtIndex:[tableChoices count]-1]isEqualToString:SLOTS])
		{
			UIImage *image =  [UIImage imageNamed:@"refresh.png"];
			UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
			CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
			addButton.frame = frame;
			
			[addButton setBackgroundImage:image forState:UIControlStateNormal];
			
			[addButton addTarget:self action:@selector(refreshButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
			
			addButton.backgroundColor = [UIColor clearColor];
			
			cell.accessoryView = addButton;
		}			
		else
			printf("Error");
	}
*/	
    return cell;
}

- (void) nextButtonTapped:(id)sender event:(id)event
{
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	int selectIndex = theDataObject.selectSlotIndex;
	SlotViewController* slot = [[displayViewController slotViewControllers]objectAtIndex:selectIndex];
	//model logic get all available but not this one slots
//	if(availableSlots)
	
	//handle and make the content for table choices
	tableChoices = availableSlots;
	if([availableSlots count]>0)
		[tableChoices addObject:SLOTS];
	[table reloadData];
}


- (void) refreshButtonTapped:(id)sender event:(id)event
{
	[tableChoices removeAllObjects];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if([[tableChoices objectAtIndex:[tableChoices count]-1]isEqualToString:CLASH])
	{
		SharedAppDataObject* theDataObject = [self theAppDataObject];
		NSMutableArray* slotControllers = theDataObject.slotControllers;
		if([tableChoices count]!=0)
		{
			for(SlotViewController* slot in slotControllers)
			{
				if(slot.groupIndex==-1)
				{
					[slot.view removeFromSuperview];
					[slotControllers removeObject:slot];
					[slot release];
				}
			}
		}
		for(int i =0;i<[slotControllers count];i++)
		{
			SlotViewController* slot = [slotControllers objectAtIndex:i];
			slot.index = i;
		}
		int row = indexPath.row;
		SlotViewController* slotView = [[SlotViewController alloc]initWithModuleCode:@"MA1101" 
																		   WithVenue:@"Science" 
																	   WithStartTime:[NSNumber numberWithInt:10] 
																		 WithEndTime:[NSNumber numberWithInt:12]
																			 WithDay:[NSNumber numberWithInt:1] 
																  WithClassGroupName:@"SL1" 
																	 WithModuleColor:[UIColor blueColor]
																		WithProperty:CGRectMake(100, 100, 10, 1)
																		   WithIndex:[slotControllers count]
																	  WithGroupIndex:-1];
		[[displayViewController slotViewControllers]addObject:slotView];
		[[displayViewController view]addSubview:[slotView view]];
		
		
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
    [super dealloc];
}


@end
