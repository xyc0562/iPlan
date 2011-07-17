//
//  OptionViewController.m
//  iPlan
//
//  Created by Zhao Cong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OptionViewController.h"
#import "SharedAppDataObject.h"
#import "AppDelegateProtocol.h"
#import "ModelLogic.h"
#import	"LAPIStudentTimeTableToiCalExporter.h"


#define EXPORT_TO_ICAL_SUCCESS @"Thanks! Export calendar to iCal is successful!"
#define EXPORT_TO_ICAL_FAIL @"Sorry, can not connect server!"
#define SERVER_URL @"https://ivle.nus.edu.sg/api/login/?apikey=K6vDt3tA51QC3gotLvPYf"
#define EXPORT_TO_IVLE_SUCCESS @"Thanks! Export calendar to IVLE is successful!"
#define EXPORT_TO_IVLE_FAIL @"Sorry, can not connect server!"
#define API_KEY @"K6vDt3tA51QC3gotLvPYf"


@implementation OptionViewController

#pragma mark -
#pragma mark synthesize

@synthesize optionTableView;
@synthesize optionsList;
@synthesize switchEnabled;
@synthesize ivlePage;
@synthesize requestedToken;

#pragma mark -
#pragma mark instance methods

- (SharedAppDataObject*) theAppDataObject{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.allowsSelection = NO;
	
	ivlePage.delegate = self;
	
	optionsList = [[NSArray alloc] initWithObjects:@"Export IVLE to iCal", @"Delete IVLE timetable in iCal", @"Export to iCal", @"Delete timetable in iCal",@"Disable requirements", nil];
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [optionsList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *moduleListCellIdentifier = @"moduleListCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moduleListCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moduleListCellIdentifier] autorelease];
    }
	
    // Configure the cell...
    NSUInteger row = [indexPath row];
	NSString *optionName;
	
	optionName = [optionsList objectAtIndex:row];
	
	cell.textLabel.text = optionName;
	
	if (row == 3) {	
		SharedAppDataObject* theDataObject = [self theAppDataObject];
		theDataObject.requirementEnabled = NO;
		CGRect frameSwitch = CGRectMake(215.0, 10.0, 94.0, 27.0);
		switchEnabled = [[UISwitch alloc] initWithFrame:frameSwitch];
		switchEnabled.on = NO;
		[switchEnabled addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];		
		cell.accessoryView = switchEnabled;
	}else if(row == 0 || row == 1){
		UIButton *exportBUtton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
		CGRect frame = CGRectMake(215.0, 10.0, 94.0, 27.0);
		exportBUtton.frame = frame;
		[exportBUtton setTitle:@"Export" forState:UIControlStateNormal];
		[exportBUtton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
		if(row == 0)
			[exportBUtton addTarget:self action:@selector(exportFromIvle:event:) forControlEvents:UIControlEventTouchUpInside];
		else 
			[exportBUtton addTarget:self action:@selector(exportFromiPlan:event:) forControlEvents:UIControlEventTouchUpInside];
		cell.accessoryView = exportBUtton;
	}else if (row == 2) {
		UIButton *exportBUtton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
		CGRect frame = CGRectMake(215.0, 10.0, 94.0, 27.0);
		exportBUtton.frame = frame;
		[exportBUtton setTitle:@"Delete" forState:UIControlStateNormal];
		[exportBUtton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
		[exportBUtton addTarget:self action:@selector(deleteFromiPlan:event:) forControlEvents:UIControlEventTouchUpInside];
		cell.accessoryView = exportBUtton;
	}else {
		NSLog(@"No implementation yet!");
	}
    return cell;
}


- (void) exportFromIvle:(id)sender event:(id)event{
	NSInteger row = 0;
	[self tableView:optionTableView accessoryButtonTappedForRowWithIndexPath:row];
}

- (void) exportFromiPlan:(id)sender event:(id)event{
	NSInteger row = 1;
	[self tableView:optionTableView accessoryButtonTappedForRowWithIndexPath:row];
}

- (void) deleteFromiPlan:(id)sender event:(id)event{
	NSInteger row = 2;
	[self tableView:optionTableView accessoryButtonTappedForRowWithIndexPath:row];
}
 


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSInteger)row{
	NSLog(@"clicked row %d", row);
	if(row == 0){
		//Lapi issue
		NSURL *url = [NSURL URLWithString:SERVER_URL]; 	
		NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
		[ivlePage loadRequest:requestObj]; 
		[self.view  addSubview:ivlePage];
		[self.view bringSubviewToFront:ivlePage];
	}if(row == 1) {
		if ([[ModelLogic modelLogic] exportTimetableToiCalendar]) 
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:EXPORT_TO_ICAL_SUCCESS
														   delegate:self
												  cancelButtonTitle:@"Ok" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:EXPORT_TO_ICAL_FAIL
														   delegate:self
												  cancelButtonTitle:@"Ok" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}else if (row == 2) {
		if([[ModelLogic modelLogic] resetCalender]){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:EXPORT_TO_ICAL_SUCCESS
														   delegate:self
												  cancelButtonTitle:@"Ok" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:EXPORT_TO_ICAL_FAIL
														   delegate:self
												  cancelButtonTitle:@"Ok" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
}

- (void)switchToggled:(id)sender {
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	theDataObject.requirementEnabled = switchEnabled.on;
	//NSLog(switchEnabled.on?@"s:y":@"s:n");
}


#pragma mark -
#pragma mark web view for authentication

- (void)webViewDidStartLoad:(UIWebView *)webView{
	//can do nothing
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //verify view is on the login page of the site (simplified)
    NSURL *requestURL = [self.ivlePage.request URL];
	NSLog(@"The url is %@", requestURL);
	if ([requestURL.absoluteString isEqualToString:@"https://ivle.nus.edu.sg/api/login/login_result.ashx?apikey=K6vDt3tA51QC3gotLvPYf&r=0"]) {
		NSString *webContent = [self.ivlePage stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
		NSLog(@"Great!!!!!!!!!!!!! Token is %@", webContent);
		requestedToken = webContent;
		ivlePage.opaque = NO;
		ivlePage.backgroundColor = [UIColor clearColor];
		[ivlePage loadHTMLString:@"<html><body style='background-color: transparent'></body></html>" baseURL:nil];
		[self.view sendSubviewToBack:ivlePage];
		
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
			NSLog(@"No such such semester yet!");
		}
		
		NSLog(@"current time is %d, %d, %d", year, month, day);
		
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
		//do nothing
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
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    NSLog(@"Memory Warning in OptionViewController.m!");
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.optionTableView = nil;
	self.optionsList = nil;
	NSLog(@"Option ‰View Unload");
	[super viewDidUnload];
}


- (void)dealloc {
	[optionTableView release];
	[optionsList release];
	[switchEnabled release];
	[ivlePage release];
	[requestedToken release];
    [super dealloc];
}


@end

