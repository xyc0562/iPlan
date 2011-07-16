//
//  OptionViewController.h
//  iPlan
//
//  Created by Zhao Cong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OptionViewController : UITableViewController <UIWebViewDelegate>{
	IBOutlet UITableView *optionTableView;
	NSArray *optionsList;
	IBOutlet UIWebView *ivlePage;
	UISwitch *switchEnabled;
}

@property (nonatomic, retain) IBOutlet UITableView *optionTableView;
@property (nonatomic, retain) NSArray *optionsList;
@property (nonatomic, retain) IBOutlet UIWebView *ivlePage;
@property (nonatomic, retain) UISwitch *switchEnabled;

@end
