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
@interface CalendarViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIScrollView* scrollView;
	DisplayViewController* displayViewController;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) DisplayViewController* displayViewController;
-(id)initWithTabBar;

@end
