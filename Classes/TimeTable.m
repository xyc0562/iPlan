//
//  TimeTable.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import "TimeTable.h"


@implementation TimeTable
@synthesize name;
@synthesize modules;

-(id)initWithName:(NSString*)naming
{
	[super init];
	if(super !=nil)
	{
		name = naming;
		modules = [[NSMutableArray alloc]init];
	}
	return self;
}

-(id)initWithName:(NSString*)naming WithModules:(NSMutableArray*)module
{
	[super init];
	if(super !=nil)
	{
		name = naming;
		modules = module;
	}
	return self;
}


-(BOOL)getOneDefaultSolutionsWithCurrentProgress:(NSArray*)currentProgress
				WithBasicInformationAboutModules:(NSArray*)basicInformation
						WithAddInSlotInformation:(NSArray*)addInSlot
								   WithTimeTable:(NSArray*)timeTable
{
	//currentProgress is an array of current module information
	//it is an array of array
	//for each active module, 
	//0.module index in orginal modules list
	//1.current module classtype index
	//2.current slot index
	
	//basic information is an array of array of array
	//for each active module correspond to the modules in current progress
	//for each classtype
	//the maximum number of slot
	
	
	//AddInSlot
	//similar to currentprogess
	//but it is a one level array
	
	
	//timeTable
	//Array of array
	//outer array defines the 7 days
	//inner array defines the 24 hours
	
	return NO;
	
}

-(NSMutableArray*)constructInitialCurrentProgress
{
	NSMutableArray* currentProgress = [[NSMutableArray alloc]init];
	int i = 0;
	for(i=0;i<[modules count];i++)
	{
		if([[modules objectAtIndex:i] checkSelected])
		{
			NSMutableArray* information = [[NSMutableArray alloc]init];
			[information addObject:[NSNumber numberWithInt:i]];
			[information addObject:[NSNumber numberWithInt:0]];
			[information addObject:[NSNumber numberWithInt:0]];
			[currentProgress addObject:information];
		}
	}
	return currentProgress;

}
			
-(NSMutableArray*)constructBasicInformation
{
	NSMutableArray* basicInformation = [[NSMutableArray alloc]init];
	int i = 0;
	for(i=0;i<[modules count];i++)
	{
		if([[modules objectAtIndex:i] checkSelected])
		{
			NSMutableArray* information = [[NSMutableArray alloc]init];
			int j = 0;
			for(j=0;j<[[[modules objectAtIndex:i]moduleClassTypes]count];j++)
			{
				int numOfSlots = [[[[[modules objectAtIndex:i]moduleClassTypes] objectAtIndex:j]slots]count];
				[information addObject:[NSNumber numberWithInt:numOfSlots]];
			}
			[basicInformation addObject:information];
		}
	}
	return basicInformation;
}

-(NSMutableArray*)constructInitialTimeTable
{
	NSNumber *CommitToNo = [NSNumber numberWithInt:0];
	NSMutableArray* time = [[NSMutableArray alloc]init];
	int i = 0;
	for(i=0;i<7;i++)
	{
		NSMutableArray* day = [[NSMutableArray alloc]init];
		int j = 0;
		for(j=0;j<24;j++)
		{
			[day addObject:CommitToNo];
		}
		[time addObject:day];
	}
	return time;
}

-(NSMutableArray*)constructResult
{
	NSMutableArray* result = [[NSMutableArray alloc]init];
	int i = 0;
	for(i=0;i<[modules count];i++)
	{
		if([[modules objectAtIndex:i] checkSelected])
		{
			NSMutableArray* information = [[NSMutableArray alloc]init];
			int j = 0;
			for(j=0;j<[[[modules objectAtIndex:i]moduleClassTypes]count];j++)
			{
				NSNumber *CommitToNo = [NSNumber numberWithInt:-1];
				[information addObject:CommitToNo];
			}
			[result addObject:information];
		}
	}
	return result;
}	
	
			   
-(void)encodeWithCoder:(NSCoder *)coder
{
	
	[coder encodeObject:name forKey:@"name"];
	[coder encodeObject:modules forKey:@"modules"];

}

-(id)initWithCoder:(NSCoder *)decoder
{
	if([super init]!=nil){
		[self initWithName:[decoder decodeObjectForKey:@"name"] WithModules:[decoder decodeObjectForKey:@"modules"]];
	}
	return self;
}

-(void)dealloc{
	[name release];
	[modules release];
	[super dealloc];
}



@end
