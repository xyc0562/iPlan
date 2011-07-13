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
	NSString *requestedToken;
	NSMutableArray *basket;
	NSMutableArray *activeModules;
	NSMutableArray *requirements;
	NSMutableDictionary *moduleCells;
	NSMutableDictionary *removedCells;
	BOOL zoomed;
	SlotViewController* selectSlot;
	NSMutableArray* slotControllers;
	BOOL needUpdate;
	BOOL continueToCalendar;
}

@property (nonatomic, copy) NSString *settingsIdentity;
@property (nonatomic, copy) NSString *moduleCode;
@property (nonatomic, copy) NSString *requestedToken;
@property (nonatomic, retain) NSMutableArray *basket;
@property (nonatomic, retain) NSMutableArray *activeModules;
@property (nonatomic, retain) NSMutableArray *requirements;
@property (nonatomic, retain) NSMutableDictionary *moduleCells;
@property (nonatomic, retain) NSMutableDictionary *removedCells;
@property (nonatomic, assign) BOOL zoomed;
@property (nonatomic, assign) SlotViewController* selectSlot;
@property (nonatomic, retain) NSMutableArray* slotControllers;
@property (nonatomic, assign) BOOL needUpdate;
@property (nonatomic, assign) BOOL continueToCalendar;


@end
