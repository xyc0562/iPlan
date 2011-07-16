//
//  OptionViewController.h
//  iPlan
//
//  Created by Zhao Cong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OptionViewController : UITableViewController{
	IBOutlet UITableView *optionTableView;
	
	NSArray *optionsList;
	UISwitch *switchEnabled;
	UIButton *exportIVLEButton;
	UIButton *exportICALBUtton;
}

@property (nonatomic, retain) IBOutlet UITableView *optionTableView;
@property (nonatomic, retain) NSArray *optionsList;
@property (nonatomic, retain) UISwitch *switchEnabled;
@property (nonatomic, retain) UIButton *exportIVLEButton;
@property (nonatomic, retain) UIButton *exportICALBUtton;


@end
