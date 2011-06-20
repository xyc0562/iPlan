//
//  ModelLogic.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import "ModelLogic.h"


@implementation ModelLogic
@synthesize timetables;

-(id)initWithTimeTables:(NSMutableArray*)tables
{
	[super init];
	if(super !=nil)
	{
		if(tables!=nil)
			timetables = tables;
		else {
			timetables = [[NSMutableArray alloc]init];
		}

	}
	return self;
}

-(void)addTimeTable:(TimeTable*)timetable
{
	[timetables addObject:timetable];
}



-(id)initWithCoder:(NSCoder *)decoder{
	if([super init]!=nil){
		[self initWithTimeTables:[decoder decodeObjectForKey:@"modules"]];
	}
	return self;
}

-(void)dealloc{
	[timetables release];
	[super dealloc];
}

@end
