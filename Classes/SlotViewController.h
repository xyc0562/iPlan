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
	NSNumber* day;
	NSString* classTypeName;
	UIColor* moduleColor;
	CGRect displayProperty;
	int index;
	int groupIndex;
}

@property (nonatomic,retain)NSString* moduleCode;
@property (nonatomic,retain)NSString* venue;
@property (nonatomic,retain)NSString* classGroupName;
@property (nonatomic,retain)NSNumber* startTime;
@property (nonatomic,retain)NSNumber* endTime;
@property (nonatomic,retain)UIColor* moduleColor;
@property (nonatomic,retain)NSNumber* day;
@property (nonatomic,readonly)CGRect displayProperty;
@property (nonatomic,retain)UIScrollView* scroll;
@property (nonatomic,retain)UIView* displayView;
@property (nonatomic,retain)UITableView* table;
@property (nonatomic,assign)int index;
@property (nonatomic,assign)int groupIndex;
@property (nonatomic,retain)NSMutableArray* tableChoices;
@property (nonatomic,retain)NSString* classTypeName;
@property (nonatomic,retain)NSMutableArray* availableSlots;

- (id)initWithModuleCode:(NSString *)code 
			   WithVenue:(NSString*)place
		   WithStartTime:(NSNumber*)start
			 WithEndTime:(NSNumber*)end
				 WithDay:(NSNumber*)date
	  WithClassGroupName:(NSString*)name
		 WithModuleColor:(UIColor*)color
	   WithClassTypeName:(NSString*)classtype
			   WithIndex:(int)indexNumber
		  WithGroupIndex:(int)groupNumber;

-(CGRect)calculateDisplayProperty;

@end
