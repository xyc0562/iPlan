//
//  SlotViewController.h
//  iPlan
//
//  Created by Yingbo Zhan on 11-7-2.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelLogic.h"

@interface SlotViewController : UIViewController {
	NSString* moduleCode;
	NSString* venue;
	NSString* classGroupName;
	NSNumber* startTime;
	NSNumber* endTime;
	NSNumber* dayNumber;
	NSString* classTypeName;
	UIColor* moduleColor;
	CGRect displayProperty;
	BOOL available;
}

@property (nonatomic,retain)NSString* moduleCode;
@property (nonatomic,retain)NSString* venue;
@property (nonatomic,retain)NSString* classGroupName;
@property (nonatomic,retain)NSNumber* startTime;
@property (nonatomic,retain)NSNumber* endTime;
@property (nonatomic,retain)UIColor* moduleColor;
@property (nonatomic,retain)NSNumber* dayNumber;
@property (nonatomic,readonly)CGRect displayProperty;
@property (nonatomic,retain)NSString* classTypeName;
@property (nonatomic,assign)BOOL available;


- (id)initWithModuleCode:(NSString *)code 
			   WithVenue:(NSString*)place
		   WithStartTime:(NSNumber*)start
			 WithEndTime:(NSNumber*)end
				 WithDay:(NSNumber*)date
	  WithClassGroupName:(NSString*)name
		 WithModuleColor:(UIColor*)color
	   WithClassTypeName:(NSString*)classtype;

-(CGRect)calculateDisplayProperty;

@end
