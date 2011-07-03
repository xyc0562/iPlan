//
//  CalendarViewController.h
//  iPlan
//
//  Created by Zhang Ying on 6/21/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SlotViewController.h" //Temply disable to build

//CalendarView need first display Requirement Placing page, then proceed to time table

@interface CalendarViewController : UIViewController {
	IBOutlet UIScrollView* scrollView;
	NSMutableArray* displaySlots;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) NSMutableArray* displaySlots;

-(id)initWithTabBar;

@end