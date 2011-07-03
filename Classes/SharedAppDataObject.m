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
@synthesize zoomed;
@synthesize moduleCells;

#pragma mark -
#pragma mark -Memory management

-(id) init {
	if ([super init]){
		self.basket = [[NSMutableArray alloc] init];
		self.moduleCells = [[NSMutableDictionary alloc] init];
		zoomed = NO;
	}
	return self;
}

- (void)dealloc
{
	self.settingsIdentity = nil;
	self.moduleCode = nil;
	self.basket = nil;
	self.moduleCells = nil;
	[super dealloc];
}

@end
