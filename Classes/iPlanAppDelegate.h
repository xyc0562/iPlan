//
//  iPlanAppDelegate.h
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iPlanViewController;

@interface iPlanAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iPlanViewController *viewController;
	UITabBarController *tabBarController;
	IBOutlet UINavigationController *navigationController;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iPlanViewController *viewController;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;


@end

