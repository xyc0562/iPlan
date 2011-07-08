//
//  SlotViewController.h
//  iPlan
//
//  Created by Yingbo Zhan on 11-7-2.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SlotViewController : UIViewController {
	NSString* moduleCode;
	NSString* venue;
	NSString* classGroupName;
	NSNumber* startTime;
	NSNumber* endTime;
	NSNumber* day;
	UIColor* moduleColor;
	CGRect displayProperty;
	BOOL selected;
	
}

@property (nonatomic,retain)NSString* moduleCode;
@property (nonatomic,retain)NSString* venue;
@property (nonatomic,retain)NSString* classGroupName;
@property (nonatomic,retain)NSNumber* startTime;
@property (nonatomic,retain)NSNumber* endTime;
@property (nonatomic,retain)UIColor* moduleColor;
@property (nonatomic,retain)NSNumber* day;
@property (nonatomic,readonly)CGRect displayProperty;
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,retain)UIScrollView* scroll;
@property (nonatomic,retain)UIView* displayView;

- (id)initWithModuleCode:(NSString *)code 
			   WithVenue:(NSString*)place
		   WithStartTime:(NSNumber*)start
			 WithEndTime:(NSNumber*)end
				 WithDay:(NSNumber*)date
	  WithClassGroupName:(NSString*)name
		 WithModuleColor:(UIColor*)color
				WithProperty:(CGRect)property;

@end
