//
//  HelpViewController.h
//  iPlan
//
//  Created by Zhao Cong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//This is actually controller for both Help and About option


#import <UIKit/UIKit.h>


@interface HelpViewController : UIViewController {
	UITextView *helpTextView;
}

@property (nonatomic, retain) IBOutlet UITextView *helpTextView;

@end
