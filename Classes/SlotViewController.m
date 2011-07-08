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
@synthesize selected;
@synthesize scroll;
@synthesize displayView;

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
		selected = NO;
		self.view.multipleTouchEnabled = YES;
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
		[self.view addGestureRecognizer:tap];
		[tap release];
		
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
		[self.view addGestureRecognizer:pan];
		[pan release];
		
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
	// zoom in
	if (selected) 
	{
		self.view.backgroundColor = moduleColor;
		scroll.scrollEnabled = YES;
		printf("center before selected %f %f\n",self.view.center.x,self.view.center.y);
		CGPoint center = self.view.center;
		[self.view	removeFromSuperview];
		[displayView addSubview:self.view];
		printf("center After selected %f %f\n",self.view.center.x,self.view.center.y);
		printf("scroll center %f %f\n",scroll.center.x,scroll.center.y);
		printf("disply center %f %f\n",displayView.center.x,displayView.center.y);
	}
	else
	{
		self.view.backgroundColor = [UIColor blackColor];
		scroll.scrollEnabled = NO;
		[self.view removeFromSuperview];
		[scroll addSubview:self.view];
	}
	selected = !selected;
}

- (void)handlePan:(UIGestureRecognizer *)gestureRecognizer
{
	if(!selected)
		self.view.backgroundColor = [UIColor blackColor];
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	

	if([theDataObject zoomed])
	{
		[displayView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
		[scroll setContentSize:CGSizeMake(SCROLLVIEW_WIDTH_ZOOM, SCROLLVIEW_HEIGHT_ZOOM)];
		[displayView setCenter:CGPointMake(SCROLL_BEFORE_ZOOM_X, SCROLL_BEFORE_ZOOM_Y)];
		theDataObject.zoomed = !theDataObject.zoomed;
	}
	
	UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *) gestureRecognizer;
	UIView *view = panGesture.view;
	
	if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) 
	{
		CGPoint translation = [panGesture translationInView:view.superview];
		[panGesture setTranslation:translation inView:view.superview];
		view.transform = CGAffineTransformMakeTranslation(translation.x, translation.y);
	}
	else if([gestureRecognizer state] == UIGestureRecognizerStateEnded)
	{
		selected = NO;
		self.view.backgroundColor = moduleColor;
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
