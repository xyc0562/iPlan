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

@interface CalendarViewController (UtilityMethods)

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation CalendarViewController

@synthesize scrollView;
@synthesize displayViewController;


- (SharedAppDataObject*) theAppDataObject{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}
- (void) configureView {
	displayViewController = [[DisplayViewController alloc]init];
	NSMutableArray* displaySlots = displayViewController.slotViewControllers;
	SlotViewController* slotView = [[SlotViewController alloc]initWithModuleCode:@"MA1101" 
																	   WithVenue:@"Science" 
																   WithStartTime:[NSNumber numberWithInt:10] 
																	 WithEndTime:[NSNumber numberWithInt:12]
																		 WithDay:[NSNumber numberWithInt:1] 
															  WithClassGroupName:@"SL1" 
																 WithModuleColor:[UIColor blueColor]
																	WithProperty:CGRectMake(100, 100, 50, 20)];
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
		[[displayViewController view]addSubview:line];
		[line release];
		if (i != NUMBER_OF_ROW_LINES -1){
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(HEADER_ORIGIN_X,(HEADER_ORIGIN_Y+i*GAP_HEIGHT), GAP_WIDTH, GAP_HEIGHT)];
			label.text = [NSString stringWithFormat:@"%d:00",i+8];
			label.textColor = [UIColor blueColor];
			label.backgroundColor = [UIColor clearColor];
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
															 Point2Y:HEADER_ORIGIN_Y+TOTAL_HEIGHT];
		[line setTag:LINE_TAG];
		[[displayViewController view] addSubview:line];
		
		[line release];
	}
	
	UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	[tap2 setNumberOfTapsRequired:2];
	[scrollView addGestureRecognizer:tap2];
	[tap2 release];
	
	for (SlotViewController* slotView in displaySlots ) 
	{
		[[displayViewController view] addSubview:slotView.view];
		[[displayViewController view] bringSubviewToFront:slotView.view];
		slotView.scroll = scrollView;
		slotView.displayView = [displayViewController view];
	}
	
	
	
	[scrollView setCenter:CGPointMake(SCROLL_BEFORE_ZOOM_X, SCROLL_BEFORE_ZOOM_Y)];
	[scrollView addSubview:[displayViewController view]];
	[[displayViewController view]setCenter:scrollView.center];
	[[displayViewController view]setTag:DISPLAY_TAG];
	scrollView.canCancelContentTouches = YES;

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self configureView];
	self.view = scrollView;
	scrollView.bounces = NO;
	scrollView.showsVerticalScrollIndicator = YES;
	scrollView.showsHorizontalScrollIndicator = YES;
	[scrollView setTag:SCROLL_TAG];
}


- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
	
	
	
	// zoom in
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	if(![theDataObject zoomed])
	{
		//[UIView beginAnimations:nil context:nil]; 
		//[UIView setAnimationDuration:0.3]; 
		[[displayViewController view]removeFromSuperview];
		[[displayViewController view]setTransform:CGAffineTransformMakeScale(2.0, 2.0)];
		
		[scrollView setContentSize:CGSizeMake(SCROLLVIEW_WIDTH_ZOOM, SCROLLVIEW_HEIGHT_ZOOM)];
		[scrollView setContentOffset:CGPointMake(0, 0)];
		[scrollView addSubview:[displayViewController view]];
		//[[displayViewController view] setCenter:CGPointMake(SCROLL_AFTER_ZOOM_X, SCROLL_AFTER_ZOOM_Y)];

		//[UIView commitAnimations];
		
	}
	else 
	{
		//[UIView beginAnimations:nil context:nil]; 
		//[UIView setAnimationDuration:0.3]; 
		[[displayViewController view]removeFromSuperview];
		[[displayViewController view]setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
		[scrollView setContentSize:CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
		[scrollView setContentOffset:CGPointMake(0, 0)];
		[scrollView addSubview:[displayViewController view]];
		//[[displayViewController view] setCenter:CGPointMake(SCROLL_BEFORE_ZOOM_X, SCROLL_BEFORE_ZOOM_Y)];
	
		
		
		
		//[UIView commitAnimations];
		//[scrollView setContentSize:CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];

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
	[displayViewController release];
    [super dealloc];
}


@end
