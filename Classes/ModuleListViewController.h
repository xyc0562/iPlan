//
//  ModuleListViewController.h
//  iPlan
//
//  Created by Zhao Cong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ModuleListViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate, UITabBarControllerDelegate> {
	UITableView *moduleListTableView;
	NSArray *moduleList;
	
	NSMutableArray *copyModuleList;
	IBOutlet UISearchBar *searchBar;
	NSIndexPath *pathForAlert;
	
}

@property (nonatomic, retain) IBOutlet UITableView *moduleListTableView;
@property (nonatomic, retain) NSArray *moduleList;
@property (nonatomic, retain) NSMutableArray *copyModuleList;
@property (nonatomic, retain) NSIndexPath *pathForAlert;
@property (nonatomic, assign) BOOL toRequirement;

- (id)initWithTabBar;

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;
//- (IBAction) Edit:(id)sender;
//- (IBAction) forwardToRequirement:(id)sender;

@end
