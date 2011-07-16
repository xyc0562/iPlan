//
//  IVLEWebViewController.h
//  iPlan
//
//  Created by HQ on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IVLEWebViewController : UIViewController <UIWebViewDelegate>{
	IBOutlet UIWebView *ivlePageView;
}

@property (nonatomic, retain) IBOutlet UIWebView *ivlePageView;

@end
