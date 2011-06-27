//
//  aboutViewController.h
//  iPlan
//
//  Created by Zhao Cong on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ABOUTMESSAGE @"Thanks!";

@interface aboutViewController : UIViewController {
	IBOutlet UITextView *aboutTextView;
	NSString *aboutMessage;
}

@property (nonatomic, retain) IBOutlet UITextView *aboutTextView;
@property (nonatomic, retain) NSString * aboutMessage;

@end
