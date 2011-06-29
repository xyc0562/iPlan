//
//  ModuleListViewController.h
//  iPlan
//
//  Created by Zhao Cong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ModuleListViewController : UITableViewController {
	UITableView *moduleListTableView;
	NSArray *moduleList;
}

@property (nonatomic, retain) IBOutlet UITableView *moduleListTableView;
@property (nonatomic, retain) NSArray *moduleList;

- (id)initWithTabBar;

@end
