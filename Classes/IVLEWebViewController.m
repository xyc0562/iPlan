//
//  IVLEWebViewController.m
//  iPlan
//
//  Created by HQ on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IVLEWebViewController.h"
#import "SharedAppDataObject.h"
#import "AppDelegateProtocol.h"

#define SERVER_URL @"https://ivle.nus.edu.sg/api/login/?apikey=K6vDt3tA51QC3gotLvPYf"
#define EXPORT_TO_IVLE_SUCCESS @"Thanks! Export calendar to IVLE is successful!"
#define EXPORT_TO_IVLE_FAIL @"Sorry, can not connect server!"
#define API_KEY @"K6vDt3tA51QC3gotLvPYf"

@implementation IVLEWebViewController

@synthesize ivlePageView;


- (SharedAppDataObject*) theAppDataObject{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	ivlePageView.delegate = self;
	
	NSURL *url = [NSURL URLWithString:SERVER_URL];
	NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
	[ivlePageView loadRequest:requestObj];		
	[self.view	addSubview:ivlePageView];
}


#pragma mark -
#pragma mark web view for authentication

- (void)webViewDidStartLoad:(UIWebView *)webView{
	//can do nothing
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	SharedAppDataObject *theAppDataObject = [self theAppDataObject];
    //verify view is on the login page of the site (simplified)
    NSURL *requestURL = [self.ivlePageView.request URL];
	NSLog(@"The url is %@", requestURL);
	if ([requestURL.absoluteString isEqualToString:@"https://ivle.nus.edu.sg/api/login/login_result.ashx?apikey=K6vDt3tA51QC3gotLvPYf&r=0"]) {
		NSString *webContent = [self.ivlePageView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
		NSLog(@"Great!!!!!!!!!!!!! Token is %@", webContent);
		theAppDataObject.requestedToken = webContent;
		ivlePageView.opaque = YES;
		ivlePageView.backgroundColor = [UIColor	 clearColor];
		[ivlePageView loadHTMLString:@"<html><body style='background-color: transparent'></body></html>" baseURL:nil];
		[self.view sendSubviewToBack:ivlePageView];
		[self importIVLETimeTableAcadYear:@"2010/2011" Semester:@"2"];
		
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:EXPORT_TO_IVLE_SUCCESS
													   delegate:self
											  cancelButtonTitle:@"Ok" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
    }else if ([requestURL.absoluteString isEqualToString:@"https://ivle.nus.edu.sg/api/login/?apikey=K6vDt3tA51QC3gotLvPYf"]) {
		//do nothing
	}else{
		NSString *xml_file = [self.ivlePageView stringByEvaluatingJavaScriptFromString:@"document.body"];
		
		NSLog(@"The xml is %@", xml_file);
	}
}


- (void)importIVLETimeTableAcadYear:(NSString *)year Semester:(NSString *)semester{
	SharedAppDataObject *theAppDataObject = [self theAppDataObject];
	
	
	
	NSString *url_address = [[NSString alloc] initWithFormat:@"https://ivle.nus.edu.sg/api/Lapi.svc/Timetable_Student?APIKey=%@&AuthToken=%@&AcadYear=%@&Semester=%@",
							 API_KEY,
							 theAppDataObject.requestedToken,
							 year, semester];
	
	NSLog(@"Request url for xml is : %@", url_address);
	
	NSURL *url = [NSURL URLWithString:url_address];
	NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
	[ivlePageView loadRequest:requestObj];		
}

#pragma mark -
#pragma mark memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}



- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	ivlePageView.delegate = nil;
	
}


- (void)dealloc {
	[ivlePageView release];
    [super dealloc];
}


@end
