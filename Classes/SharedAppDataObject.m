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


#pragma mark -
#pragma mark -Memory management

- (void)dealloc
{
	self.settingsIdentity = nil;
	self.moduleCode = nil;
	[super dealloc];
}

@end
