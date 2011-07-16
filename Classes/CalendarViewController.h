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


@interface CalendarViewController : UIViewController <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate,UIWebViewDelegate> {
	IBOutlet UIScrollView* scrollView;
	IBOutlet UITableView* table;
	IBOutlet UIWebView* theWeb;
	UIImageView* imageView;
	UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIWebView* theWeb;
@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

-(id)initWithTabBar;

@end
