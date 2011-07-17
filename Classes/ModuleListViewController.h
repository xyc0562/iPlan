//
//  ModuleListViewController.h
//  iPlan
//
//  Created by Zhao Cong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ModuleListViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate> {
	UITableView *moduleListTableView;
	NSArray *moduleList;
	
	NSMutableArray *copyModuleList;
	IBOutlet UISearchBar *searchBar;
	NSIndexPath *pathForAlert;
	NSString *buttonTitle;
	UIBarButtonItem *addButton1;
}

@property (nonatomic, retain) IBOutlet UITableView *moduleListTableView;
@property (nonatomic, retain) NSArray *moduleList;
@property (nonatomic, retain) NSMutableArray *copyModuleList;
@property (nonatomic, retain) NSIndexPath *pathForAlert;
@property (nonatomic, assign) BOOL toRequirement;
@property (nonatomic, retain) NSString *buttonTitle;
@property (nonatomic, retain) UIBarButtonItem *addButton1;

- (id)initWithTabBar;

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

@end
