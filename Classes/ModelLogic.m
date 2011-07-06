//
//  ModelLogic.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import "ModelLogic.h"


@implementation ModelLogic
@synthesize timeTable;
@synthesize moduleObjectsDict;

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

-(id)initWithTimeTable:(TimeTable*)table
{
    [super init];
    if(super !=nil)
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
                return [arr autorelease];
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
                        return [arr autorelease];
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
                        return [arr autorelease];
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
                        return [arr autorelease];
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

    return [arr autorelease];
}

// Not retained!
- (NSMutableArray*) getActiveModules
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
    for (Module *module in self.timeTable.modules)
    {
        if ([module.selected isEqualToString:MODULE_ACTIVE])
        {
            [arr addObject:module.code];
        }
    }

    return [arr autorelease];
}

- (void) syncModulesWithBasket:(NSMutableArray*)modules
{
	[timeTable release];
	timeTable = [[TimeTable alloc]initWithName:@"MyTimeTable"WithModules:modules];
}

- (void) generateDefaultTimetableFromModules:(NSMutableArray*)modulesSelected Active:(NSMutableArray*)activeIndexes
{
	for (NSNumber* index in activeIndexes) 
	{
		Module* selectedModule = [modulesSelected objectAtIndex:[index intValue]];
		selectedModule.selected = @"YES";
	}
	timeTable.modules = modulesSelected;
	[timeTable planOneTimetable];
}
- (NSMutableArray*)getSelectedGroupsInfoFromModules:(NSMutableArray*)modulesSelected Active:(NSMutableArray*)activeIndexes
{
	NSMutableArray* selectedGroupsInfo = [[NSMutableArray alloc]init];
	for (NSMutableArray* eachSelected in timeTable.result) 
	{
		NSDictionary* resultDict = [[NSDictionary alloc]init];
		NSNumber* moduleIndex = [eachSelected objectAtIndex:0];
		NSNumber* classTypeIndex = [eachSelected objectAtIndex:1];
		NSNumber* classGroupIndex =	[eachSelected objectAtIndex:2];
		
		Module* module = [modulesSelected objectAtIndex:[moduleIndex intValue]];
		NSString* moduleCode = [module code];
		ModuleClassType* classType = [[module moduleClassTypes]objectAtIndex:[classTypeIndex intValue]];
		NSString* classTypeName = [classType name];
		ClassGroup* classGroup = [[classType classGroups] objectAtIndex:[classGroupIndex intValue]];
		NSString* groupName = [classGroup name];
		[resultDict setValue:moduleCode forKey:@"moduleCode"];
		[resultDict setValue:classTypeName forKey:@"classTypeName"];
		[resultDict setValue:groupName forKey:@"groupName"];
		NSMutableArray* slotInfo = [[NSMutableArray alloc]init];
		for (Slot* slot in [classGroup slots]) 
		{
			NSDictionary* slotDict = [[NSDictionary alloc]init];
			[slotDict setValue:[slot venue] forKey:@"venue"];
			[slotDict setValue:[[slot day]stringValue] forKey:@"day"];
			NSString* startTime = [[slot startTime]stringValue];
			NSString* endTime = [[slot endTime]stringValue];
			[slotDict setValue:startTime forKey:@"startTime"];
			[slotDict setValue:endTime forKey:@"endTime"];
			[slotInfo addObject:slotDict];
		}
		[resultDict setValue:slotInfo forKey:@"slots"];
		[selectedGroupsInfo addObject:resultDict];
	}
	return selectedGroupsInfo;
}

- (void) generateBasicTimetableFromModules:(NSMutableArray*)modulesSelected Active:(NSMutableArray*)activeIndexes;
{
    
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
        return [arr autorelease];
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
                        return [[self getTimesFromModule:code ModuleClassType:type GroupName:CG.name] autorelease];
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
                        return [arr autorelease];
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

-(void)dealloc
{
    [timeTable release];
    [super dealloc];
}

@end
