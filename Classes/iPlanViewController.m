//
//  iPlanViewController.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import "iPlanViewController.h"
#import "SharedAppDataObject.h"
#import "AppDelegateProtocol.h"


#define SERVER_URL @"https://ivle.nus.edu.sg/api/login/?apikey=K6vDt3tA51QC3gotLvPYf"


@implementation iPlanViewController

@synthesize webView;

#pragma mark -
#pragma mark instance method

- (SharedAppDataObject*) theAppDataObject{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}


#pragma mark -
#pragma mark view life cycle


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad{
	NSURL *url = [NSURL URLWithString:SERVER_URL];
	
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	[webView loadRequest:requestObj];
	
	NSLog(@"compile iPlanViewController!");
}


#pragma mark -
#pragma mark web view delegate

- (void)webViewDidStartLoad:(UIWebView *)theWebView{
	NSLog(@"web view started!");
}

- (void) webViewDidFinishLoad:(UIWebView *)theWebView{
	NSLog(@"response received!");
	
	
	NSString *requestTokenUrl = [[NSString alloc] initWithString:theWebView.request.URL.absoluteString];
	
	NSLog(@"%@", requestTokenUrl);
	
	
	[requestTokenUrl release];
}

- (void)webView:(UIWebView *)theWebView didFailLoadWithError:(NSError *)error{
	
}

- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	return YES;
}


#pragma mark -
#pragma mark memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	webView.delegate = nil;
}


- (void)dealloc {
	[webView release];
    [super dealloc];
}

@end
