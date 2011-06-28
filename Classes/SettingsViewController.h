//
//  SettingsViewController.h
//  iPlan
//
//  Created by Zhao Cong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *settingsTableView;
	NSArray *settingsList;
}

@property (nonatomic, retain) IBOutlet UITableView *settingsTableView;
@property (nonatomic, retain) NSArray *settingsList;

-(id)initWithTabBar;

@end
