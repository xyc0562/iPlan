//
//  ModelLogic.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import "ModelLogic.h"

static ModelLogic* modelLogic;
@implementation ModelLogic
@synthesize timeTable;
@synthesize moduleObjectsDict;
@synthesize currentColorIndex;

+ (id)modelLogic
{
	if (modelLogic==nil)
	{
		modelLogic = [[ModelLogic alloc]init];
	}
	return modelLogic;
}

- (Module*)getOrCreateAndGetModuleInstanceByCode:(NSString*)code
{
    Module *module = [self.moduleObjectsDict objectForKey:code];
    if (!module)
    {
        module = [Module ModuleWithModuleCode:code];
        if (module)
        {
            [self.moduleObjectsDict setValue:module forKey:code];
        }
    }

    return module;
}

- (ModuleClassType*)getOrCreateClassTypeInstanceByCode:(NSString*)code 
										   WithClassTypeName:(NSString*)type
{
    ModuleClassType* classType = [self.moduleObjectsDict objectForKey:[code stringByAppendingString:type]];
    if (!classType)
    {
		Module* module = [Module ModuleWithModuleCode:code];
		if (module)
		{
			for (ModuleClassType* eachType in [module moduleClassTypes]) 
			{
				if ([[eachType name]isEqualToString:type])
					{
						[moduleObjectsDict setValue:eachType forKey:[code stringByAppendingString:type]];
						return eachType;
					}
			}
        }
    }
	return classType;
}


- (ClassGroup*)getOrCreateClassGroupInstanceByCode:(NSString*)code 
								   WithClassTypeName:(NSString*)type
								 WithClassGroupName:(NSString*)group
{
	NSString* key = [[code stringByAppendingString:type]stringByAppendingString:group];
	ClassGroup* classGroup = [self.moduleObjectsDict objectForKey:key];
	if (!classGroup)
	  {
		  Module* module = [Module ModuleWithModuleCode:code];
		  if (module)
		  {
			  for (ModuleClassType* eachType in [module moduleClassTypes]) 
			  {
				  if ([[eachType name]isEqualToString:type])
				  {
					  for (ClassGroup* eachGroup in [eachType classGroups]) 
					  {
						  if ([[eachGroup name]isEqualToString:group]) 
						  {
							  [moduleObjectsDict setValue:eachType forKey:key];
							  return eachGroup;
						  }
					  }
					  
				  }
			  }
		  }
	  }
	return classGroup;
}
							 
-(id)initWithTimeTable:(TimeTable*)table
{
//  [super init];
//initiallize the 10 colors for module displaying
    if(super != nil)
    {
        self.timeTable = table;
        if (!moduleObjectsDict)
        {
            self.moduleObjectsDict = [NSMutableDictionary dictionary];
        }
        for (Module* m in self.timeTable.modules)
        {
            [self getOrCreateAndGetModuleInstanceByCode:m.code];
        }
    }
    return self;
}

-(id)init
{
    [super init];
    if(super !=nil)
    {
        if (!moduleObjectsDict)
        {
            self.moduleObjectsDict = [NSMutableDictionary dictionary];
        }
    }
    return self;
}
    
- (NSArray*) getAllModuleCodes
{
    // Get directory path that stores the module objects
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *modulesDirectory= [[documentDirectory stringByAppendingString:@"/"] stringByAppendingString:MODULE_DOCUMENT_NAME];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableArray *moduleNames = [fm contentsOfDirectoryAtPath:modulesDirectory error:nil];
    
    int count = [moduleNames count], i;
    for(i = 0; i < count; i++)
    {
        // Trimming ".plist"
        NSString *moduleCode = [[moduleNames objectAtIndex:i] substringToIndex:[[moduleNames objectAtIndex:i] length] - 6];
		[moduleNames replaceObjectAtIndex:i withObject:moduleCode];
    }

    return moduleNames;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if([super init]!=nil)
    {
        [self initWithTimeTable:[decoder decodeObjectForKey:@"modules"]];
    }
    return self;
}

- (NSString*) getTitleFromModule:(NSString*)code
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (module)
    {
        return module.title;
    }
    else
    {
        return nil;
    }
}

- (NSString*) getDescriptionFromModule:(NSString*)code
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];
    
    if (module)
    {
        return module.description;
    }
    else
    {
        return nil;
    }
}

- (NSString*) isExaminableFromModule:(NSString*)code
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (module)
    {
        return module.examinable;
    }
    else
    {
        return nil;
    }
}

- (NSString*) getExamDateFromModule:(NSString*)code
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (module)
    {
        return module.examDate;
    }
    else
    {
        return nil;
    }
}

- (NSString*) isOpenbookFromModule:(NSString*)code
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (module)
    {
        return module.openBook;
    }
    else
    {
        return nil;
    }
}

- (NSString*) getMCFromModule:(NSString*)code
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (module)
    {
        return module.moduleCredit;
    }
    else
    {
        return nil;
    }
}

- (NSString*) getPrerequisitesFromModule:(NSString*)code
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (module)
    {
        return module.prerequisite;
    }
    else
    {
        return nil;
    }
}

- (NSString*) getPreclusionFromModule:(NSString*)code
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (module)
    {
        return module.preclusion;
    }
    else
    {
        return nil;
    }
}

- (NSString*) getWorkloadFromModule:(NSString*)code
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (module)
    {
        return module.workload;
    }
    else
    {
        return nil;
    }
}

- (NSString*) getRemarksFromModule:(NSString*)code
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (module)
    {
        return module.remarks;
    }
    else
    {
        return nil;
    }
}

- (NSArray*) getModuleClassTypesFromModule:(NSString*)code
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (module)
    {
        return module.moduleClassTypes;
    }
    else
    {
        return nil;
    }
}

- (NSMutableArray*) getGroupNamesFromModule:(NSString*)code ModuleClassType:(NSString*)type
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (module)
    {
        NSArray *classTypes = module.moduleClassTypes;
        for (ModuleClassType* MCT in classTypes)
        {
            if ([MCT.name isEqualToString:type])
            {
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
                for (ClassGroup* CG in MCT.classGroups)
                {
                    [arr addObject:CG.name];
                }
                return arr;
            }
        }
        // If such a type not found, return nil
        return nil;
    }
    else
    {
        return nil;
    }
}

// Not retained!
- (NSMutableArray*) getTimesFromModule:(NSString*)code ModuleClassType:(NSString*)type GroupName:(NSString*)name
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (module)
    {
        NSArray *classTypes = module.moduleClassTypes;
        for (ModuleClassType* MCT in classTypes)
        {
            if ([MCT.name isEqualToString:type])
            {
                for (ClassGroup *CG in MCT.classGroups)
                {
                    if ([CG.name isEqualToString:name])
                    {
                        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
                        for (Slot *s in CG.slots)
                        {
                            NSMutableArray *one_time = [NSMutableArray arrayWithObjects:s.day, s.startTime, s.endTime, nil];
                            [arr addObject:one_time];
                        }
                        return arr;
                    }
                }
                return nil;
            }
        }

        // If such a type is not found, return nil
        return nil;
    }
    else
    {
        return nil;
    }
}
    
- (NSMutableArray*) getVenuesFromModule:(NSString*)code ModuleClassType:(NSString*)type GroupName:(NSString*)name
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (module)
    {
        NSArray *classTypes = module.moduleClassTypes;
        for (ModuleClassType* MCT in classTypes)
        {
            if ([MCT.name isEqualToString:type])
            {
                for (ClassGroup *CG in MCT.classGroups)
                {
                    if ([CG.name isEqualToString:name])
                    {
                        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
                        for (Slot *s in CG.slots)
                        {
                            [arr addObject:s.venue];
                        }
                        return arr;
                    }
                }
                return nil;
            }
        }
        // If such a type is not found, return nil
        return nil;
    }
    else
    {
        return nil;
    }
}

- (NSMutableArray*) getFrequenciesFromModule:(NSString*)code ModuleClassType:(NSString*)type GroupName:(NSString*)name
{
    Module *module = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (module)
    {
        NSArray *classTypes = module.moduleClassTypes;
        for (ModuleClassType* MCT in classTypes)
        {
            if ([MCT.name isEqualToString:type])
            {
                for (ClassGroup *CG in MCT.classGroups)
                {
                    if ([CG.name isEqualToString:name])
                    {
                        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
                        for (Slot *s in CG.slots)
                        {
                            [arr addObject:s.frequency];
                        }
                        return arr;
                    }
                }
                return nil;
            }
        }
        // If such a type is not found, return nil
        return nil;
    }
    else
    {
        return nil;
    }
}

// Not retained!
- (NSMutableArray*) getExamDatesForActiveModulesTogetherWithConflits
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];

    // space holder
    [arr addObject:@"YES"];

    // Construct array
    for (Module *module in self.timeTable.modules)
    {
        if ([module.selected isEqualToString:MODULE_ACTIVE])
        {
            NSMutableArray *subArr = [NSMutableArray arrayWithObjects:module.code, module.examDate, nil];
            [arr addObject:subArr];
        }
    }

    // Finding conflicts
    NSString *conflict = @"NO";
    for (int i = 1; i < [arr count]; i++)
    {
        for (int j = i + 1; j < [arr count]; j++)
        {
            if (![[arr objectAtIndex:i] isEqualToString:MODULE_EXAM_NO_EXAM] && [[arr objectAtIndex:i] isEqualToString:[arr objectAtIndex:j]])
            {
                conflict = @"YES";
            }
        }
    }

    [arr replaceObjectAtIndex:0 withObject:conflict];

    return arr;
}

// Not retained!
- (NSMutableArray*) getActiveModules
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:MODULE_ACTIVE_NUMBER];
    for (Module *module in self.timeTable.modules)
    {
        if ([module.selected isEqualToString:MODULE_ACTIVE])
        {
            [arr addObject:module.code];
        }
    }

    return arr;
}

- (void) syncModulesWithBasket:(NSMutableArray*)codes{
	[timeTable release];
	[self resetColorIndex];
	NSMutableArray* modules= [[NSMutableArray alloc]init];
	for (NSString* code in codes) {
		Module* module = [self getOrCreateAndGetModuleInstanceByCode:code];
		module.color = [self getNewColor];
//		NSLog(@"get new color %@",[module color]);
		module.selected = @"YES";
		[modules addObject:module];
	}
	timeTable = [[TimeTable alloc]initWithName:@"MyTimeTable"WithModules:modules];
}

//- (void) syncModulesWithBasket:(NSMutableArray*)modules
//{
//	[timeTable release];
//	timeTable = [[TimeTable alloc]initWithName:@"MyTimeTable"WithModules:modules];
//}

- (void) generateDefaultTimetable
{
	[timeTable planOneTimetable];
}

- (void) generateDefaultTimetableWithRequirements:(NSMutableArray*)requirements
{
	[timeTable planOneTimetableWithRequirements:requirements];
}

- (void) generateNextDefaultTimetableWithRequirements:(NSMutableArray*)requirements
{
	NSMutableArray* result = [timeTable copyClassTypeArray:[timeTable result]];
	[timeTable planOneTimetableWithRequirements:requirements WithResult:result];
}

- (NSMutableArray*)getSelectedGroupsInfo//FromModules:(NSMutableArray*)modulesSelected
{
	
	NSMutableArray* selectedGroupsInfo = [[NSMutableArray alloc]init];
	for (NSMutableArray* eachSelected in timeTable.result) 
	{
		NSMutableDictionary* resultDict = [[NSMutableDictionary alloc]init];
		NSNumber* moduleIndex = [eachSelected objectAtIndex:0];
		NSNumber* classTypeIndex = [eachSelected objectAtIndex:1];
		NSNumber* classGroupIndex =	[eachSelected objectAtIndex:2];
		
		Module* module = [[timeTable modules] objectAtIndex:[moduleIndex intValue]];
		NSString* moduleCode = [module code];
		ModuleClassType* classType = [[module moduleClassTypes]objectAtIndex:[classTypeIndex intValue]];
		NSString* classTypeName = [classType name];
		ClassGroup* classGroup = [[classType classGroups] objectAtIndex:[classGroupIndex intValue]];
		NSString* groupName = [classGroup name];
		[resultDict setValue:moduleCode forKey:@"moduleCode"];
		[resultDict setValue:classTypeName forKey:@"classTypeName"];
		[resultDict setValue:groupName forKey:@"classGroupName"];
		[resultDict setValue:[module color] forKey:@"color"];
		[resultDict setValue:classGroupIndex forKey:@"groupIndex"];
		NSMutableArray* slotInfo = [[NSMutableArray alloc]init];
		for (Slot* slot in [classGroup slots]) 
		{
			NSMutableDictionary* slotDict = [[NSMutableDictionary alloc]init];
			[slotDict setValue:[slot venue] forKey:@"venue"];
			[slotDict setValue:[[slot day]stringValue] forKey:@"day"];
			int sTime = [[slot startTime]intValue];
			int eTime = [[slot endTime]intValue];
			if (sTime/100 == 30) sTime = sTime+20;
			if (eTime/100 == 30) eTime = eTime+20;
			NSNumber* startTime = [NSNumber numberWithInt:sTime];
			NSNumber* endTime = [NSNumber numberWithInt:eTime];
			[slotDict setValue:startTime forKey:@"startTime"];
			[slotDict setValue:endTime forKey:@"endTime"];
			int frequency = 0;
			for (NSString* eachWeek in [slot frequency]) 
			{
				frequency = frequency<<1;
				if (eachWeek == @"YES") frequency++;
			}
			NSNumber* freq = [NSNumber numberWithInt:frequency];
			NSLog(@"freq%@",[freq stringValue]);
			[slotDict setValue:freq forKey:@"frequency"];
			[slotInfo addObject:slotDict];
		}
		[resultDict setValue:slotInfo forKey:@"slots"];
		[selectedGroupsInfo addObject:resultDict];
	}
	return selectedGroupsInfo;
}

- (NSMutableArray*)getOtherAvailableGroupsWithModuleCode:(NSString*)code
									 WithClassTypeIndex:(NSString*)classTypeName
										  WithGroupName:(NSString*)groupName
{
	NSMutableArray* otherAvailableGroups= [[NSMutableArray alloc]init];
	Module* module = [self getOrCreateAndGetModuleInstanceByCode:code];
	ModuleClassType* classType = [self getOrCreateClassTypeInstanceByCode:code WithClassTypeName:classTypeName];
	int classGroupIndex =0;
	for (ClassGroup* eachGroup in [classType classGroups]) 
	{
		if (![[eachGroup name]isEqualToString:groupName] ) 
		{
			NSMutableDictionary* resultDict = [[NSMutableDictionary alloc]init];
			[resultDict setValue:code forKey:@"moduleCode"];
			[resultDict setValue:classTypeName forKey:@"classTypeName"];
			[resultDict setValue:[eachGroup name] forKey:@"classGroupName"];
			[resultDict setValue:[module color] forKey:@"color"];
			[resultDict setValue:[NSNumber numberWithInt:classGroupIndex] forKey:@"groupIndex"];
			NSMutableArray* slotInfo = [[NSMutableArray alloc]init];
			
			for (Slot* slot in [eachGroup slots]) 
			{
				NSMutableDictionary* slotDict = [[NSMutableDictionary alloc]init];
				[slotDict setValue:[slot venue] forKey:@"venue"];
				[slotDict setValue:[[slot day]stringValue] forKey:@"day"];
				int sTime = [[slot startTime]intValue];
				int eTime = [[slot endTime]intValue];
				if (sTime/100 == 30) sTime = sTime+20;
				if (eTime/100 == 30) eTime = eTime+20;
				NSNumber* startTime = [NSNumber numberWithInt:sTime];
				NSNumber* endTime = [NSNumber numberWithInt:eTime];
				[slotDict setValue:startTime forKey:@"startTime"];
				[slotDict setValue:endTime forKey:@"endTime"];
				
				[slotInfo addObject:slotDict];
			}
			//printf("available slots in model logic %d\n",[slotInfo count]);
			[resultDict setValue:slotInfo forKey:@"slots"];
			[otherAvailableGroups addObject:resultDict];
		}
		
		classGroupIndex++;
	}
	return otherAvailableGroups;
}

// Not retained!
- (NSMutableArray*) getClassTypesFromModuleCode:(NSString*)code
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
    Module *m = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (m)
    {
        for (ModuleClassType *MCT in m.moduleClassTypes)
        {
            [arr addObject:MCT.name];
        }
        return arr;
    }
    else
    {
        return nil;
    }

}

// Not retained!
- (NSMutableArray*) getSelectedGroupTimesFromActiveModule:(NSString*)code ModuleClassType:(NSString*)type
{
    Module *m = [self getOrCreateAndGetModuleInstanceByCode:code];
    if (m)
    {
        for (ModuleClassType *MCT in m.moduleClassTypes)
        {
            if ([MCT.name isEqualToString:type])
            {
                for (ClassGroup *CG in MCT.classGroups)
                {
                    if ([CG.selected isEqualToString:MODULE_ACTIVE])
                    {
                        return [self getTimesFromModule:code ModuleClassType:type GroupName:CG.name];
                    }
                }
            }
        }

        return nil;
    }
    else
    {
        return nil;
    }
    
}

// Not retained!
- (NSMutableArray*) getSelectedGroupVenuesFromActiveModule:(NSString*)code ClassType:(NSString*)type
{
    Module *m = [self getOrCreateAndGetModuleInstanceByCode:code];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];

    if (m)
    {
        for (ModuleClassType *MCT in m.moduleClassTypes)
        {
            if ([MCT.name isEqualToString:type])
            {
                for (ClassGroup *CG in MCT.classGroups)
                {
                    if ([CG.selected isEqualToString:MODULE_ACTIVE])
                    {
                        for (Slot *s in CG.slots)
                        {
                            [arr addObject:s.venue];
                        }
                        return arr;
                    }
                }
            }
        }

        return nil;
    }
    else
    {
        return nil;
    }
}

- (NSArray*)getModuleInfoIntoArray:(NSString*)code
{
    Module *m = [self getOrCreateAndGetModuleInstanceByCode:code];

    if (m)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
        [arr addObject:[NSString stringWithFormat:@"Code: %@", m.code]];
        [arr addObject:[NSString stringWithFormat:@"Title: %@", m.title]];
        [arr addObject:[NSString stringWithFormat:@"Description: %@", m.description]];
        [arr addObject:[NSString stringWithFormat:@"Examinable: %@", m.examinable]];
        [arr addObject:[NSString stringWithFormat:@"Openbook: %@", m.openBook]];
        [arr addObject:[NSString stringWithFormat:@"Examdate: %@", m.examDate]];
        [arr addObject:[NSString stringWithFormat:@"Module Credit: %@", m.moduleCredit]];
        [arr addObject:[NSString stringWithFormat:@"Prerequisite: %@", m.prerequisite]];
        [arr addObject:[NSString stringWithFormat:@"Preclusion: %@", m.preclusion]];
        [arr addObject:[NSString stringWithFormat:@"Workload: %@", m.workload]];
        [arr addObject:[NSString stringWithFormat:@"Remarks: %@", m.remarks]];

        NSArray *classTypes = [self getClassTypesFromModuleCode:code];
        for (NSString *MCTName in classTypes)
        {
            NSMutableString *info = [NSMutableString stringWithCapacity:20];
            [info appendString:MCTName];
            [info appendString:@":\n"];

            NSArray *groupNames = [self getGroupNamesFromModule:code ModuleClassType:MCTName];
            for (NSString *groupName in groupNames)
            {
                [info appendString:@"Group "];
                [info appendString:groupName];
                [info appendString:@": "];
                NSArray *timeArrs = [self getTimesFromModule:code ModuleClassType:MCTName GroupName:groupName];
                NSArray *venues = [self getVenuesFromModule:code ModuleClassType:MCTName GroupName:groupName];
                NSArray *frequencies = [self getFrequenciesFromModule:code ModuleClassType:MCTName GroupName:groupName];
                    
                for (int i = 0; i < [timeArrs count]; i ++)
                {
                    NSArray *timeArr = [timeArrs objectAtIndex:i];
                    NSString *venue = [venues objectAtIndex:i];
                    NSArray *frequency = [frequencies objectAtIndex:i];

                    NSString *day = [IPlanUtility weekOfDayNSNumberToString:[timeArr objectAtIndex:0]];
                    NSString *interval = [IPlanUtility timeIntervalFromStartTime:[timeArr objectAtIndex:1] EndTime:[timeArr objectAtIndex:2]];
                    NSMutableString *groupInfo = [NSMutableString stringWithFormat:@"%@: %@, %@, ", day, interval, venue];
                    [groupInfo appendString:[IPlanUtility decodeFrequency:frequency]];
                    [groupInfo appendString:@";\n"];
                    [info appendString:groupInfo];
                }
            }
            [arr addObject:info];
        }

        return arr;
    }
    else
    {
        return nil;
    }
}

- (UIColor*)getNewColor
{
	UIColor* color = [colorList objectAtIndex:[currentColorIndex intValue]];
	self.currentColorIndex = [NSNumber numberWithInt:[currentColorIndex intValue]+1];
	return color;
}

- (void)resetColorIndex
{
	currentColorIndex = [NSNumber numberWithInt:0];
}

- (BOOL)exportTimetableToiCalendar
{
    if (!self.timeTable)
    {
        return NO;
    }

    NSDate *semesterStart = [IPlanUtility getSemesterStart];
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    for (Module *m in self.timeTable.modules)
    {
        if ([m.selected isEqualToString:MODULE_ACTIVE])
        {
            for (ModuleClassType *MCT in m.moduleClassTypes)
            {
                for (ClassGroup *CG in MCT.classGroups)
                {
                    if ([CG.selected isEqualToString:MODULE_ACTIVE])
                    {
                        for (Slot *s in CG.slots)
                        {
                            for (int i = 1; i < [s.frequency count]; i ++)
                            {
                                if ([[s.frequency objectAtIndex:i] isEqualToString:MODULE_ACTIVE])
                                {
                                    EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB];

                                    myEvent.title     = [NSString stringWithFormat:@"%@[%@] %@", m.code, CG.name, MCT.name];
                                    int startInterval = [IPlanUtility getTimeIntervalFromWeek:i Time:s.startTime];
                                    int endInterval = [IPlanUtility getTimeIntervalFromWeek:i Time:s.endTime];
                                    myEvent.startDate = [semesterStart dateByAddingTimeInterval:startInterval];
                                    myEvent.endDate = [semesterStart dateByAddingTimeInterval:endInterval];
                                    myEvent.notes = [IPlanUtility decodeFrequency:s.frequency];
                                    myEvent.allDay = NO;

                                    // For now we use the default calendar, we may change to other specific calendars later
                                    [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    [eventDB release];

    return YES;
}

- (UIColor*)getModuleColorWithModuleCode:(NSString*)moduleCode
{
	Module *module = [self getOrCreateAndGetModuleInstanceByCode:moduleCode];
	
    if (module)
    {
        return [module color];
    }
    else
    {
        return nil;
    }
	
}

-(void)dealloc
{
    [timeTable release];
    [super dealloc];
}

@end
