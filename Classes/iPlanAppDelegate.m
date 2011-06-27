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


@implementation iPlanAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
   // [self.window addSubview:viewController.view];
   // [self.window makeKeyAndVisible];

	// for navigation bar
	UINavigationController *localNavigationController;
	
	// for tab bar controllers
	
	ModuleXMLParser *aParser = [[ModuleXMLParser alloc] initWithURLStringAndParse:@"http://cors.i-cro.net/cors.xml"];	[aParser release];
		
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
	
	NSString* filename = @"MA4255";
	filename = [filename stringByAppendingString:@".plist"];
	NSString* fullPath = [NSString stringWithFormat:@"%@/%@", modulesDirectory, filename];
	NSMutableData* data = [NSData dataWithContentsOfFile:fullPath];
	NSKeyedUnarchiver* unarc = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	printf("construct module ma4255\n");
	Module* ma4255 = [unarc decodeObjectForKey:@"module"];
	[unarc finishDecoding];
	// [unarc release];
	
	
	filename = @"MA2101";
	filename = [filename stringByAppendingString:@".plist"];
	fullPath = [NSString stringWithFormat:@"%@/%@", modulesDirectory, filename];
	data = [NSData dataWithContentsOfFile:fullPath];
	unarc = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	printf("construct module ma2101\n");
	Module* ma2101 = [unarc decodeObjectForKey:@"module"];
	[unarc finishDecoding];
	// [unarc release];
	
	filename = @"CS2103";
	filename = [filename stringByAppendingString:@".plist"];
	fullPath = [NSString stringWithFormat:@"%@/%@", modulesDirectory, filename];
	data = [NSData dataWithContentsOfFile:fullPath];
	unarc = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	printf("construct module cs2103\n");
	Module* cs2103 = [unarc decodeObjectForKey:@"module"];
	[unarc finishDecoding];
	//[unarc release];
	
	filename = @"EE2006";
	filename = [filename stringByAppendingString:@".plist"];
	fullPath = [NSString stringWithFormat:@"%@/%@", modulesDirectory, filename];
	data = [NSData dataWithContentsOfFile:fullPath];
	unarc = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	printf("construct module ee2006\n");
	Module* ee2006 = [unarc decodeObjectForKey:@"module"];
	[unarc finishDecoding];
	//[unarc release];
	
	NSMutableArray* moduleSample = [[NSMutableArray alloc]init];
	[moduleSample addObject:ma4255];
	[moduleSample addObject:ma2101];
	[moduleSample addObject:cs2103];
	[moduleSample addObject:ee2006];
	
	printf("modules added\n");
	ma4255.selected = @"YES";
	ma2101.selected = @"YES";
	cs2103.selected = @"NO";
	ee2006.selected = @"YES";

	//!!!!bug: no active module
	
	printf("before timeTable init timetable\n");
	TimeTable* testTable = [[TimeTable alloc]initWithName:@"test" WithModules:moduleSample];
	printf("before planOneTimetable\n");
	NSMutableArray* result = [testTable planOneTimetable];
	printf("****************************************************\n");
	printf("%d result found\n",[result count]);
	for(NSMutableArray* eachSelected in result)
	{
		for(NSNumber* info in eachSelected)
			printf("%d    " ,[info intValue]);
		printf("\n");
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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
      Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
    */
}


- (void)dealloc {
    [tabBarController release];
    [viewController release];
    [window release];
    [super dealloc];
}


@end
