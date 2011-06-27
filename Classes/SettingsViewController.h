//
//  SettingsViewController.h
//  iPlan
//
//  Created by Zhang Ying on 6/21/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	//IBOutlet UITableView *settingsTableView;
	NSArray *listData;
}

//@property (nonatomic, retain) IBOutlet UITableView *settingsTableView;
@property (nonatomic, retain) NSArray *listData;

-(id)initWithTabBar;

@end
