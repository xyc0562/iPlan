//
//  CalendarViewController.h
//  iPlan
//
//  Created by Zhang Ying on 6/21/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>
<<<<<<< HEAD
#import "SlotViewController.h"
#import "DisplayViewController.h"
@interface CalendarViewController : UIViewController <UIScrollViewDelegate> {
=======
//#import "SlotViewController.h" //Temply disable to build

//CalendarView need first display Requirement Placing page, then proceed to time table

@interface CalendarViewController : UIViewController {
>>>>>>> 9ef4bf304493fc0f915c5ed7c2708c3299d4ae8f
	IBOutlet UIScrollView* scrollView;
	DisplayViewController* displayViewController;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) DisplayViewController* displayViewController;
-(id)initWithTabBar;

@end
