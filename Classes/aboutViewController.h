//
//  aboutViewController.h
//  iPlan
//
//  Created by Zhao Cong on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController {
	UITextView *aboutTextView;
}

@property (nonatomic, retain) IBOutlet UITextView *aboutTextView;

@end
