//
//  IVLEWebViewController.m
//  iPlan
//
//  Created by HQ on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IVLEWebViewController.h"
#import	"LAPIStudentTimeTableToiCalExporter.h"

#define EXPORT_TO_ICAL_SUCCESS @"Thanks! Export calendar to iCal is successful!"
#define EXPORT_TO_ICAL_FAIL @"Sorry, can not connect server!"
#define SERVER_URL @"https://ivle.nus.edu.sg/api/login/?apikey=K6vDt3tA51QC3gotLvPYf"
#define EXPORT_TO_IVLE_SUCCESS @"Thanks! Export calendar to IVLE is successful!"
#define EXPORT_TO_IVLE_FAIL @"Sorry, can not connect server!"
#define API_KEY @"K6vDt3tA51QC3gotLvPYf"

#define USERNAME @"u0602684"
#define PASSWORD @"tomrlq#04"


@implementation IVLEWebViewController


@synthesize ivlePage;
@synthesize displayText;
@synthesize requestedToken;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"IVLE";
	
	//Lapi issue
	ivlePage.delegate = self;
	NSURL *url = [NSURL URLWithString:SERVER_URL]; 	
	NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
	[ivlePage loadRequest:requestObj]; 
	
	displayText.text = @"You may now go back!";
	
	[self.view addSubview:displayText];
	[self.view  addSubview:ivlePage];
	[self.view sendSubviewToBack:displayText];
}





#pragma mark -
#pragma mark web view for authentication

- (void)webViewDidStartLoad:(UIWebView *)webView{
	//can do nothing
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //verify view is on the login page of the site (simplified)
    NSURL *requestURL = [self.ivlePage.request URL];
	//NSLog(@"The url is %@", requestURL);
	if ([requestURL.absoluteString isEqualToString:@"https://ivle.nus.edu.sg/api/login/login_result.ashx?apikey=K6vDt3tA51QC3gotLvPYf&r=0"]) {
		NSString *webContent = [self.ivlePage stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
		//NSLog(@"Great!!!!!!!!!!!!! Token is %@", webContent);
		requestedToken = webContent;
		ivlePage.opaque = NO;
		ivlePage.backgroundColor = [UIColor clearColor];
		[ivlePage loadHTMLString:@"<html><body style='background-color: transparent'></body></html>" baseURL:nil];
		[self.view sendSubviewToBack:ivlePage];
		
		NSString *loadUsernameJS = [NSString stringWithFormat:@"document.forms['frm'].userid.value ='%@'", USERNAME];
		NSString *loadPasswordJS = [NSString stringWithFormat:@"document.forms['frm'].password.value ='%@'", PASSWORD];
		
		[self.ivlePage stringByEvaluatingJavaScriptFromString: loadPasswordJS];
		
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		
		NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit| NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
		
		NSDate *date = [NSDate date];
		
		NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
		
		NSInteger year = [dateComponents year];
		NSInteger month = [dateComponents month];
		NSInteger day = [dateComponents day];
		
		
		NSString *acadYear;
		NSString *semester;
		if (month < 5 || (month == 5 && day <= 10)) {
			acadYear = [[NSString alloc] initWithFormat:@"%d/%d", year-1, year];
			semester = [[NSString alloc] initWithString:@"2"];
		}else if (month > 8 || (month == 8 && day >= 10)) {
			acadYear = [[NSString alloc] initWithFormat:@"%d/%d", year, year+1];
			semester = [[NSString alloc] initWithString:@"1"];
		}else if ((month == 5 && day >10) || (month == 6 && day < 18)) {
			acadYear = [[NSString alloc] initWithFormat:@"%d/%d", year-1, year];
			semester = [[NSString alloc] initWithString:@"3"];
		}else if ((month == 6 && day >20) || (month == 7 && day < 30)) {
			acadYear = [[NSString alloc] initWithFormat:@"%d/%d", year-1, year];
			semester = [[NSString alloc] initWithString:@"4"];
		}else{
			//NSLog(@"No such such semester yet!");
		}
		
		//NSLog(@"current time is %d, %d, %d", year, month, day);
		
		[self importIVLETimeTableAcadYear:acadYear Semester:semester];
		
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:EXPORT_TO_IVLE_SUCCESS
													   delegate:self
											  cancelButtonTitle:@"Ok" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		[acadYear release];
		[semester release];
    }else if ([requestURL.absoluteString isEqualToString:@"https://ivle.nus.edu.sg/api/login/?apikey=K6vDt3tA51QC3gotLvPYf"]) {
		NSString *loadUsernameJS = [NSString stringWithFormat:@"document.forms['frm'].userid.value ='%@'", USERNAME];
		NSString *loadPasswordJS = [NSString stringWithFormat:@"document.forms['frm'].password.value ='%@'", PASSWORD];

		
		//autofill the form
		[self.ivlePage stringByEvaluatingJavaScriptFromString: loadUsernameJS];
		[self.ivlePage stringByEvaluatingJavaScriptFromString: loadPasswordJS];
	}
	/*else{ 
	 NSString *xml_file = [self.ivlePage stringByEvaluatingJavaScriptFromString:@"document.getElementById"];
	 
	 NSLog(@"The xml is %@", xml_file);
	 }*/
}


- (void)importIVLETimeTableAcadYear:(NSString *)year Semester:(NSString *)semester{	
	NSString *url_address = [[NSString alloc] initWithFormat:@"https://ivle.nus.edu.sg/api/Lapi.svc/Timetable_Student?APIKey=%@&AuthToken=%@&AcadYear=%@&Semester=%@",
							 API_KEY,
							 requestedToken,
							 year, semester];
	
	NSURL *url = [NSURL URLWithString:url_address];
	//NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
	//[ivlePage loadRequest:requestObj];		
	NSLog(@"Trying to caccess api");
	
	NSData *xml_data = [[NSData alloc] initWithContentsOfURL:url];
	
	LAPIStudentTimeTableToiCalExporter *exporter = [[LAPIStudentTimeTableToiCalExporter alloc] initWithNSDataParseAndExport:xml_data];
	
	[url_address release];
	[xml_data release];
	[exporter release];
	
	/*
	 if ([xml_data writeToFile:@"timetable.xml" atomically:YES]) {
	 NSLog(@"Write timetable data to file successfully!");
	 
	 
	 }else{
	 NSLog(@"Writing timetable to file failed!");
	 }*/
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
}


- (void)dealloc {
	[ivlePage release];
	[displayText release];
	[requestedToken release];
    [super dealloc];
}


@end
