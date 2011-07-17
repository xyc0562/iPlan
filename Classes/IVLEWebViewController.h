//
//  IVLEWebViewController.h
//  iPlan
//
//  Created by HQ on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IVLEWebViewController : UIViewController <UIWebViewDelegate>{
	IBOutlet UIWebView *ivlePage;
	IBOutlet UITextView *displayText;
	NSString *requestedToken;
}

@property (nonatomic, retain) IBOutlet UIWebView *ivlePage;
@property (nonatomic, retain) IBOutlet UITextView *displayText;
@property (nonatomic, retain) NSString *requestedToken;


- (void)importIVLETimeTableAcadYear:(NSString *)year Semester:(NSString *)semester;

@end
