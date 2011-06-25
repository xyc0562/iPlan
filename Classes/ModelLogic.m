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

+ (NSArray*) getAllModuleCodes
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

-(id)initWithCoder:(NSCoder *)decoder
{
    if([super init]!=nil){
        [self initWithTimeTables:[decoder decodeObjectForKey:@"modules"]];
    }
	return self;
}

-(void)dealloc
{
	[timetables release];
	[super dealloc];
}

@end
