//
//  CalendarViewController.m
//  iPlan
//
//  Created by Zhang Ying on 6/21/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import "CalendarViewController.h"
#import "UIViewWithLine.h"
#import "ControllerConstant.h"
#import "SharedAppDataObject.h"
#import "AppDelegateProtocol.h"
#import "ModelLogic.h"
#import "AlertHelp.h"

// import parser to check
#import "ModuleXMLParser.h"

//for lapi issue
#import <Security/Security.h>
#import "SFHFKeychainUtils.h"


#define TIMER_DURATION 0.0
#define SERVER_URL @"https://ivle.nus.edu.sg/api/login/?apikey=K6vDt3tA51QC3gotLvPYf"
#define USERNAME @"U0807275"
#define PASSWORD @"hq.nusinml128"


@interface CalendarViewController (UtilityMethods)


@end

@implementation CalendarViewController

@synthesize scrollView;
@synthesize theWeb;
@synthesize table;
@synthesize imageView;
@synthesize spinner;

- (SharedAppDataObject*) theAppDataObject
{
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
	// add in imageview
	[scrollView addSubview:imageView];
	theDataObject.image = self.imageView;
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
																		   WithFrequency:[dictInner objectForKey:@"frequency"]];
			[theDataObject.slotViewControllers addObject:slotView];
			[slotView release];
		}
	}
	
	
	//for each slotView in displaySlots
	
	[scrollView setContentSize:CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
	
		
	for (SlotViewController* slot in theDataObject.slotViewControllers ) 
	{
		[imageView addSubview:slot.view];
		[imageView	bringSubviewToFront:slot.view];
		[[slot view]setFrame:[slot calculateDisplayProperty]];
		[slot setBackGroundColorWithCondition:NORMAL];
		[slot setLabelContentWithCondition:NORMAL];
		slot.view.userInteractionEnabled = YES;
		slot.view.multipleTouchEnabled = YES;
	}
	
	//set UI display for clash modules
	for (int i=0;i<[theDataObject.slotViewControllers count];i++ ) 
	{
		SlotViewController* slot1 = [theDataObject.slotViewControllers objectAtIndex:i];
		BOOL clash = NO;
		BOOL manyModule = NO;

		for(int j=i+1;j<[theDataObject.slotViewControllers count];j++)
		{
			SlotViewController* slot2 = [theDataObject.slotViewControllers objectAtIndex:j];
			if([slot1.dayNumber intValue]==[slot2.dayNumber intValue])
			{
				if([slot1.startTime intValue]>=[slot2.endTime intValue]||[slot1.endTime intValue]<=[slot2.startTime intValue]);
				else 
				{
					if ([[slot1 frequency]intValue]&[[slot2 frequency]intValue])
					{
						manyModule = YES;
					}
					else
					{
						clash = YES;
					}
				}
			}
		}
		
		if(clash)
		{
			[slot1 setBackGroundColorWithCondition:CLASH];
			[slot1 setLabelContentWithCondition:CLASH];
			[imageView bringSubviewToFront:slot1.view];
		}
		else if(manyModule)
		{
			[slot1 setBackGroundColorWithCondition:AVAILABLE];
			[slot1 setLabelContentWithCondition:AVAILABLE];
			[imageView bringSubviewToFront:slot1.view];
		}
	}
	
}

- (void) configureToolBar
{ 	
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	for(UIView* any in [self.navigationItem.titleView subviews])
		[any removeFromSuperview];
	
	if([theDataObject.slotViewControllers count]!=0)
	{
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
			
			[titleLabel setBackgroundColor:[[ModelLogic modelLogic]getModuleColorWithModuleCode:selectedModule]];
			[titleLabel setTextColor:[UIColor whiteColor]];
			[titleLabel setText:selectedModule];
			[titleLabel setTextAlignment:UITextAlignmentCenter];
			[temp addSubview:titleLabel];
			[titleLabel release];
		}
		self.navigationItem.titleView = temp;
		[temp release];
	}
	else 
	{
		self.title = @"Calendar";
	}
	
}

- (void)spinningViewLoad 
{
	ModuleXMLParser *aParser = [[ModuleXMLParser alloc] initWithURLStringAndParse:@"http://cors.i-cro.net/cors.xml"];	[aParser release];	
	// TODO: !!!
	//NSLog(@"spinning load");
	UITextView* text = (UITextView*)[spinner viewWithTag:150];
	[text removeFromSuperview];
	[text release];
	[spinner stopAnimating];
	[spinner removeFromSuperview];
	[spinner release];
}


- (NSMutableArray*)configureSaveFile
{
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	NSMutableArray* slotViewControllers = theDataObject.slotViewControllers;
	NSMutableArray* result = [[NSMutableArray alloc]init];
	for (SlotViewController* eachSelected in slotViewControllers) 
	{
		NSMutableDictionary* resultDict = [[NSMutableDictionary alloc]init];
		NSString* moduleCode = [eachSelected moduleCode];
		NSString* classTypeName = [eachSelected classTypeName];
		NSString* groupName = [eachSelected classGroupName];
		
		[resultDict setValue:moduleCode forKey:@"moduleCode"];
		[resultDict setValue:classTypeName forKey:@"classTypeName"];
		[resultDict setValue:groupName forKey:@"classGroupName"];
		
		[result addObject:resultDict];
		
	}
	return result;
	
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
	if ([button isEqual:@"Update"]){
		//NSLog(@"alert view update called");
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinner.frame = CGRectMake(140, 130, 50, 50);
		spinner.backgroundColor = [UIColor lightGrayColor];
		UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(-15, 45, 150, 60)];
		text.backgroundColor = [UIColor clearColor];
		text.tag = 150;
		text.text = @"Updating...";
		text.font = [UIFont systemFontOfSize:15];
		text.textColor = [UIColor darkGrayColor];
		[spinner addSubview:text];
		[self.view addSubview:spinner];
		[spinner startAnimating];
		[NSTimer scheduledTimerWithTimeInterval:TIMER_DURATION
										 target:self
									   selector:@selector(spinningViewLoad)
									   userInfo:nil
										repeats:NO];
		//NSLog(@"alert view ended");
	}
	
	else if ([button isEqualToString:@"Okay"])
		{
			NSString *entered = [(AlertHelp *)alertView enteredText];
			[[ModelLogic modelLogic]save:[self configureSaveFile] WithName:entered];
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
- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
	for (UIView* any in [imageView subviews]) 
	{
		[any removeFromSuperview];
	}
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	[theDataObject.tableChoices removeAllObjects];
	[theDataObject.availableSlots removeAllObjects];
	[theDataObject.slotViewControllers removeAllObjects];
	[self configureView];
	[self configureToolBar];

	
	[table reloadData];
}
		

- (void)viewDidLoad {
	[super viewDidLoad];
	CGRect frame = self.view.frame;
	self.view = [[UIView alloc]initWithFrame:frame];
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	[theDataObject.tableChoices removeAllObjects];
	[theDataObject.availableSlots removeAllObjects];
	for (UIView* any in [imageView subviews]) 
	{
		[any removeFromSuperview];
	}
	[self.imageView removeFromSuperview];
	[self.scrollView removeFromSuperview];
	[self.table removeFromSuperview];
	
	[theDataObject.slotViewControllers removeAllObjects];
 
	[self.view addSubview: scrollView];
	scrollView.multipleTouchEnabled = YES;
	scrollView.userInteractionEnabled = YES;
	scrollView.frame = CGRectMake(SCROLL_X, SCROLL_Y, SCROLL_W, SCROLL_H);
	scrollView.bounces = NO;
	scrollView.showsVerticalScrollIndicator = YES;
	scrollView.showsHorizontalScrollIndicator = YES;
	
	//Lapi issue
	NSURL *url = [NSURL URLWithString:SERVER_URL];
	NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
	theWeb.delegate = self;
	[theWeb loadRequest:requestObj];
	theWeb.opaque = NO;
	theWeb.backgroundColor = [UIColor clearColor];
	[theWeb loadHTMLString:@"<html><body style='background-color: transparent'></body></html>" baseURL:nil];
	
	//secure password
	[[NSUserDefaults standardUserDefaults] setObject:USERNAME forKey:@"username"];
	[SFHFKeychainUtils storeUsername:USERNAME andPassword:PASSWORD forServiceName:@"MyService" updateExisting:YES error:nil];

	
	[self.view addSubview:theWeb];
	[self.view addSubview:table];
	[self.view sendSubviewToBack:theWeb];
	theDataObject.table = self.table;
	
	[self configureView];
	[self configureToolBar];
	
	table.frame = CGRectMake(TABLE_X, TABLE_Y, TABLE_W,TABLE_H);
	table.bounces = NO;
	[table reloadData];
	// ZY: alert for update the xml file or not
	[self alertForUpdate];
}


- (id)initWithTabBar 
{
	if (self = [super initWithNibName:@"CalendarViewController" bundle:nil]) 
	{
		SharedAppDataObject* theDataObject = [self theAppDataObject];
		self.title = @"Calendar";
		self.tabBarItem.image =[UIImage imageNamed:@"calendar.png"];
		self.navigationController.title = @"nav title";
		self.imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"timetable with days.png"]];
		self.imageView.frame =  CGRectMake(TIMETABLE_X,TIMETABLE_Y,TIMETABLE_W,TIMETABLE_H);
		self.imageView.multipleTouchEnabled = YES;
		self.imageView.userInteractionEnabled = YES;
		theDataObject.table = self.table;
		theDataObject.image = self.imageView;
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
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	return [theDataObject.tableChoices count]+1;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	SharedAppDataObject* theDataObject = [self theAppDataObject];

    NSString *CellIdentifier = [@"Cell" stringByAppendingFormat:@"%d",indexPath.row];
	if([theDataObject.tableChoices count]!=0)
	CellIdentifier = [CellIdentifier stringByAppendingString:[theDataObject.tableChoices objectAtIndex:[theDataObject.tableChoices count]-1]];
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    

	
    // Configure the cell...
	if([theDataObject.tableChoices count]==0)
	{
		cell.textLabel.text = @"Welcome to Use iPlan~~~";
		
		UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[addButton setTitle:@"Save" forState:UIControlStateNormal];
		[addButton setTitleColor: [UIColor blueColor] forState: UIControlStateNormal];
		CGRect frame = CGRectMake(0.0, 0.0, 60, 30);
		addButton.frame = frame;
		[addButton addTarget:self action:@selector(saveButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
		cell.accessoryView = addButton;
	}
	
	else
	{
		
		NSUInteger row = [indexPath row]-1;
		if(row!=-1&&row!=[theDataObject.tableChoices count]-1)
		cell.textLabel.text = [theDataObject.tableChoices objectAtIndex:row];
		
		
		
		//DISPLAY CLASH CHOICES
				
		//DISPLAY AVALIABLE SLOTS
		if([[theDataObject.tableChoices objectAtIndex:[theDataObject.tableChoices count]-1]isEqualToString:SLOTS])
		{
			if(row==-1)
			{	
				cell.textLabel.text = @"Other available slots";
				UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
				[addButton setTitle:@"Save" forState:UIControlStateNormal];
				[addButton setTitleColor: [UIColor blueColor] forState: UIControlStateNormal];
				CGRect frame = CGRectMake(0.0, 0.0, 60, 30);
				addButton.frame = frame;
				[addButton addTarget:self action:@selector(saveButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
				cell.accessoryView = addButton;
			}
			else if(row!=[theDataObject.tableChoices count]-1)
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
		
		else if([[theDataObject.tableChoices objectAtIndex:[theDataObject.tableChoices count]-1]isEqualToString:CLASH])
		{
			if(row==-1)
			{
				cell.textLabel.text = @"Select one From Overlapped Modules";
				UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
				[addButton setTitle:@"Save" forState:UIControlStateNormal];
				[addButton setTitleColor: [UIColor blueColor] forState: UIControlStateNormal];
				CGRect frame = CGRectMake(0.0, 0.0, 60, 30);
				addButton.frame = frame;
				[addButton addTarget:self action:@selector(saveButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
				cell.accessoryView = addButton;
			}

		}
			
	}
	
    return cell;
}


- (void) refreshButtonTapped:(id)sender event:(id)event
{
	SharedAppDataObject* theDataObject = [self theAppDataObject];

	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:table];
	NSIndexPath *indexPath = [table indexPathForRowAtPoint:currentTouchPosition];
	
	SlotViewController* select = [theDataObject.availableSlots objectAtIndex:indexPath.row-1];
	for(UIView* any in [imageView subviews])
	{
		[any removeFromSuperview];
	}
	
	//remove from slotviewcontrollers
	//remove previous selected
	NSMutableArray* rest = [[NSMutableArray alloc]init];

	printf("slot count before add in %d\n",[theDataObject.slotViewControllers count]);

	for (int i =0;i<[theDataObject.slotViewControllers count];i++) 
	{
		SlotViewController* slot = [theDataObject.slotViewControllers objectAtIndex:i];

		if([slot.moduleCode isEqual:select.moduleCode]&&[slot.classTypeName isEqual:select.classTypeName]);
		else
		{
			[rest addObject:slot];
		}
	}
	[theDataObject.slotViewControllers removeAllObjects];
	printf("slot after remove count %d\n",[theDataObject.slotViewControllers count]);
	[theDataObject.slotViewControllers addObjectsFromArray:rest];
	printf("rest count %d\n",[rest count]);
	printf("slot count after add in %d\n",[theDataObject.slotViewControllers count]);
		
	//add in new slots selected
	for(SlotViewController* slot in theDataObject.availableSlots)
	{
		if([slot.moduleCode isEqual:select.moduleCode]&&[slot.classTypeName isEqual:select.classTypeName]&&[slot.classGroupName isEqual:select.classGroupName])
		{
			[theDataObject.slotViewControllers addObject:slot];
		}
	}
	
	

	//refresh whole table to set to original color
	for(SlotViewController* slot in theDataObject.slotViewControllers)
	{
		[slot.view removeFromSuperview];
		[imageView addSubview:slot.view];
		slot.moduleColor = [[ModelLogic modelLogic]getModuleColorWithModuleCode:[slot moduleCode]];
		[slot setBackGroundColorWithCondition:NORMAL];
		[slot setLabelContentWithCondition:NORMAL];
		slot.view.multipleTouchEnabled = YES;
		slot.view.userInteractionEnabled = YES;
		[slot.view setFrame:[slot calculateDisplayProperty]];
	}
	
	//display clash
	for (int i=0;i<[theDataObject.slotViewControllers count];i++ ) 
	{
		SlotViewController* slot1 = [theDataObject.slotViewControllers objectAtIndex:i];
		BOOL clash = NO;
		BOOL manyModule = NO;
		
		for(int j=i+1;j<[theDataObject.slotViewControllers count];j++)
		{
			SlotViewController* slot2 = [theDataObject.slotViewControllers objectAtIndex:j];
			if([slot1.dayNumber intValue]==[slot2.dayNumber intValue])
			{
				if([slot1.startTime intValue]>=[slot2.endTime intValue]||[slot1.endTime intValue]<=[slot2.startTime intValue]);
				else 
				{
					if ([[slot1 frequency]intValue]&[[slot2 frequency]intValue])
					{
						manyModule = YES;
					}
					else
					{
						clash = YES;
					}
				}
			}
		}
		
		if(clash)
		{
			[slot1 setBackGroundColorWithCondition:CLASH];
			[slot1 setLabelContentWithCondition:CLASH];
			[theDataObject.image bringSubviewToFront:slot1.view];
		}
		else if(manyModule)
		{
			[slot1 setBackGroundColorWithCondition:AVAILABLE];
			[slot1 setLabelContentWithCondition:AVAILABLE];
			[theDataObject.image bringSubviewToFront:slot1.view];
		}
	}
	
	
	theDataObject.selectSlot = nil;
	[theDataObject.tableChoices removeAllObjects];
	[theDataObject.availableSlots removeAllObjects];
	[table reloadData];
 
}




- (void) saveButtonTapped:(id)sender event:(id)event
{
	AlertHelp *prompt = [AlertHelp alloc];
    prompt = [prompt initWithTitle:@"Save File Name" message:@"Please enter some text in" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Okay"];
    [prompt show];
    [prompt release];
}

- (void)getAvailableSlotsWithSlot:(SlotViewController*)slot
{
	SharedAppDataObject* theDataObject = [self theAppDataObject];

	[theDataObject.tableChoices removeAllObjects];
	[theDataObject.availableSlots removeAllObjects];
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
																   WithClassTypeName:typeName
																	   WithFrequency:[dictInner objectForKey:@"frequency"]];
			[theDataObject.availableSlots addObject:slot];
		}
	}
	
	for(int i=0;i<[theDataObject.availableSlots count];i++)
	{
		SlotViewController* slot = [theDataObject.availableSlots objectAtIndex:i];
		NSString* displayInfo = [NSString stringWithString:[slot moduleCode]];
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
		[theDataObject.tableChoices addObject:displayInfo];
	}
	
	if([theDataObject.availableSlots count]!=0)
		[theDataObject.tableChoices addObject:SLOTS];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	SharedAppDataObject* theDataObject = [self theAppDataObject];

	if([theDataObject.tableChoices count]!=0)
	{
		//Handle Available Slot
		if([[theDataObject.tableChoices objectAtIndex:[theDataObject.tableChoices count]-1]isEqualToString:SLOTS])
		{
			for(SlotViewController* slot in theDataObject.availableSlots)
			{
				[slot.view removeFromSuperview];
			}
			int row = indexPath.row-1;
			if(row!=-1)
			{
				SlotViewController* select = [theDataObject.availableSlots objectAtIndex:row];
				for(SlotViewController* slot in theDataObject.availableSlots)
				{
					if([slot.moduleCode isEqual:select.moduleCode]&&[slot.classTypeName isEqual:select.classTypeName]&&[slot.classGroupName isEqual:select.classGroupName])
					{
						[imageView addSubview:slot.view];
						slot.view.frame = [slot calculateDisplayProperty];
						[slot setBackGroundColorWithCondition:AVAILABLE];
						[slot setLabelContentWithCondition:NORMAL];
						[UIView beginAnimations:nil context:nil];
						[UIView setAnimationDuration:3];
						[slot.view setAlpha:0.2];
						[UIView commitAnimations];
						[UIView beginAnimations:nil context:nil];
						[UIView setAnimationDuration:3];
						[slot.view setAlpha:1];
						[UIView commitAnimations];
						[slot.view setAlpha:1];
					}
				}
			}
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
		else if([[theDataObject.tableChoices objectAtIndex:[theDataObject.tableChoices count]-1]isEqualToString:CLASH])
		{
			SlotViewController* slotSelect = [theDataObject selectSlot];
			int row = indexPath.row - 1;
			int count = 0;
			for (int i=0;i<[theDataObject.slotViewControllers count];i++) 
			{
				SlotViewController* slot = [theDataObject.slotViewControllers objectAtIndex:i];
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
			[table reloadData];
		
		}
		
	}
 }
//end of table view adjustment


#pragma mark -
#pragma mark web view for authentication
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType; {
	
    //save form data
	NSURL *url = [self.theWeb.request URL];
	NSLog(@"Check the host: %@", url.absoluteString);
    if(navigationType == UIWebViewNavigationTypeFormSubmitted) {
		NSLog(@"Navigation Confirmed" );
        //grab the data from the page
        NSString *username = @"U0807275";
        NSString *password = @"hq.nusinml128";
		
        //store values locally
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"UserID"];
        [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:@"MyService" updateExisting:YES error:nil];
		
    }    
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
	//can do nothing
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	
    //verify view is on the login page of the site (simplified)
    NSURL *requestURL = [self.theWeb.request URL];
	NSLog(@"Get returned host: %@", requestURL.absoluteString);
	if ([requestURL.absoluteString isEqualToString:@"https://ivle.nus.edu.sg/api/login/?apikey=K6vDt3tA51QC3gotLvPYf"]) {
		//try to auto fill the form and load
		NSString *loadUsernameJS = [NSString stringWithFormat:@"document.forms['frm'].userid.value ='%@'", USERNAME];
		NSString *password = [SFHFKeychainUtils getPasswordForUsername: USERNAME andServiceName:@"MyService" error:nil];
		NSString *loadPasswordJS = [NSString stringWithFormat:@"document.forms['frm'].password.value ='%@'", password];
		NSLog(@"password");
		
		//autofill the form
		[self.theWeb stringByEvaluatingJavaScriptFromString: loadUsernameJS];
		[self.theWeb stringByEvaluatingJavaScriptFromString: loadPasswordJS];
		
		NSString *clickLogin = [NSString stringWithFormat:@"document.forms['frm'].submit()"];
		
		[self.theWeb stringByEvaluatingJavaScriptFromString:clickLogin];
	}else if ([requestURL.absoluteString isEqualToString:@"https://ivle.nus.edu.sg/api/login/login_result.ashx?apikey=K6vDt3tA51QC3gotLvPYf&r=0"]) {
		NSString *webContent = [self.theWeb stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
		NSLog(@"Great!!!!!!!!!!!!! Token is %@", webContent);
		
		SharedAppDataObject* theDataObject = [self theAppDataObject];
		theDataObject.requestedToken = webContent;
    }
}




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
    [super dealloc];
}


@end
