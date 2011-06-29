//
//  iPlanAppDelegate.h
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegateProtocol.h"

@class SharedAppDataObject;
@class iPlanViewController;

@interface iPlanAppDelegate : NSObject <UIApplicationDelegate, AppDelegateProtocol> {
    UIWindow *window;
    iPlanViewController *viewController;
	UITabBarController *tabBarController;
	
	SharedAppDataObject *theAppDataObject;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iPlanViewController *viewController;
@property (nonatomic, retain) UITabBarController *tabBarController;

@property (nonatomic, retain) SharedAppDataObject *theAppDataObject;

@end

