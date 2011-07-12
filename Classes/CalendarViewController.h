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


@interface CalendarViewController : UIViewController <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UIScrollView* scrollView;
	IBOutlet UITableView* table;
	IBOutlet UIWebView* theWeb;
	DisplayViewController* displayViewController;
	NSMutableArray* slotViewControllers;
	UIImageView* imageView;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIWebView* theWeb;
@property (nonatomic, retain) DisplayViewController* displayViewController;
@property (nonatomic, retain) NSMutableArray* slotViewControllers;
@property (nonatomic, retain) NSMutableArray* tableChoices;
@property (nonatomic, retain) NSMutableArray* availableSlots;
@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) UIImageView* imageView;

-(id)initWithTabBar;

@end
