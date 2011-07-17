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
@synthesize requirements;
@synthesize moduleCells;
@synthesize removedCells;
@synthesize selectSlot;
@synthesize slotViewControllers;
@synthesize needUpdate;
@synthesize continueToCalendar;
@synthesize tableChoices;
@synthesize availableSlots;
@synthesize table;
@synthesize image;
@synthesize requirementEnabled;

#pragma mark -
#pragma mark -Memory management

-(id) init {
	if ([super init]){
		basket = [[NSMutableArray alloc] init];
		activeModules = [[NSMutableArray alloc] init];
		requirements = [[NSMutableArray alloc] init];
		moduleCells = [[NSMutableDictionary alloc] init];
		removedCells = [[NSMutableDictionary alloc] init];
		slotViewControllers =[[NSMutableArray alloc]init];
		tableChoices = [[NSMutableArray alloc]init];
		availableSlots = [[NSMutableArray alloc]init];
		selectSlot = nil;
		needUpdate = NO;
		continueToCalendar = NO;
		requirementEnabled = NO;
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{

	[coder encodeObject:settingsIdentity forKey:@"settingsIdentity"];
	[coder encodeObject:moduleCode forKey:@"moduleCode"];
	[coder encodeObject:basket forKey:@"basket"];
	[coder encodeObject:activeModules forKey:@"activeModules"];
	[coder encodeObject:requirements forKey:@"requirements"];
//	[coder encodeObject:removedCells forKey:@"removedCells"];
//	[coder encodeObject:moduleCells forKey:@"moduleCells"];

}

-(id)initWithCoder:(NSCoder *)decoder{
	if([super init]!=nil)
	{
		basket = [decoder decodeObjectForKey:@"basket"];
		activeModules = [decoder decodeObjectForKey:@"activeModules"];
		requirements = [decoder decodeObjectForKey:@"requirements"];
		selectSlot = nil;
		needUpdate = NO;
		continueToCalendar = NO;
		requirementEnabled = NO;
		moduleCode = [decoder decodeObjectForKey:@"moduleCode"];
		settingsIdentity = [decoder decodeObjectForKey:@"settingIdentity"];
		//moduleCells = [decoder decodeObjectForKey:@
	}
	return self;
}



- (void)dealloc
{

	[settingsIdentity release];
	[moduleCode release];
	[basket release];
	[activeModules release];
	[requirements release];
	[moduleCells release];
	[removedCells release];
	[slotViewControllers release];
	[requirements release];
	[selectSlot release];
	[super dealloc];
}

@end
