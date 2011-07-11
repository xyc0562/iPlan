//
//  iPlanAppDelegate.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import "iPlanAppDelegate.h"
#import "iPlanViewController.h"

#import "CalendarViewController.h"
#import "ModuleListViewController.h"
#import "SettingsViewController.h"

#import "ModuleXMLParser.h"
#import "ModelLogic.h"

#import "AppDelegateProtocol.h"
#import "SharedAppDataObject.h"

@implementation iPlanAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize tabBarController;
@synthesize theAppDataObject;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
   // [self.window addSubview:viewController.view];
   // [self.window makeKeyAndVisible];
/*    ModelLogic *ml = [[ModelLogic alloc] init];
    NSMutableArray *arr = (NSMutableArray*)[ml getModuleInfoIntoArray:@"AR4101"];

    NSLog(@"---start----");
    for (NSString *str in arr)
    {
        NSLog(@"%@\n", str);
    }
    NSLog(@"---end----");
*/
	
	NSLog(@"test for checking whether need update or not");
	// compare and save a new copy of cors.xml into your dir or not doing anything
	
	// get the xml from the web
	NSURL *url = [NSURL URLWithString:@"http://cors.i-cro.net/cors.xml"];
	NSData *dataFromWeb = [NSData dataWithContentsOfURL:url];  // Load XML data from web
	
	// construct path within our documents directory
	//NSString* currentDirectory = [[NSBundle mainBundle] bundlePath];
	//NSString *storePath = [NSString stringWithFormat:@"%@/cors.xml",currentDirectory];
	NSString *storePath = [[NSBundle mainBundle] pathForResource:@"cors" ofType:@"xml"];
	//NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	//NSString *storePath = [applicationDocumentsDir stringByAppendingPathComponent:@"cors.xml"];
	
	// get the xml from the file
	NSData *dataFromFile = [NSData dataWithContentsOfFile:storePath];
	if (dataFromWeb !=nil && ![dataFromWeb isEqualToData:dataFromFile]){
		// need to replace the old xml with new one and call parser
		// write to file atomically (using temp file)
		[dataFromWeb writeToFile:storePath atomically:TRUE];
		// tell the update available and need to parse again
		SharedAppDataObject* theDataObject = [self theAppDataObject];
		theDataObject.needUpdate = YES;
	}else {
		// don't need to replace
	}
	
	// for navigation bar
	UINavigationController *localNavigationController;
	
	// for tab bar controllers
	tabBarController = [[UITabBarController alloc] init];
	NSMutableArray *localControllerArray = [[NSMutableArray alloc] initWithCapacity:3];
	
	CalendarViewController* calendarController = [[CalendarViewController alloc] initWithTabBar];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:calendarController];
	[localControllerArray addObject:localNavigationController];
	[localNavigationController release];
	[calendarController release];
	
	ModuleListViewController* moduleController = [[ModuleListViewController alloc] initWithTabBar];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:moduleController];
	[localControllerArray addObject:localNavigationController];
	[localNavigationController release];
	[moduleController release];
	
	SettingsViewController* settingsController = [[SettingsViewController alloc] initWithTabBar];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsController];
	[localControllerArray addObject:localNavigationController];
	[localNavigationController release];
	[settingsController release];
	
	tabBarController.viewControllers = localControllerArray;
	[localControllerArray release];
	
	// Add the tab bar controller's current view as a subview of the window
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
/*
	printf("test algo\n");
	
	//Test for main Algo
	//intialize several modules
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentDirectory = [paths objectAtIndex:0];
	NSString *modulesDirectory= [[documentDirectory stringByAppendingString:@"/"] stringByAppendingString:MODULE_DOCUMENT_NAME];
	// Tell if plists directory exists, if not, create it
	NSFileManager * fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:modulesDirectory])
	{
		[fm createDirectoryAtPath:modulesDirectory withIntermediateDirectories:NO attributes:nil error:NULL];
	}
	


	NSMutableArray* moduleNameArray = [[NSMutableArray alloc]init];
	NSMutableArray* moduleArray = [[NSMutableArray alloc]init];
	[moduleNameArray addObject:@"EG1413"];
	[moduleNameArray addObject:@"EG2401"];
	[moduleNameArray addObject:@"HR2002"];
	
	[moduleNameArray addObject:@"MA2108"];
//	[moduleNameArray addObject:@"EE2006"];
//	[moduleNameArray addObject:@"EE2004"];
//	[moduleNameArray addObject:@"EE3304"];
//	[moduleNameArray addObject:@"EE2001"];

	
	
	for (NSString* eachModule in moduleNameArray)
	{
		NSString* filename = [eachModule stringByAppendingString:@".plist"];
		NSString*fullPath = [NSString stringWithFormat:@"%@/%@", modulesDirectory, filename];
		NSData*data = [NSData dataWithContentsOfFile:fullPath];
		NSKeyedUnarchiver* unarc = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		NSLog(@"%@\n",eachModule);
		Module* addModule = [unarc decodeObjectForKey:@"module"];
		addModule.selected = @"YES";
		[moduleArray addObject:addModule];
		[unarc finishDecoding];
		//[unarc release];
	}
	
	printf("modules added\n");


	
	printf("before timeTable init timetable\n");
	TimeTable* testTable = [[TimeTable alloc]initWithName:@"test" WithModules:moduleArray];
	printf("before planOneTimetable\n");
	[testTable planOneTimetable];
	printf("****************************************************\n");
	for(NSMutableArray* eachSelected in testTable.result)
	{
		//NSLog([[eachSelected objectAtIndex:1]stringValue]);
		NSLog([[eachSelected objectAtIndex:2] stringValue]);
		printf("Done\n");
	}
 */
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
      Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
      Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
      If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
    */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
      Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
    */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
      Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
      Called when the application is about to terminate.
      See also applicationDidEnterBackground:.
    */
}


#pragma mark -
#pragma mark Memory management

-(id) init{
	self.theAppDataObject = [[SharedAppDataObject alloc] init];
	[theAppDataObject release];
	return [super init];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
      Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
    */
}


- (void)dealloc {
    [tabBarController release];
    [viewController release];
    [window release];
	self.theAppDataObject = nil;
    [super dealloc];
}


@end
