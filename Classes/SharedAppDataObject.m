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
@synthesize basket;
@synthesize activeIndexes;
@synthesize zoomed;
@synthesize moduleCells;
@synthesize removedCells;
@synthesize selectSlotIndex;
@synthesize slotControllers;

#pragma mark -
#pragma mark -Memory management

-(id) init {
	if ([super init]){
		self.basket = [[NSMutableArray alloc] init];
		self.moduleCells = [[NSMutableDictionary alloc] init];
		self.removedCells = [[NSMutableDictionary alloc] init];
		zoomed = NO;
		selectSlotIndex = -1;
	}
	return self;
}

- (void)dealloc
{

	[settingsIdentity release];
	[moduleCode release];
	[basket release];
	[moduleCells release];
	[removedCells release];
	[slotControllers release];

	[super dealloc];
}

@end
