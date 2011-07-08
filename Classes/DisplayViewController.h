//
//  DisplayViewController.h
//  iPlan
//
//  Created by Yingbo Zhan on 11-7-7.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlotViewController.h"

@interface DisplayViewController : UIViewController {
	NSMutableArray* slotViewControllers;

}
@property (nonatomic,retain)NSMutableArray* slotViewControllers;

@end
