    //
//  SlotViewController.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-7-2.
//  Copyright 2011 NUS. All rights reserved.
//

#import "SlotViewController.h"
#import "ControllerConstant.h"
#import "SharedAppDataObject.h"
#import "AppDelegateProtocol.h"
#import <QuartzCore/QuartzCore.h>
#import "ControllerConstant.h"

@implementation SlotViewController

@synthesize moduleCode;
@synthesize venue;
@synthesize startTime;
@synthesize endTime;
@synthesize classGroupName;
@synthesize	moduleColor;
@synthesize dayNumber;
@synthesize displayProperty;
@synthesize classTypeName;
@synthesize available;

- (SharedAppDataObject*) theAppDataObject{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/
-(CGRect)calculateDisplayProperty
{
	float x,y,w,h;
	int dayNumberNumber = [dayNumber intValue];
	float startTimeNumber = [startTime intValue];
	int endTimeNumber = [endTime intValue];
	if(dayNumberNumber==1)
	{
		x = SLOT_FIRST_CELL_WIDTH;
		w = SLOT_MON_CELL_WIDTH;
	}
	else if(dayNumberNumber==2)
	{
		w = SLOT_TUE_CELL_WIDTH;
		x = SLOT_TUE_CELL_X;
	}
	else if(dayNumberNumber==3)
	{
		w = SLOT_WED_CELL_WIDTH;
		x = SLOT_WED_CELL_X;
	}
	else if(dayNumberNumber == 4)
	{
		w = SLOT_THU_CELL_WIDTH;
		x = SLOT_THU_CELL_X;
	}
	else if(dayNumberNumber == 5)
	{
		w = SLOT_FRI_CELL_WIDTH;
		x = SLOT_FRI_CELL_X;
	}
	y = SLOT_FIRST_CELL_HEIGHT+(startTimeNumber/100-8)*SLOT_NORMAL_CELL_HEIGHT;
	if(endTimeNumber%100==30)
		endTimeNumber = endTimeNumber+20;
	h = SLOT_NORMAL_CELL_HEIGHT*(endTimeNumber-startTimeNumber)/100;
	if(dayNumberNumber ==5)
	{
		w = w-6;
		x = x-2;
	}
	
	
	printf("slot %f %f %f %f\n",x,y,w,h);

	return CGRectMake(x,y,w,h);
}

- initWithModuleCode:(NSString *)code 
		   WithVenue:(NSString*)place
	   WithStartTime:(NSNumber*)start
		 WithEndTime:(NSNumber*)end
			 WithDay:(NSNumber*)date
  WithClassGroupName:(NSString*)name
	 WithModuleColor:(UIColor*)color
   WithClassTypeName:(NSString*)classtype

					
{
    self = [super init];
    if (self) 
	{
		self.moduleCode = code;
		self.venue = place;
		self.startTime = start;
		self.endTime = end;
		self.classGroupName = name;
		self.moduleColor = color;    
		self.dayNumber = date;
		self.classTypeName = classtype;
		self.view.multipleTouchEnabled = YES;
		self.view.userInteractionEnabled = YES;
		self.available = NO;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
		[self.view addGestureRecognizer:tap];
		[tap release];

		
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	CGRect frame = [self calculateDisplayProperty];
	self.view.layer.cornerRadius = 7.5;
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,frame.size.width	,frame.size.height )];
	label.text = classGroupName;
	label.backgroundColor = [UIColor clearColor];
	label.layer.cornerRadius = 3.5;
	[self.view addSubview:label];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer 
{
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	NSMutableArray* slotViewControllers = theDataObject.slotViewControllers;
	SlotViewController* slot = [theDataObject selectSlot];

	if(available)
	{
	}
	else 
	{
		for(int i=0;i<[theDataObject.availableSlots count];i++)
		{
			
			SlotViewController* slot = [theDataObject.availableSlots objectAtIndex:i];
			[slot.view removeFromSuperview];
		}
	}

	//restore selection
	if ([slot.moduleCode isEqual:moduleCode]&&[slot.classTypeName isEqual:classTypeName]&&[slot.classGroupName isEqual:classGroupName]) 
	{
		
		for(SlotViewController* slot in slotViewControllers)
		{
			slot.view.layer.borderColor = [UIColor clearColor].CGColor;
			slot.view.layer.borderWidth = 0.0f;
		}
		theDataObject.selectSlot = nil;
		[theDataObject.tableChoices removeAllObjects];
		[theDataObject.availableSlots removeAllObjects];
		
	}
	
	//selection start
	else
	{
		for(SlotViewController* slot in slotViewControllers)
		{
			if([slot.moduleCode isEqual:moduleCode]&&[slot.classTypeName isEqual:classTypeName]&&[slot.classGroupName isEqual:classGroupName])
			{
				slot.view.layer.borderColor = [UIColor blackColor].CGColor;
				slot.view.layer.borderWidth = 3.0f;
		
			}
			else 
			{
				slot.view.layer.borderColor = [UIColor clearColor].CGColor;
				slot.view.layer.borderWidth = 0.0f;
			}

		}
		
		[theDataObject.tableChoices removeAllObjects];
		
		//check for clashes
		for (SlotViewController* slot in slotViewControllers) 
		{
			if ([slot.dayNumber intValue]==[self.dayNumber intValue]&&slot!=self) 
			{
				if([slot.startTime intValue]>=[self.endTime intValue]||[slot.endTime intValue]<=[self.startTime intValue]);
				else 
				{
					NSString* displayInfo = [NSString stringWithString:slot.moduleCode];
					displayInfo = [displayInfo stringByAppendingString:@" "];
					displayInfo = [displayInfo stringByAppendingString:slot.classGroupName];
					[theDataObject.tableChoices addObject:displayInfo];
				}

			}
		}
		
		[theDataObject.availableSlots removeAllObjects];

		
		if([theDataObject.tableChoices count]>0)
		{
			NSString* displayInfo = [NSString stringWithString:self.moduleCode];
			displayInfo = [displayInfo stringByAppendingString:@" "];
			displayInfo = [displayInfo stringByAppendingString:self.classGroupName];
			[theDataObject.tableChoices addObject:displayInfo];
			[theDataObject.tableChoices addObject:CLASH];
		}
		

		else 
		{
			//call Model Logic
			NSMutableArray* availableAnswer = [[ModelLogic modelLogic] getOtherAvailableGroupsWithModuleCode:[self moduleCode]
																						  WithClassTypeIndex:[self classTypeName]
																							   WithGroupName:[self classGroupName]];
			printf("available ans %d\n",[availableAnswer count]);
		
			for (NSDictionary* dict in availableAnswer) 
			{
				NSString* code = [dict objectForKey:@"moduleCode"];
				UIColor* color = [dict objectForKey:@"color"];
				NSString* typeName = [dict objectForKey:@"classTypeName"];
				NSString* groupName = [dict objectForKey:@"classGroupName"];
				NSMutableArray* slots = [dict objectForKey:@"slots"];
				printf("available slots %d\n",[slots count]);
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
					slot.available = YES;
			

					[theDataObject.availableSlots addObject:slot ];
					[theDataObject.image addSubview:slot.view];
					[slot.view setFrame:[slot calculateDisplayProperty]];
					slot.view.layer.borderColor = [UIColor blackColor].CGColor;
					slot.view.layer.borderWidth = 2.0f;
					printf("available count %d\n",[theDataObject.availableSlots count]);
				}
			}
			
			
			
			for(int i=0;i<[theDataObject.availableSlots count];i++)
			{
				
				SlotViewController* slot = [theDataObject.availableSlots objectAtIndex:i];
				NSString* displayInfo = [NSString stringWithString:[slot moduleCode]];
				displayInfo = [displayInfo stringByAppendingString:@" "];
				printf("dayNumber %d\n",[[slot dayNumber]intValue]);
				displayInfo = [displayInfo stringByAppendingString:[NSString stringWithFormat:@"%d", [[slot dayNumber] intValue]]];
				displayInfo = [displayInfo stringByAppendingString:@" "];
				displayInfo = [displayInfo stringByAppendingString:[[slot startTime]stringValue]];
				displayInfo = [displayInfo stringByAppendingString:@"-"];
				displayInfo = [displayInfo stringByAppendingString:[[slot endTime]stringValue]];
				[theDataObject.tableChoices addObject:displayInfo];
			}
			
			if([theDataObject.tableChoices count]!=0)
				[theDataObject.tableChoices addObject:SLOTS];
			
		}

		theDataObject.selectSlot = self;
		
	}
	
	for (SlotViewController* slot1 in slotViewControllers ) 
	{
		for(SlotViewController* slot2 in slotViewControllers)
		{
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
		}
	}
	
	printf("before reload %d\n",[theDataObject.tableChoices count]);
	[theDataObject.table reloadData];
}
 

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];

    // Release any retained subviews of the main view.
}


- (void)dealloc {
    [super dealloc];
	[moduleCode dealloc];
	[venue dealloc];
	[classGroupName dealloc];
	[startTime dealloc];
	[endTime dealloc];
	[moduleColor dealloc];
	[dayNumber dealloc];
}


@end
