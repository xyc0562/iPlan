//
//  CalendarViewController.h
//  iPlan
//
//  Created by Zhang Ying on 6/21/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarViewController : UIViewController {
	IBOutlet UIScrollView* scrollView;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;

-(id)initWithTabBar;

@end
