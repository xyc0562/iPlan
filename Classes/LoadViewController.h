//
//  LoadViewController.h
//  iPlan
//
//  Created by Yingbo Zhan on 11-7-16.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView* table;
	NSMutableArray* namelist;
}
@property (nonatomic,retain)NSMutableArray* namelist;
@property (nonatomic,retain)UITableView* table;

@end


