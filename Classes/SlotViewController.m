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
@synthesize conflictModuleChoice;

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
	if (theDataObject.selectSlotIndex == index) 
	{
		
		for(SlotViewController* slot in slotControllers)
		{
			if(slot.groupIndex==groupIndex)
			{
				slot.view.backgroundColor = [self moduleColor];		
			}
		}
		theDataObject.selectSlotIndex = -1;
		
	}
	else
	{
		for(SlotViewController* slot in slotControllers)
		{
			if(slot.groupIndex==groupIndex)
			{
				slot.view.backgroundColor = [UIColor blackColor];		
			}
		}
		
		//scroll.= YES;
		conflictModuleChoice = [[NSMutableArray alloc]init];
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
					[conflictModuleChoice addObject:displayInfo];
				}

			}
		}
		
		if([conflictModuleChoice count]>1)
		{
			UIPickerView* smallPicker = [[UIPickerView alloc]init];
			//smallPicker.bounds = CGRectMake(0, 0, 20, 20);
			smallPicker.delegate = self;
			smallPicker.backgroundColor = [UIColor clearColor];
			smallPicker.showsSelectionIndicator = YES;
			[displayView addSubview:smallPicker];
		}
		
		theDataObject.selectSlotIndex = index;
		
	}
	
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
	[pickerView removeFromSuperview];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = [conflictModuleChoice count];
	
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    title = [conflictModuleChoice objectAtIndex:row];
	
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	int sectionWidth = 300;
	
	return sectionWidth;
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
