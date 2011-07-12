//
//  SharedAppDataObject.m
//  iPlan
//
//  Created by HQ on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SharedAppDataObject.h"

@implementation SharedAppDataObject

#pragma mark -
#pragma mark synthesize

@synthesize settingsIdentity;
@synthesize moduleCode;
@synthesize requestedToken;
@synthesize basket;
@synthesize activeModules;
@synthesize requirements;
@synthesize zoomed;
@synthesize moduleCells;
@synthesize removedCells;
@synthesize selectSlotIndex;
@synthesize slotControllers;
@synthesize needUpdate;

#pragma mark -
#pragma mark -Memory management

-(id) init {
	if ([super init]){
		basket = [[NSMutableArray alloc] init];
		activeModules = [[NSMutableArray alloc] init];
		requirements = [[NSMutableArray alloc] init];
		moduleCells = [[NSMutableDictionary alloc] init];
		removedCells = [[NSMutableDictionary alloc] init];
		slotControllers =[[NSMutableArray alloc]init];
		zoomed = NO;
		selectSlotIndex = -1;
		needUpdate = NO;
	}
	return self;
}

- (void)dealloc
{

	[settingsIdentity release];
	[moduleCode release];
	[requestedToken release];
	[basket release];
	[moduleCells release];
	[removedCells release];
	[slotControllers release];
	[requirements release];
	[super dealloc];
}

@end
