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

@implementation SlotViewController

@synthesize moduleCode;
@synthesize venue;
@synthesize startTime;
@synthesize endTime;
@synthesize classGroupName;
@synthesize	moduleColor;
@synthesize day;
@synthesize displayProperty;
@synthesize scroll;
@synthesize displayView;
@synthesize index;
@synthesize groupIndex;
@synthesize tableChoices;
@synthesize table;


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

- (id)initWithModuleCode:(NSString *)code 
			   WithVenue:(NSString*)place
		   WithStartTime:(NSNumber*)start
			 WithEndTime:(NSNumber*)end
				 WithDay:(NSNumber*)date
	  WithClassGroupName:(NSString*)name
		 WithModuleColor:(UIColor*)color
			WithProperty:(CGRect)property
			   WithIndex:(int)indexNumber
		  WithGroupIndex:(int)groupNumber
					
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
		self.day = date;
		displayProperty = property;
		index = indexNumber;
		groupIndex = groupNumber;
		self.view.multipleTouchEnabled = YES;
		
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
	self.view.backgroundColor = moduleColor;
	self.view.frame = displayProperty;	
	self.view.layer.cornerRadius = 7.5;
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
	NSMutableArray* slotControllers = theDataObject.slotControllers;
	
	//restore selection
	if (theDataObject.selectSlotIndex == index) 
	{
		
		for(SlotViewController* slot in slotControllers)
		{
			//if(slot.groupIndex==groupIndex)
			//{
				slot.view.backgroundColor = [self moduleColor];		
			//}
		}
		theDataObject.selectSlotIndex = -1;
		
	}
	//selection start
	else
	{
		for(SlotViewController* slot in slotControllers)
		{
			if(slot.groupIndex==groupIndex)
			{
				slot.view.backgroundColor = [UIColor blackColor];		
			}
			else 
			{
				slot.view.backgroundColor = [slot moduleColor];
			}

		}
		
		//scroll.= YES;
		tableChoices = [[NSMutableArray alloc]init];
		for (SlotViewController* slot in slotControllers) 
		{
			if ([slot.day intValue]==[self.day intValue]) 
			{
				if([slot.startTime intValue]>=[self.endTime intValue]||[slot.endTime intValue]<=[self.startTime intValue]);
				else 
				{
					NSString* displayInfo = [NSString stringWithString:slot.moduleCode];
					displayInfo = [displayInfo stringByAppendingString:@" "];
					displayInfo = [displayInfo stringByAppendingString:slot.classGroupName];
					[tableChoices addObject:displayInfo];
				}

			}
		}
		
		if([tableChoices count]>0)
			[tableChoices addObject:CLASH];
		else 
		{
			//call Model Logic
			NSMutableArray* availableSlot;
			for(int i=0;i<[availableSlot count];i++)
			{
				NSString* displayInfo = [NSString stringWithString:@"module code"];
				[tableChoices addObject:displayInfo];
			}
			if([availableSlot count]!=0)
				[tableChoices addObject:SLOTS];
			
		}

		theDataObject.selectSlotIndex = index;
		
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
}


- (void)dealloc {
    [super dealloc];
	[scroll dealloc];
	[displayView dealloc];
	[moduleCode dealloc];
	[venue dealloc];
	[classGroupName dealloc];
	[startTime dealloc];
	[endTime dealloc];
	[moduleColor dealloc];
	[day dealloc];
}


@end
