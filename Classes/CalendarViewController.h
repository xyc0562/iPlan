//
//  CalendarViewController.h
//  iPlan
//
//  Created by Zhang Ying on 6/21/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlotViewController.h"
#import "DisplayViewController.h"
#import "ControllerConstant.h"


@interface CalendarViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate,UITableViewDataSource> {
//#import "SlotViewController.h" //Temply disable to build
//CalendarView need first display Requirement Placing page, then proceed to time table

	IBOutlet UIScrollView* scrollView;
	IBOutlet UIToolbar* toolbar;
	IBOutlet UITableView* table;
	DisplayViewController* displayViewController;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) DisplayViewController* displayViewController;
@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic,retain)NSMutableArray* tableChoices;
-(id)initWithTabBar;

@end
