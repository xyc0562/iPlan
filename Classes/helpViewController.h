//
//  helpViewController.h
//  iPlan
//
//  Created by Zhao Cong on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HELPMESSAGE @"If you need help, please Call Zhan Yin Bo~~";

@interface HelpViewController : UIViewController {
	IBOutlet UITextView *helpTextView;
	NSString *helpMessage;
}

@property (nonatomic, retain) IBOutlet UITextView *helpTextView;
@property (nonatomic, retain) NSString *helpMessage;

@end
