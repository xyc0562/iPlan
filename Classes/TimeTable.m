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
						WithAddInClassGroupInformation:(NSArray*)addInClassGroup
								   WithTimeTable:(NSArray*)timeTable
									  WithResult:(NSArray*)result
								 WithModuleIndex:(NSArray*)moduleIndex
{
	int countOfActiveModules = [currentProgress count];
	NSMutableArray*information = [currentProgress objectAtIndex:0];
	
	
	
	
	if([self checkPossibilityWithCurrentProgress:currentProgress
				  WithAddInClassGroupInformation:addInClassGroup
								   WithTimeTable:timeTable])
	{
		//find next
		NSMutableArray* newAddInClassGroupInformation = [self nextToAddInToBasedOn:AddInClassGroupInformation 
															   AndBasicInformation:basicInformation
																   WithModuleIndex:moduleIndex];
		if([newAddInClassGroupInformation count]==0)
			return YES;
		else 
		{
			//updateBasedOn
			[result release];
			[currentProgress release];
			[timeTable release];
			[addInClassGroup release];
			return [self getOneDefaultSolutionsWithCurrentProgress:newCurrentProgress
						   WithBasicInformationAboutModules:basicInformation
							 WithAddInClassGroupInformation:newAddInClassGroupInformation
											  WithTimeTable:newTimeTable
												 WithResult:newResult
												WithModuleIndex:moduleIndex];
	
		}
	}
	else 
	{
		return NO;
	}

	//currentProgress is an array of current module information
	//it is an array of array
	//for each active module, 
	//0.module index in orginal modules list
	//1.current module classtype index
	//2.current ClassGroup index
	
	//basic information is an array of array of array
	//for each active module correspond to the modules in current progress
	//for each classtype
	//the maximum number of ClassGroup
	
	
	//AddInClassGroup
	//similar to currentprogess
	//but it is a one level array
	
	
	//timeTable
	//Array of array
	//outer array defines the 7 days
	//inner array defines the 24 hours
	
	return NO;
	
}

-(NSMutableArray*)nextToAddInToBasedOn:(NSMutableArray*)addInClassGroupInformation 
				   AndBasicInformation:(NSMutableArray*)basicInformation
					   WithModuleIndex:(NSMutableArray*)moduleIndex
{
	(NSMutableArray*)newAddInClassGroupInformation = [[NSMutableArray alloc]init];
	int i;
	for(i=0;i<[moduleIndex count];i++)
	{
		if([[moduleIndex objectAtIndex:i] isEqual:[addInClassGroupInformation objectAtIndex:0]])//same module
		{
			NSMutableArray* information = [basicInformation objectAtIndex:i];
			int totalGroupNumeber = [information objectAtIndex:[addInClassGroupInformation objectAtIndex:1]];
			if(totalGroupNumeber-1 == [addInClassGroupInformation objectAtIndex:2])
			{
				int classtypeindex = [addInClassGroupInformation objectAtIndex:1];
				int totolClassTypes = [basicInformation count];
				if(totolClassTypes-1==classtypeindex)
				{
					if(i==[moduleIndex count]-1) //nothing to add
					{
						return newAddInClassGroupInformation;
					}
					else
					{
						[newAddInClassGroupInformation addObject:[NSNumber numberWithInt:i+1]];
						[newAddInClassGroupInformation addObject:[NSNumber numberWithInt:0]];
						[newAddInClassGroupInformation addObject:[NSNumber numberWithInt:0]];
					}
				}
				else 
				{
					[newAddInClassGroupInformation addObject:[NSNumber numberWithInt:i]];
					[newAddInClassGroupInformation addObject:[NSNumber numberWithInt:classtypeindex+1]];
					[newAddInClassGroupInformation addObject:[NSNumber numberWithInt:0]];
				}
			}
			else 
			{
				[newAddInClassGroupInformation addObject:[NSNumber numberWithInt:i]];
				[newAddInClassGroupInformation addObject:[NSNumber numberWithInt:classtypeindex]];
				//[newAddInClassGroupInformation addObject:[NSNumber numberWithInt:[addInClassGroupInformation objectAtIndex:2]+1]];
			}


						
		}
		else {
			continue;
		}

	}
	return newAddInClassGroupInformation;
}
-(BOOL)checkPossibilityWithCurrentProgress:(NSMutableArray*)currentProgress
				  WithAddInClassGroupInformation:(NSMutableArray*)AddInClassGroupInformation
							 WithTimeTable:(NSMutableArray*)timeTable
{
	int countOfActiveModules = [currentProgress count];
	
	if([self checkCurrentWithAddInClassGroup:AddInClassGroupInformation WithCurrentTimetable:timeTable]||
	   [self checkFutureWithAddInClassGroup:AddInClassGroupInformation WithCurrentTimetable:timeTable :WithCurrentProgress:currentProgress])
	{
		return NO;
	}

		//decide next addinclassgroup
		//new slot loop
		//recursion line
	
	else 
	{
		return YES;
	}


		
}
//if there is confliction return YES
//else return NO
-(BOOL)checkCurrentWithAddInClassGroup:(NSMutableArray*)AddInClassGroupInformation
				  WithCurrentTimetable:(NSMutableArray*)timeTable
{
	int i,j,k;
	Module* module = [modules objectAtIndex:[AddInClassGroupInformation objectAtIndex:0]];
	ModuleClassTypes* classtypes = [[module moduleClassTypes]objectAtIndex:[AddInClassGroupInformation objectAtIndex:1]];
	ClassGroup* addInClassGroup = [[classtypes classGroups]objectAtIndex:[AddInClassGroupInformation objectAtIndex:2]];
	for (i=0; i<7; i++) 
	{
		for (j=0; j<24; j++) 
		{
			for (Slot* slot in [addInClassGroup slots]) 
			{
				BOOL conflict = NO;
				//check time conflict with timetable
				
				if(conflict)
					return NO; //contradict with timetable
			}
		}
	}
	return YES;
}
//if there is confliction return YES
//else return NO
-(BOOL)checkFutureWithAddInClassGroup:(NSMutableArray*)AddInClassGroupInformation
				 WithCurrentTimetable:(NSMutableArray*)timeTable
				  WithCurrentProgress:(NSMutableArray*)currentProgress
	 WithBasicInformationAboutModules:(NSMutableArray*)basicInformation
{
	[self addSlot:AddInClassGroupInformation WithCurrentTimetable:timeTable]
	int i,j,k;
	for(i=0;i<[currentProgress count];i++)
	{
		Module* module = [modules objectAtIndex:[currentProgress objectAtIndex:i]objectAtIndex:0];
		for(j=[[currentProgress objectAtIndex:i]objectAtIndex:1]+1;j<[[basicInformation objectAtIndex:i]count])//j represents classtype
		{
			
			ModuleClassTypes* classtypes = [module ModuleClassTypes];
			NSMutableArray* classgroups = [[classtypes classGroups]objectAtIndex:j];
			BOOL conflict = YES;
			for(ClassGroup* classgroup in classgroups)
			{
				BOOL putInConflict = NO;
			
				for (Slot* slot in [classgroup slots]) 
				{
					putInConflict = putInConflict || [self checkConflictSlot:slot WithCurrentTimetable:timeTable];//if conflict return YES;
				}
				
				if(!putInConflict)
				{
					conflict = NO;
					break;
				}
				
			}
			if(conflict)
				return YES;
			
		}
	}
	return NO;
}

-(void)addSlot:(NSMutableArray*)AddInClassGroupInformation
	WithTimeTable:(NSMutableArray*)timeTable
{
}

-(void)deleteSlot:(NSMutableArray*)AddInClassGroupInformation
	WithTimeTable:(NSMutableArray*)timeTable
{	
}

-(BOOL)checkFuturePossibilityWithCurrentProgress:

-(BOOL)nextTrialProgressWithCurrentProgress:(NSMutableArray*)currentProgress
{
	int countOfActiveModules = [currentProgress count];
	int i = 0;
	int moduleIndex;
	while ([[currentProgress objectAtIndex:i] objectAtIndex:1] == [[basicInformation objectAtIndex:i] count]) {
		i++;
	}
	moduleIndex = [[currentProgress objectAtIndex:i] objectAtIndex:0];
	if  ([[currentProgress objectAtIndex:i] objectAtIndex:2]< [[basicInformation objectAtIndex:i] objectAtIndex:[[currentProgress objectAtIndex:i] objectAtIndex:1]]) {
		[[currentProgress objectAtIndex:i] objectAtIndex:2]++;
		return YES;
	}
	return NO;
}

-(BOOL)nextStepProgressWithCurrentProgress:(NSArray*)currentProgress
{
	int countOfActiveModules = [currentProgress count];
	int i = 0;
	while ([[currentProgress objectAtIndex:i] objectAtIndex:1] == [[modules objectAtIndex:[[currentProgress objectAtIndex:i] objectAtIndex:0]]classTypes count]) {
		i++;
	}
	if ([[currentProgress objectAtIndex:i] objectAtIndex:1]<[[modules objectAtIndex:[[currentProgress objectAtIndex:i] objectAtIndex:0]]classTypes count]){
		[[currentProgress objectAtIndex:i] objectAtIndex:1]++;
		return TRUE;
	}
	else return FALSE;
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
			[information addObject:[NSNumber numberWithInt:-1]];//last success class type
			[information addObject:[NSNumber numberWithInt:-1]];//last success ClassGroup 
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
				int numOfClassGroups = [[[[[modules objectAtIndex:i]moduleClassTypes] objectAtIndex:j]ClassGroups]count];
				[information addObject:[NSNumber numberWithInt:numOfClassGroups]];
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
	
									   
									   
-(NSMutableArray*)constructModuleIndex
{
	NSMutableArray* moduleIndex = [[NSMutableArray alloc]init];
	int i = 0;
	for(i=0;i<[modules count];i++)
	{
		if([[modules objectAtIndex:i] checkSelected])
		{
			
			[moduleIndex addObject:[NSNumber numberWithInt:i]];
		}
	}
	return moduleIndex;
	
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
