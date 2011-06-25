//
//  TimeTable.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//




#import "TimeTable.h"
@interface TimeTable()
-(BOOL)checkPossibilityWithCurrentProgress:(NSMutableArray*)currentProgress
			WithAddInClassGroupInformation:(NSMutableArray*)AddInClassGroupInformation
							 WithTimeTable:(NSMutableArray*)timeTable
					  WithBasicInformation:(NSMutableArray*)basicInformation;

-(NSMutableArray*)nextToAddInToBasedOn:(NSMutableArray*)addInClassGroupInformation 
				   AndBasicInformation:(NSMutableArray*)basicInformation
					   WithModuleIndex:(NSMutableArray*)moduleIndex;

-(NSMutableArray*)nextToTryBasedOn:(NSMutableArray*)addInClassGroupInformation 
				   AndBasicInformation:(NSMutableArray*)basicInformation
					   WithModuleIndex:(NSMutableArray*)moduleIndex;

-(BOOL)checkCurrentWithAddInClassGroup:(NSMutableArray*)AddInClassGroupInformation
				  WithCurrentTimetable:(NSMutableArray*)timeTable;

-(BOOL)checkFutureWithAddInClassGroup:(NSMutableArray*)AddInClassGroupInformation
				 WithCurrentTimetable:(NSMutableArray*)timeTable
				  WithCurrentProgress:(NSMutableArray*)currentProgress
				 WithBasicInformation:(NSMutableArray*)basicInformation;

-(void)addGroup:(NSMutableArray*)addInClassGroupInformation
 WithTimeTable:(NSMutableArray*)timeTable;

-(BOOL)getOneDefaultSolutionsWithCurrentProgress:(NSMutableArray*)currentProgress
							WithBasicInformation:(NSMutableArray*)basicInformation
				  WithAddInClassGroupInformation:(NSMutableArray*)addInClassGroup
								   WithTimeTable:(NSMutableArray*)timeTable
									  WithResult:(NSMutableArray*)result
								 WithModuleIndex:(NSMutableArray*)moduleIndex;

-(void)updateWithCurrentProgress:(NSMutableArray*)newCurrentProgress With:(NSMutableArray*)addInClassGroup;
-(void)updateWithTimeTable:(NSMutableArray*)newTimeTable With:(NSMutableArray*)addInClassGroup;
-(void)updateWithResult:(NSMutableArray*)newResult With:(NSMutableArray*)addInClassGroup;


-(NSMutableArray*)constructInitialCurrentProgress;

-(NSMutableArray*)constructBasicInformation;

-(NSMutableArray*)constructInitialTimeTable;

-(NSMutableArray*)constructResult;

-(NSMutableArray*)constructModuleIndex;

-(BOOL)checkConflictSlot:(Slot*)slot WithCurrentTimetable:(NSMutableArray*)timeTable;

@end

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

-(NSMutableArray*)planOneTimetable
{
	NSMutableArray* currentProgress = [self constructInitialCurrentProgress];
	NSMutableArray* basicInformation = [self constructBasicInformation];
	NSMutableArray* moduleIndex = [self constructModuleIndex];
	NSMutableArray* timetable = [self constructInitialTimeTable];		
	NSMutableArray* result = [self constructResult];
	NSMutableArray* addInClassGroup = [[NSMutableArray alloc]init];
	[addInClassGroup addObject:[moduleIndex objectAtIndex:0]];
	[addInClassGroup addObject:[NSNumber numberWithInt:0]];
	[addInClassGroup addObject:[NSNumber numberWithInt:0]];
	BOOL success = [self getOneDefaultSolutionsWithCurrentProgress:(NSMutableArray*)currentProgress
							   WithBasicInformation:(NSMutableArray*)basicInformation
					 WithAddInClassGroupInformation:(NSMutableArray*)addInClassGroup
									  WithTimeTable:(NSMutableArray*)timetable
										 WithResult:(NSMutableArray*)result
									WithModuleIndex:(NSMutableArray*)moduleIndex];
	if(success)
	{
		return result;
	}
	else {
		return [[NSMutableArray alloc]init];
	}

	
	



}
-(BOOL)getOneDefaultSolutionsWithCurrentProgress:(NSMutableArray*)currentProgress
							WithBasicInformation:(NSMutableArray*)basicInformation
				  WithAddInClassGroupInformation:(NSMutableArray*)addInClassGroup
								   WithTimeTable:(NSMutableArray*)timeTable
									  WithResult:(NSMutableArray*)result
								 WithModuleIndex:(NSMutableArray*)moduleIndex
{
	
	if([self checkPossibilityWithCurrentProgress:currentProgress
				  WithAddInClassGroupInformation:addInClassGroup
								   WithTimeTable:timeTable
							WithBasicInformation:basicInformation])
	{
		//find next
		NSMutableArray* newAddInClassGroupInformation = [self nextToAddInToBasedOn:addInClassGroup
															   AndBasicInformation:basicInformation
																   WithModuleIndex:moduleIndex];
		if([newAddInClassGroupInformation count]==0)
			return YES;
		else 
		{
			//updateBasedOn
			NSMutableArray* newCurrentProgress = [[NSMutableArray alloc]initWithArray:currentProgress];
			NSMutableArray* newTimeTable = [[NSMutableArray alloc]initWithArray:timeTable];
			NSMutableArray* newResult = [[NSMutableArray alloc]initWithArray:result];
			
			[self updateWithCurrentProgress:newCurrentProgress With:addInClassGroup];
			[self updateWithTimeTable:newTimeTable With:addInClassGroup];
			[self updateWithResult:newResult With:addInClassGroup];

			BOOL success = NO;
			
			BOOL exist =YES;
			NSMutableArray* tempAddInClassGroup = [[NSMutableArray alloc]initWithArray:newAddInClassGroupInformation];
			while (YES)
			{
				if ([self getOneDefaultSolutionsWithCurrentProgress:newCurrentProgress
											  WithBasicInformation:basicInformation
									WithAddInClassGroupInformation:tempAddInClassGroup
													 WithTimeTable:newTimeTable
														WithResult:newResult
												   WithModuleIndex:moduleIndex])
				{
					success = YES;
					break;
				}
				NSMutableArray* tempAddInClassGroup = [self nextToTryBasedOn:tempAddInClassGroup
														 AndBasicInformation:basicInformation
															 WithModuleIndex:moduleIndex];
				if([tempAddInClassGroup count]==0)
				{
					exist = NO;
					break;
				}
				else 
				{
					//try next classgroup
					continue; 
				}
			}
			if(success)
			{
				[currentProgress release];
				[timeTable release];
				[result release];
				currentProgress = newCurrentProgress;//make copy or assign
				timeTable = newTimeTable;
				result = newResult;
				
				return YES;
			}
			if(!exist)
			{
				return NO;
			}
			
	
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
	NSMutableArray* newAddInClassGroupInformation = [[NSMutableArray alloc]init];
	int i;
	for(i=0;i<[moduleIndex count];i++)
	{
		if([[moduleIndex objectAtIndex:i] isEqual:[addInClassGroupInformation objectAtIndex:0]])//same module
		{
			NSNumber* classtypeindex = [addInClassGroupInformation objectAtIndex:1];
			    int totolClassTypes = [[basicInformation objectAtIndex:i] count];
				if([[NSNumber numberWithInt: totolClassTypes-1]isEqualToNumber:classtypeindex])
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
					[newAddInClassGroupInformation addObject:[NSNumber numberWithInt:[classtypeindex intValue]+1]];
					[newAddInClassGroupInformation addObject:[NSNumber numberWithInt:0]];
				}
		}
		else {
			continue;
		}

	}
	return newAddInClassGroupInformation;
}

-(NSMutableArray*)nextToTryBasedOn:(NSMutableArray*)addInClassGroupInformation 
				   AndBasicInformation:(NSMutableArray*)basicInformation
					   WithModuleIndex:(NSMutableArray*)moduleIndex
{
	NSMutableArray* trialAddInClassGroupInformation = [[NSMutableArray alloc]init];
	int i;
	for(i=0;i<[moduleIndex count];i++)
	{
		if([[moduleIndex objectAtIndex:i] isEqual:[addInClassGroupInformation objectAtIndex:0]])//same module
		{
			NSNumber* classtypeindex = [addInClassGroupInformation objectAtIndex:1];
			NSNumber* totalGroupNumber = [[basicInformation objectAtIndex:i]objectAtIndex:[classtypeindex intValue]];
			if ([[addInClassGroupInformation objectAtIndex:2]intValue]<[totalGroupNumber intValue]-1) 
			{
				[trialAddInClassGroupInformation addObject:[addInClassGroupInformation objectAtIndex:0]];
				[trialAddInClassGroupInformation addObject:[addInClassGroupInformation objectAtIndex:1]];
				[trialAddInClassGroupInformation addObject:[NSNumber numberWithInt:[[addInClassGroupInformation objectAtIndex:2]intValue]+1]];
			}
		}
	}
	return trialAddInClassGroupInformation;
}

-(BOOL)checkPossibilityWithCurrentProgress:(NSMutableArray*)currentProgress
				  WithAddInClassGroupInformation:(NSMutableArray*)addInClassGroupInformation
							 WithTimeTable:(NSMutableArray*)timeTable
					  WithBasicInformation:(NSMutableArray*)basicInformation
{
	
	
	if([self checkCurrentWithAddInClassGroup:addInClassGroupInformation WithCurrentTimetable:timeTable]||
	   [self checkFutureWithAddInClassGroup:addInClassGroupInformation WithCurrentTimetable:timeTable WithCurrentProgress:currentProgress WithBasicInformation:basicInformation] )
	{
		return NO;
	}
	else 
	{
		return YES;
	}


		
}
//if there is confliction return YES
//else return NO
-(BOOL)checkCurrentWithAddInClassGroup:(NSMutableArray*)addInClassGroupInformation
				  WithCurrentTimetable:(NSMutableArray*)timeTable
{
	printf("checkCurrentWithAddInClassGroup\n");
	int week;
 	Module* module = [modules objectAtIndex:[[addInClassGroupInformation objectAtIndex:0]intValue]];
	ModuleClassType* classtypes = [[module moduleClassTypes]objectAtIndex:[[addInClassGroupInformation objectAtIndex:1]intValue]];
	ClassGroup* addInClassGroup = [[classtypes classGroups]objectAtIndex:[[addInClassGroupInformation objectAtIndex:2]intValue]];
	for (Slot* slot in [addInClassGroup slots]) 
		{ 
			[slot showContents];
			int startTime = [[slot startTime]intValue]/100;
			int endTime = [[slot endTime]intValue]/100;
			printf("endTime %d",endTime);
			int day = [[slot day]intValue];
			for (week = 1; week <= 14; week++)
			{
				if ([[[slot frequency]objectAtIndex:week]isEqualToString:@"YES"])
				{
					NSMutableArray* weekArray = [timeTable objectAtIndex:week];
					int i = 0;
					for(i= startTime;i<endTime;i++)
					{
						if([[[weekArray objectAtIndex:day]objectAtIndex:i]isEqualToNumber:[NSNumber numberWithInt:1]])
							return YES;
						else 
						{
							continue;
						}
					}
				}
			}

		}
				return NO;
}
//if there is confliction return YES
//else return NO
-(BOOL)checkFutureWithAddInClassGroup:(NSMutableArray*)addInClassGroupInformation
				 WithCurrentTimetable:(NSMutableArray*)timeTable
				  WithCurrentProgress:(NSMutableArray*)currentProgress
				 WithBasicInformation:(NSMutableArray*)basicInformation
{
	NSMutableArray* newTimeTable = [[NSMutableArray alloc]initWithArray:timeTable];
	[self addGroup:addInClassGroupInformation WithTimeTable:newTimeTable];
	int i,j;
	for(i=0;i<[currentProgress count];i++)
	{
		Module* module = [modules objectAtIndex:[[[currentProgress objectAtIndex:i]objectAtIndex:0]intValue] ];
		for(j=[[[currentProgress objectAtIndex:i]objectAtIndex:1]intValue]+1;j<[[basicInformation objectAtIndex:i]count];j++)//j represents classtype
		{
			
			NSArray* classtypes = [module moduleClassTypes];
			NSArray* classgroups = [[classtypes objectAtIndex:j]classGroups];
			BOOL conflict = YES;
			for(ClassGroup* classgroup in classgroups)
			{
				BOOL putInConflict = NO;
			
				for (Slot* slot in [classgroup slots]) 
				{
					putInConflict = putInConflict || [self checkCurrentWithAddInClassGroup:(NSMutableArray*)addInClassGroupInformation
																	  WithCurrentTimetable:(NSMutableArray*)newTimeTable];//if conflict return YES;
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

-(BOOL)checkConflictSlot:(Slot*)slot WithCurrentTimetable:(NSMutableArray*)timeTable
{
	
	return NO;
}

-(void)addGroup:(NSMutableArray*)addInClassGroupInformation
	WithTimeTable:(NSMutableArray*)timeTable
{
	NSNumber* moduleIndex = [addInClassGroupInformation objectAtIndex:0];
	NSNumber* classTypeIndex = [addInClassGroupInformation objectAtIndex:1];
	NSNumber* groupIndex = [addInClassGroupInformation objectAtIndex:2];
	Module* module = [modules objectAtIndex:[moduleIndex intValue]];
	ModuleClassType* classType = [[module moduleClassTypes]objectAtIndex:[classTypeIndex intValue]];
	ClassGroup* classGroup = [[classType classGroups]objectAtIndex:[groupIndex intValue]];
	NSArray* slots = [classGroup slots];

	for (Slot* slot in slots) 
	{
		int startTime = [[slot startTime]intValue]/100;
		int endTime = [[slot endTime]intValue]/100;
		int day = [[slot day]intValue];
		NSNumber* occupied = [NSNumber numberWithInt:1];//occupied
		int i;
		for(NSMutableArray* weekArray in timeTable)
		{
			NSMutableArray* dayArray = [weekArray objectAtIndex:day];
			for (i=startTime; i<endTime; i++) 
			{
				[dayArray removeObjectAtIndex:i];
				[dayArray insertObject:occupied atIndex:i];
				
			}
		}
	}
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
				int numOfClassGroups = [[[[[modules objectAtIndex:i]moduleClassTypes] objectAtIndex:j]classGroups]count];
				[information addObject:[NSNumber numberWithInt:numOfClassGroups]];
			}
			[basicInformation addObject:information];
		}
	}
	return basicInformation;
}

-(NSMutableArray*)constructInitialTimeTable
{
	NSNumber *occupied = [NSNumber numberWithInt:0];
	NSMutableArray* timetable = [[NSMutableArray alloc]init];
	int i ,k;
	for(k=0;k<=14;k++)
	{
		NSMutableArray* week = [[NSMutableArray alloc]init];
		for(i=0;i<8;i++)
		{
			NSMutableArray* day = [[NSMutableArray alloc]init];
			int j = 0;
			for(j=0;j<24;j++)
			{
				[day addObject:occupied];
			}
			[week addObject:day];
		}
		[timetable addObject:week];
	}
	return timetable;
}

-(NSMutableArray*)constructResult
{
	NSMutableArray* result = [[NSMutableArray alloc]init];
/*	int i = 0;
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
 */
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

-(void)updateWithCurrentProgress:(NSMutableArray*)newCurrentProgress With:(NSMutableArray*)addInClassGroup
{
	int i;
	for(i=0;i<[newCurrentProgress count];i++)
	{
		if([[[newCurrentProgress objectAtIndex:i]objectAtIndex:0] isEqual:[addInClassGroup objectAtIndex:0]])//same module
		{
			[newCurrentProgress removeObjectAtIndex:i];
			[newCurrentProgress insertObject:addInClassGroup atIndex:i];
			break;
		}
	}		
}

-(void)updateWithTimeTable:(NSMutableArray*)newTimeTable 
					  With:(NSMutableArray*)addInClassGroupInformation
{
	NSNumber* moduleIndex = [addInClassGroupInformation objectAtIndex:0];
	NSNumber* classTypeIndex = [addInClassGroupInformation objectAtIndex:1];
	NSNumber* groupIndex = [addInClassGroupInformation objectAtIndex:2];
	Module* module = [modules objectAtIndex:[moduleIndex intValue]];
	ModuleClassType* classType = [[module moduleClassTypes]objectAtIndex:[classTypeIndex intValue]];
	ClassGroup* classGroup = [[classType classGroups]objectAtIndex:[groupIndex intValue]];
	NSArray* slots = [classGroup slots];
	for (Slot* slot in slots) {
		int startTime = [[slot startTime]intValue]/100;
		int endTime = [[slot endTime]intValue]/100;
		int day = [[slot day]intValue];
		NSNumber* occupied = [NSNumber numberWithInt:1];//occupied
		int i,week;
		for (week=1;week<=14;week++) 
		{
			if ([[[slot frequency] objectAtIndex:week]isEqualToString:@"YES"])
			{
				NSMutableArray *weekArray = [newTimeTable objectAtIndex:week];
				NSMutableArray* dayArray = [weekArray objectAtIndex:day];
				for (i=startTime; i<endTime; i++)
				{
					[dayArray removeObjectAtIndex:i];
					[dayArray insertObject:occupied atIndex:i];
				
				}
			}
		}
	
	}
	
}

-(void)updateWithResult:(NSMutableArray*)newResult With:(NSMutableArray*)addInClassGroup
{
	[newResult addObject:addInClassGroup];
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
