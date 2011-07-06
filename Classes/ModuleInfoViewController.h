//
//  ModuleInfoViewController.h
//  iPlan
//
//  Created by Zhao Cong on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ModuleInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
	IBOutlet UITableView *moduleInfoTableView;
	NSArray *infoList;
	NSInteger selectedIndex;

}

@property (nonatomic, retain) IBOutlet UITableView *moduleInfoTableView;
@property (nonatomic, retain) NSArray *infoList;
@property (nonatomic) NSInteger selectedIndex;



@end
