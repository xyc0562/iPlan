//
//  TimeTable.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//
//
//exam date clash check
//half hour problem
//program stuck if the first few modules have too many choices
// currentprogress need modify?


#import "TimeTable.h"
@interface TimeTable()


-(BOOL)getOneTimeTableWithIndex:(int)index
			 WithClassTypeArray:(NSMutableArray**)classTypeArray
				  WithTimeTable:(NSMutableArray**)timeTable
					 WithResult:(NSMutableArray*)result;

-(BOOL)checkPossibilityWithCurrentTimeTable:(NSMutableArray*)timeTable
						   WithCurrentIndex:(int)index
						WithAddInClassGroup:(ClassGroup*)addInClassGroup
						 WithClassTypeArray:(NSMutableArray*)classTypeArray;

-(BOOL)clashWithCurrentWithCurrentTimeTable:(NSMutableArray*)timeTable
			 WithAddInClassGroup:(ClassGroup*)addInClassGroup;

-(BOOL)clashWithFutureWithCurrentTimeTable:(NSMutableArray*)timeTable
						  WithCurrentIndex:(int)index
					   WithAddInClassGroup:(ClassGroup*)addInClassGroup
						WithClassTypeArray:(NSMutableArray*)classTypeArray;

-(NSMutableArray*)getClassGroupsWithClassTypeArray:(NSMutableArray*)classTypeArray 
										 WithIndex:(int)index;

-(void)addGroup:(ClassGroup*)addInClassGroup
  WithTimeTable:(NSMutableArray**)timeTable;

-(void)addGroupWithGroupIndex:(int)groupIndex
			 WithCurrentIndex:(int)currentIndex
		   WithClassTypeArray:(NSMutableArray**)classTypeArray;

//new add in 
-(NSMutableArray*)constructNewTimeTableBasedOnTimeTable:(NSMutableArray*)timeTable;




-(NSMutableArray*)constructInitialTimeTable;

-(NSMutableArray*)constructResult;

-(NSMutableArray*)constructClassTypeArrayWithModules;

-(NSMutableArray*)copyClassTypeArray:(NSMutableArray*)classTypeArray;

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

-(NSMutableArray*)constructClassTypeArrayWithModules
{
	int moduleIndex = 0; 
	NSMutableArray* classTypeArray = [[NSMutableArray alloc]init];
	for (Module* eachModule in modules) 
	{
//		NSLog(@"==================");
//		NSLog([eachModule code]);
//		NSLog(@"==================");
		if ([eachModule checkSelected]) 
		{
			int classTypeIndex = 0;
			for (ModuleClassType* eachModuleClassType in [eachModule moduleClassTypes]) 
			{
//				NSLog(@"==================");
//				NSLog([eachModuleClassType name]);
//				NSLog(@"==================");
//				for (ClassGroup* classGroup in [eachModuleClassType classGroups]) 
//				{
//					for (Slot* eachSlot in [classGroup slots]) {
//						[eachSlot showContents];
//					}
//				}
				NSMutableArray* temp = [[NSMutableArray alloc]init];
				[temp addObject:[NSNumber numberWithInt:moduleIndex]];
				[temp addObject:[NSNumber numberWithInt:classTypeIndex]];
				[temp addObject:[NSNumber numberWithInt:-1]];
				[classTypeArray addObject:temp];
				classTypeIndex++;
			}
		}
		moduleIndex++;
	}
	return classTypeArray;
}

-(NSMutableArray*)copyClassTypeArray:(NSMutableArray*)classTypeArray
{
	NSMutableArray* newClassTypeArray = [[NSMutableArray alloc]init];
	for (NSMutableArray* eachClassType in classTypeArray)
	{
		NSMutableArray* temp =[[NSMutableArray alloc]init];
		for (NSNumber* eachValue in eachClassType) 
		{
			[temp addObject:eachValue];
		}
		[newClassTypeArray addObject:temp];
	}
	return newClassTypeArray;
}

-(NSMutableArray*)planOneTimetable
{
	NSMutableArray* smallClassTypeArray = [self constructClassTypeArrayWithModules];
	NSMutableArray* result = [self constructResult];
	NSMutableArray* timeTable = [self constructInitialTimeTable];
	if ([self getOneTimeTableWithIndex:(int)0
					WithClassTypeArray:&smallClassTypeArray
						 WithTimeTable:&timeTable
							WithResult:result])
		printf("success\n");

	return smallClassTypeArray;
}
							
-(BOOL)getOneTimeTableWithIndex:(int)index
			 WithClassTypeArray:(NSMutableArray**)classTypeArray
				  WithTimeTable:(NSMutableArray**)timeTable
					 WithResult:(NSMutableArray*)result
{
	if (index >= [*classTypeArray count])
		return YES;
	else
	{
		NSMutableArray* classGroups = [self getClassGroupsWithClassTypeArray:*classTypeArray WithIndex:index];
		NSMutableArray* newClassTypeArray = [self copyClassTypeArray:*classTypeArray];
		NSMutableArray* newTimeTable = [self constructNewTimeTableBasedOnTimeTable:*timeTable];
		int groupIndex = 0;
		for (ClassGroup* eachClassGroup in classGroups) 
		{
			if ([self checkPossibilityWithCurrentTimeTable:*timeTable 
										  WithCurrentIndex:index 
									   WithAddInClassGroup:eachClassGroup 
										WithClassTypeArray:*classTypeArray])
			{
				[self addGroup:eachClassGroup WithTimeTable:&newTimeTable];
				[self addGroupWithGroupIndex:groupIndex 
							WithCurrentIndex:index
						  WithClassTypeArray:&newClassTypeArray];
				
					if ([self getOneTimeTableWithIndex:index+1
									WithClassTypeArray:&newClassTypeArray
										 WithTimeTable:&newTimeTable
											WithResult:result]) 
					{
						[*classTypeArray release];
						[*timeTable release];
						*classTypeArray = newClassTypeArray;
						*timeTable = newTimeTable;
						//update timetable and result
						return YES;
					}
			}
			groupIndex++;
		}
		return NO;
	}
}


//return YES if possible
-(BOOL)checkPossibilityWithCurrentTimeTable:(NSMutableArray*)timeTable
						   WithCurrentIndex:(int)index
						WithAddInClassGroup:(ClassGroup*)addInClassGroup
						 WithClassTypeArray:(NSMutableArray*)classTypeArray
{
	if([self clashWithCurrentWithCurrentTimeTable:timeTable
				   WithAddInClassGroup:addInClassGroup]||
	   [self clashWithFutureWithCurrentTimeTable:timeTable
								WithCurrentIndex:(int)index
							 WithAddInClassGroup:addInClassGroup
							  WithClassTypeArray:classTypeArray])
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
-(BOOL)clashWithCurrentWithCurrentTimeTable:(NSMutableArray*)timeTable
			 WithAddInClassGroup:(ClassGroup*)addInClassGroup
{
	int week;
	for (Slot* slot in [addInClassGroup slots]) 
		{ 
			int hour = [[slot startTime]intValue]/100;
			int halfHour = [[slot startTime]intValue]%100/30;
			int startTime = hour*2+halfHour;
			hour = [[slot endTime]intValue]/100;
			halfHour = [[slot endTime]intValue]%100/30;
			int endTime = hour*2+halfHour;
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
						{
							return YES;
						}
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


-(BOOL)clashWithFutureWithCurrentTimeTable:(NSMutableArray*)timeTable
						  WithCurrentIndex:(int)index
					   WithAddInClassGroup:(ClassGroup*)addInClassGroup
						WithClassTypeArray:(NSMutableArray*)classTypeArray
{
	NSMutableArray* newTimeTable = [self constructNewTimeTableBasedOnTimeTable:(NSMutableArray*)timeTable];
	[self addGroup:addInClassGroup WithTimeTable:&newTimeTable];
	int i;
	
	for (i=index+1; i<[classTypeArray count];i++ )
	{
			NSMutableArray* classGroups = [self getClassGroupsWithClassTypeArray:classTypeArray 
																   WithIndex:i]; 
			BOOL conflict = YES;
			for(ClassGroup* eachClassGroup in classGroups)
			{
				BOOL putInConflict = NO;
			
				for (Slot* slot in [eachClassGroup slots]) 
				{
					putInConflict = putInConflict || [self clashWithCurrentWithCurrentTimeTable:newTimeTable
																			WithAddInClassGroup:eachClassGroup];
				}
				
				if(!putInConflict)
				{
					conflict = NO;
					break;
				}
			}
			if(conflict)
			{
				return YES;
			}
	}

	return NO;
}

//update the timeTable with new ClassGroup added in
-(void)addGroup:(ClassGroup*)addInClassGroup
	WithTimeTable:(NSMutableArray**)timeTable
{
	NSArray* slots = [addInClassGroup slots];

	for (Slot* slot in slots) 
	{
		int hour = [[slot startTime]intValue]/100;
		int halfHour = [[slot startTime]intValue]%100/30;
		int startTime = hour*2+halfHour;
		hour = [[slot endTime]intValue]/100;
		halfHour = [[slot endTime]intValue]%100/30;
		int endTime = hour*2+halfHour;		int day = [[slot day]intValue];
		NSNumber* occupied = [NSNumber numberWithInt:1];//occupied
		int i,week;
		week = 0;
		for(NSMutableArray* weekArray in *timeTable)
		{
			if ((week!=0) && ([[[slot frequency]objectAtIndex:week]isEqualToString:@"YES"]))
			{
				NSMutableArray* dayArray = [weekArray objectAtIndex:day];
				for (i=startTime; i<endTime; i++) 
				{
					[dayArray removeObjectAtIndex:i];
					[dayArray insertObject:occupied atIndex:i];
					
				}
			}
			week++;
		}
	}
}

-(void)addGroupWithGroupIndex:(int)groupIndex
			 WithCurrentIndex:(int)currentIndex
		   WithClassTypeArray:(NSMutableArray**)classTypeArray
{
	NSMutableArray* currentClassType = [*classTypeArray objectAtIndex:currentIndex];
	[currentClassType removeObjectAtIndex:2];
	NSNumber* groupNumber = [NSNumber numberWithInt:groupIndex];
	[currentClassType insertObject:groupNumber atIndex:2];
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
			for(j=0;j<48;j++)
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

-(NSMutableArray*)getClassGroupsWithClassTypeArray:(NSMutableArray*)classTypeArray 
										 WithIndex:(int)index
{
	NSMutableArray* currentClassType = [classTypeArray objectAtIndex:index];
	int moduleIndex = [[currentClassType objectAtIndex:0]intValue];
	int classTypeIndex = [[currentClassType objectAtIndex:1]intValue];
	NSMutableArray* classGroups = [[NSMutableArray alloc]initWithArray:[[[[modules objectAtIndex:moduleIndex]moduleClassTypes]objectAtIndex:classTypeIndex]classGroups]];
    return classGroups;
}
													  
-(NSMutableArray*)constructNewTimeTableBasedOnTimeTable:(NSMutableArray*)timeTable
{
	NSNumber *occupied = [NSNumber numberWithInt:0];
	NSNumber *free = [NSNumber numberWithInt:1];
	NSMutableArray* timetable = [[NSMutableArray alloc]init];
	int i ,k;
	for(k=0;k<=14;k++)
	{
		NSMutableArray* week = [[NSMutableArray alloc]init];
		NSMutableArray* weekTemp = [timeTable objectAtIndex:k];
		for(i=0;i<8;i++)
		{
			NSMutableArray* dayTemp = [weekTemp objectAtIndex:i];
			NSMutableArray* day = [[NSMutableArray alloc]init];
			int j = 0;
			for(j=0;j<48;j++)
			{
				if([[dayTemp objectAtIndex:j]isEqualToNumber:occupied])
				[day addObject:occupied];
				else {
					[day addObject:free];
				}

			}
			[week addObject:day];
		}
		[timetable addObject:week];
	}
	return timetable;
	
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
