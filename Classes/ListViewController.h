//
//  ListViewController.h
//  iPlan
//
//  Created by Yingbo Zhan on 11-7-16.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SharedAppDataObject.h"
#import "AppDelegateProtocol.h"


@interface ListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView* table;
	NSMutableArray* newSlotViewControllers;
}
@property (nonatomic, retain)NSMutableArray* newSlotViewControllers;
@end
