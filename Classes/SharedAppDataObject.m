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
@synthesize activeModules;
@synthesize activeIndexes;
@synthesize zoomed;
@synthesize moduleCells;
@synthesize removedCells;

#pragma mark -
#pragma mark -Memory management

-(id) init {
	if ([super init]){
		basket = [[NSMutableArray alloc] init];
		activeModules = [[NSMutableArray alloc] init];
		activeIndexes = [[NSMutableArray alloc] init];
		moduleCells = [[NSMutableDictionary alloc] init];
		removedCells = [[NSMutableDictionary alloc] init];
		zoomed = NO;
	}
	return self;
}

- (void)dealloc
{
	self.settingsIdentity = nil;
	self.moduleCode = nil;
	self.basket = nil;
	self.activeIndexes = nil;
	self.moduleCells = nil;
	self.removedCells = nil;
	[basket release];
	[activeModules release];
	[activeIndexes release];
	[moduleCells release];
	[removedCells release];
	[super dealloc];
}

@end
