    //
//  CalendarViewController.m
//  iPlan
//
//  Created by Zhang Ying on 6/21/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import "CalendarViewController.h"
#import "UIViewWithLine.h"

#define HEADER_ORIGIN_X 0
#define HEADER_ORIGIN_Y	40
#define NUMBER_OF_ROW_LINES 15
#define NUMBER_OF_COL_LINES 7
#define GAP_HEIGHT 30
#define GAP_WIDTH 50
#define TOTAL_HEIGHT (NUMBER_OF_ROW_LINES-1)*GAP_HEIGHT
#define TOTAL_WIDTH (NUMBER_OF_COL_LINES-1)*GAP_WIDTH
#define SCROLLVIEW_HEIGHT TOTAL_HEIGHT+HEADER_ORIGIN_Y
#define SCROLLVIEW_WIDTH TOTAL_WIDTH+HEADER_ORIGIN_X

#define LINE_TAG 100
#define CLASS_VIEW_TAG 200

@implementation CalendarViewController

@synthesize scrollView;

- (void) configureView {
	[scrollView setContentSize:CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
	for (int i = 0; i < 15; i++){
		UIViewWithLine *line = [[UIViewWithLine alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000) 
															 Point1X:HEADER_ORIGIN_X 
															 Point1Y:(HEADER_ORIGIN_Y+i*GAP_HEIGHT) 
															 Point2X:HEADER_ORIGIN_X+TOTAL_WIDTH 
															 Point2Y:(HEADER_ORIGIN_Y+i*GAP_HEIGHT)];
		[line setTag:LINE_TAG];
		[scrollView addSubview:line];
		[line release];
	}
	for (int i = 0; i < 15; i++){
		UIViewWithLine *line = [[UIViewWithLine alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000) 
															 Point1X:(HEADER_ORIGIN_X+i*GAP_WIDTH)
															 Point1Y:HEADER_ORIGIN_Y
															 Point2X:(HEADER_ORIGIN_X+i*GAP_WIDTH) 
															 Point2Y:HEADER_ORIGIN_Y+TOTAL_HEIGHT];
		[line setTag:LINE_TAG];
		[scrollView addSubview:line];
		[line release];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self configureView];
	self.view = scrollView;
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
    [super dealloc];
}


@end
