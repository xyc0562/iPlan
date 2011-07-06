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

@implementation CalendarViewController

@synthesize scrollView;
@synthesize displaySlots;


- (SharedAppDataObject*) theAppDataObject{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

/*  //Temply disable to build
- (void) configureView {
	displaySlots = [[NSMutableArray alloc]init];
	SlotViewController* slotView = [[SlotViewController alloc]initWithModuleCode:@"MA1101" 
																	   WithVenue:@"Science" 
																   WithStartTime:[NSNumber numberWithInt:10] 
																	 WithEndTime:[NSNumber numberWithInt:12]
																		 WithDay:[NSNumber numberWithInt:1] 
															  WithClassGroupName:@"SL1" 
																 WithModuleColor:[UIColor blueColor]
																	WithProperty:CGRectMake(100, 100, 30, 50)];
	[displaySlots addObject:slotView];
	
	
	//for each slotView in displaySlots

	[scrollView setContentSize:CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
	for (int i = 0; i < NUMBER_OF_ROW_LINES; i++){
		UIViewWithLine *line = [[UIViewWithLine alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000) 
															 Point1X:HEADER_ORIGIN_X 
															 Point1Y:(HEADER_ORIGIN_Y+i*GAP_HEIGHT) 
															 Point2X:HEADER_ORIGIN_X+TOTAL_WIDTH 
															 Point2Y:(HEADER_ORIGIN_Y+i*GAP_HEIGHT)];
		[line setTag:LINE_TAG];
		[scrollView addSubview:line];
		[line release];
		if (i != NUMBER_OF_ROW_LINES -1){
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(HEADER_ORIGIN_X,(HEADER_ORIGIN_Y+i*GAP_HEIGHT), GAP_WIDTH, GAP_HEIGHT)];
			label.text = [NSString stringWithFormat:@"%d:00",i+8];
			label.textColor = [UIColor blueColor];
			label.backgroundColor = [UIColor clearColor];
			[label setTag:LABEL_TAG];
			[scrollView addSubview:label];
			[label release];			
		}
	}
	for (int i = 0; i < NUMBER_OF_COL_LINES; i++){
		UIViewWithLine *line = [[UIViewWithLine alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000) 
															 Point1X:(HEADER_ORIGIN_X+i*GAP_WIDTH)
															 Point1Y:HEADER_ORIGIN_Y
															 Point2X:(HEADER_ORIGIN_X+i*GAP_WIDTH) 
															 Point2Y:HEADER_ORIGIN_Y+TOTAL_HEIGHT];
		[line setTag:LINE_TAG];
		[scrollView addSubview:line];
		
		[line release];
	}
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	[tap setNumberOfTapsRequired:2];
	[scrollView addGestureRecognizer:tap];
	[tap release];
	
	for (SlotViewController* slotView in displaySlots ) 
	{
		[scrollView addSubview:slotView.view];
		[scrollView bringSubviewToFront:slotView.view];
	}
	
	
}

*/ 
 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//[self configureView]; //Temply disable to build
	self.view = scrollView;
}


- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
	// zoom in
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	if(![theDataObject zoomed])
	{
		[UIView beginAnimations:nil context:nil]; 
		[UIView setAnimationDuration:0.3]; 
		[scrollView setTransform:CGAffineTransformMakeScale(2.0, 2.0)];
		[UIView commitAnimations];
	}
	else 
	{
		[UIView beginAnimations:nil context:nil]; 
		[UIView setAnimationDuration:0.3]; 
		[scrollView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
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

- (id)initWithTabBar {
	if (self = [super initWithNibName:@"CalendarViewController" bundle:nil]) {
		self.title = @"Calendar";
		self.tabBarItem.image =[UIImage imageNamed:@"calendar.png"];
		self.navigationController.title = @"nav title";
	}
	return self;
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
	[scrollView release];
	[displaySlots release];
    [super dealloc];
}


@end
