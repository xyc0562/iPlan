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
@synthesize fileManager;
@synthesize moduleObjectsDict;

- (id) init
{
    [super init];
    if (super != nil)
    {
        if (!fileManager && !moduleObjectsDict)
        {
            self.fileManager = [NSFileManager defaultManager];
            self.moduleObjectsDict = [NSMutableDictionary dictionary];
        }
    }
    return self;
}

-(id)initWithTimeTables:(NSMutableArray*)tables
{
    [super init];
    if(super !=nil)
    {
        if(tables!=nil)
        {
            self.timetables = tables;
        } 
        else 
        {
            self.timetables = [[NSMutableArray alloc]init];
        }
    }
    return self;
}

-(void)addTimeTable:(TimeTable*)timetable
{
	[timetables addObject:timetable];
}

+(NSArray*) getAllModuleCodes
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
        [self initWithTimeTables:[decoder decodeObjectForKey:@"modules"]];
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

- (BOOL) isExaminableFromModule:(NSString*)code
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

- (BOOL) isOpenbookFromModule:(NSString*)code
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

- (NSInteger) getMCFromModule:(NSString*)code
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
        // @tobecontinued
    }
    else
    {
        return nil;
    }

}

- (NSArray*) getTimesFromModule:(NSString*)code ClassType:(NSString*)type GroupName:(NSString*)name
{
          
}
    
- (NSArray*) getVenueFromModule:(NSString*)code ClassType:(NSString*)type GroupName:(NSString*)name
{
          
}

- (NSArray*) getFrequenciesFromModule:(NSString*)code ClassType:(NSString*)type GroupName:(NSString*)name
{
    
}

-(void)dealloc
{
    [timetables release];
    [super dealloc];
}

@end
