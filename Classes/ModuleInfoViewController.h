//
//  ModuleInfoViewController.h
//  iPlan
//
//  Created by Zhao Cong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ModuleInfoViewController : UIViewController {
	NSString *moduleCode;
	UITextView *moduleDisplay;
}

@property (nonatomic, copy) NSString *moduleCode;
@property (nonatomic, retain) IBOutlet UITextView *moduleDisplay;

@end
