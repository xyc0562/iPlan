//
//  SharedAppDataObject.h
//  iPlan
//
//  Created by HQ on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDataObject.h"
#import "SlotViewController.h"
@interface SharedAppDataObject : AppDataObject {
	NSString *settingsIdentity;
	NSString *moduleCode;
	NSMutableArray *basket;
	NSMutableArray *activeModules;
	NSMutableArray *requirements;
	NSMutableDictionary *moduleCells;
	NSMutableDictionary *removedCells;
	SlotViewController* selectSlot;
	NSMutableArray* slotViewControllers;
	NSMutableArray* availableSlots;
	NSMutableArray* tableChoices;
	BOOL needUpdate;
	BOOL continueToCalendar;
	BOOL requirementEnabled;
	UITableView* table;
	UIImageView* image;
}

@property (nonatomic, copy) NSString *settingsIdentity;
@property (nonatomic, copy) NSString *moduleCode;
@property (nonatomic, retain) NSMutableArray *basket;
@property (nonatomic, retain) NSMutableArray *activeModules;
@property (nonatomic, retain) NSMutableArray *requirements;
@property (nonatomic, retain) NSMutableDictionary *moduleCells;
@property (nonatomic, retain) NSMutableDictionary *removedCells;
@property (nonatomic, assign) SlotViewController* selectSlot;
@property (nonatomic, retain) NSMutableArray* slotViewControllers;
@property (nonatomic, assign) BOOL needUpdate;
@property (nonatomic, assign) BOOL continueToCalendar;
@property (nonatomic, retain) NSMutableArray* availableSlots;
@property (nonatomic, retain) NSMutableArray* tableChoices;
@property (nonatomic, retain) UITableView* table;
@property (nonatomic, retain) UIImageView* image;
@property (nonatomic, assign) BOOL requirementEnabled;


@end
