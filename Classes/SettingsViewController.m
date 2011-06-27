    //
//  SettingsViewController.m
//  iPlan
//
//  Created by Zhang Ying on 6/21/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import "SettingsViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "OptionViewController.h"

#define OPTION_NAME @"Option"
#define HELP_NAME @"Help"
#define ABOUT_NAME @"About"

@implementation SettingsViewController

//@synthesize settingsTableView;
@synthesize listData;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSArray *array = [[NSArray alloc] initWithObjects:@"Option", @"Help", @"About", nil];
	self.listData = array;
	[array release];
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (id)initWithTabBar {
	if (self = [super initWithNibName:@"SettingsViewController" bundle:nil]) {
		self.title = @"Settings";
		self.tabBarItem.image =[UIImage imageNamed:@"gear.png"];
		self.navigationController.title = @"nav title";
	}
	return self;
}

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
    [super dealloc];
}

#pragma mark -
#pragma make Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if(cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [listData objectAtIndex:row];
	
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *row_number = [NSString stringWithFormat:@"%d", indexPath.row];
	UIViewController *viewController;
	if([row_number isEqual:OPTION_NAME]){
		viewController = [[OptionViewController alloc] initWithNibName:@"OptionViewController" bundle:nil];
	}else if ([row_number isEqual:HELP_NAME]) {
		viewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
	}else if ([row_number isEqual:ABOUT_NAME]){
		viewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
	}else{
		printf("Error");
	}
	[[self navigationController] pushViewController:viewController animated:YES];
	[row_number release];
				
}

@end
