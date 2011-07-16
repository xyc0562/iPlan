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
	//self.tableView.allowsSelection = NO;
	
	ivlePage.delegate = self;
	
	optionsList = [[NSArray alloc] initWithObjects:@"Export to IVLE", @"Export to iCal", @"Disable requirements", nil];
	
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
	
	if (row == 2) {	
		SharedAppDataObject* theDataObject = [self theAppDataObject];
		theDataObject.requirementEnabled = NO;
		CGRect frameSwitch = CGRectMake(215.0, 10.0, 94.0, 27.0);
		switchEnabled = [[UISwitch alloc] initWithFrame:frameSwitch];
		switchEnabled.on = NO;
		[switchEnabled addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];		
		cell.accessoryView = switchEnabled;
	}else{
		UIButton *exportBUtton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
		CGRect frame = CGRectMake(215.0, 10.0, 94.0, 27.0);
		exportBUtton.frame = frame;
		[exportBUtton setTitle:@"Export" forState:UIControlStateNormal];
		[exportBUtton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
		[exportBUtton addTarget:self action:@selector(buttonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
		cell.accessoryView = exportBUtton;
	}
	
    return cell;
}


- (void) buttonTapped:(id)sender event:(id)event{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:optionTableView];
	NSIndexPath *indexPath = [optionTableView indexPathForRowAtPoint:currentTouchPosition];
	if(indexPath != nil){
		[self tableView:optionTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
	}
}
 


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = indexPath.row;
	//SharedAppDataObject* theDataObject = [self theAppDataObject];
	
	NSLog(@"clicked row %d", row);
	if(row == 0){
		//Lapi issue
		NSURL *url = [NSURL URLWithString:SERVER_URL]; 	
		NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url]; 	
		[ivlePage loadRequest:requestObj];    	
		[self.view  addSubview:ivlePage];
	}else if (row == 1) {
		if ([[ModelLogic modelLogic] exportTimetableToiCalendar]) 
		{
			//success
		}else 
		{
			//fail
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
	SharedAppDataObject *theAppDataObject = [self theAppDataObject];
    //verify view is on the login page of the site (simplified)
    NSURL *requestURL = [self.ivlePage.request URL];
	NSLog(@"The url is %@", requestURL);
	if ([requestURL.absoluteString isEqualToString:@"https://ivle.nus.edu.sg/api/login/login_result.ashx?apikey=K6vDt3tA51QC3gotLvPYf&r=0"]) {
		NSString *webContent = [self.ivlePage stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
		NSLog(@"Great!!!!!!!!!!!!! Token is %@", webContent);
		theAppDataObject.requestedToken = webContent;
		ivlePage.opaque = YES;
		ivlePage.backgroundColor = [UIColor	 clearColor];
		[ivlePage loadHTMLString:@"<html><body style='background-color: transparent'></body></html>" baseURL:nil];
		[self.view sendSubviewToBack:ivlePage];
		[self importIVLETimeTableAcadYear:@"2010/2011" Semester:@"4"];
		
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:EXPORT_TO_IVLE_SUCCESS
													   delegate:self
											  cancelButtonTitle:@"Ok" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
    }else if ([requestURL.absoluteString isEqualToString:@"https://ivle.nus.edu.sg/api/login/?apikey=K6vDt3tA51QC3gotLvPYf"]) {
		//do nothing
	}else{
		NSString *xml_file = [self.ivlePage stringByEvaluatingJavaScriptFromString:@"document.body"];
		
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
	[ivlePage loadRequest:requestObj];		
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
    [super dealloc];
}


@end

