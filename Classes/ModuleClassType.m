//
//  ModuleClassType.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import "ModuleClassType.h"


@implementation ModuleClassType
@synthesize name;
@synthesize classGroups;

-(id)initWithName:(NSString*)naming WithGroups:(NSArray*)groups
{
	[super init];
	if(super !=nil)
	{
		name = naming;
		classGroups = groups;
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
	[coder encodeObject:name forKey:@"name"];
	[coder encodeObject:classGroups forKey:@"classGroups"];

}

-(id)initWithCoder:(NSCoder *)decoder{
	if([super init]!=nil){
		[self initWithName:[decoder decodeObjectForKey:@"name"] WithGroups:[decoder decodeObjectForKey:@"classGroups"]];
	}
	return self;
}

-(void)dealloc{
	[name release];
	[classGroups release];

	[super dealloc];
}


@end
