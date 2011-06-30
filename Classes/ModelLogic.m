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

- (NSArray*) getGroupNamesFromModule:(NSString*)code ModuleClassType:(NSString*)type
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
- (NSArray*) getTimesFromModule:(NSString*)code ModuleClassType:(NSString*)type GroupName:(NSString*)name
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
                            NSArray *one_time = [NSArray arrayWithObjects:s.day, s.startTime, s.endTime, nil];
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
    
- (NSArray*) getVenuesFromModule:(NSString*)code ModuleClassType:(NSString*)type GroupName:(NSString*)name
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

- (NSArray*) getFrequenciesFromModule:(NSString*)code ModuleClassType:(NSString*)type GroupName:(NSString*)name
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
- (NSArray*) getExamDatesTogetherWithConflitsInformation
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];

    // space holder
    [arr addObject:@"YES"];

    // Construct array
    for (Module *module in self.timeTable.modules)
    {
        if ([module.selected isEqualToString:MODULE_ACTIVE])
        {
            NSArray *subArr = [NSArray arrayWithObjects:module.code, module.examDate, nil];
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
- (NSArray*) getActiveModules
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


-(void)dealloc
{
    [timeTable release];
    [super dealloc];
}

@end
