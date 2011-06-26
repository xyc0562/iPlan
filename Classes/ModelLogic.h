//
//  ModelLogic.h
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstantFile.h"
#import "TimeTable.h"

@interface ModelLogic : NSObject
{
    
}
@property(nonatomic, retain)NSMutableArray *timetables;
@property(nonatomic, retain)NSFileManager *fileManager;
@property(nonatomic, retain)NSMutableDictionary *moduleObjectsDict;

- (id) init;

- (NSArray*) getAllModuleCodes;
// effects: return an array of NSString, which is the module code

- (NSString*) getTitleFromModule:(NSString*)code;

- (NSString*) getDescriptionFromModule:(NSString*)code;

- (BOOL) isExaminableFromModule:(NSString*)code;

- (NSString*) getExamDateFromModule:(NSString*)code;

- (BOOL) isOpenbookFromModule:(NSString*)code;

- (NSInteger) getMCFromModule:(NSString*)code;

- (NSString*) getPrerequisitesFromModule:(NSString*)code;

- (NSString*) getPreclusionFromModule:(NSString*)code;

- (NSString*) getWorkloadFromModule:(NSString*)code;

- (NSString*) getRemarksFromModule:(NSString*)code;

- (NSArray*) getGroupNamesFromModule:(NSString*)code ModuleClassType:(NSString*)type;
// requires: a module's code in NSString (this module can be any module)
// effects: return an array of NSString: eg: ['Lecture', 'Tutorial', 'Lab']

- (NSArray*) getGroupNamesFromModule:(NSString*)code ClassType:(NSString*)type;
// requires: the module's code, eg: 'CS1101S' and the class type, eg: 'Tutorial'
// effects: return an array of string; each string represents the group name, eg: "1", or "LG1", "D5"

- (NSArray*) getTimesFromModule:(NSString*)code ClassType:(NSString*)type GroupName:(NSString*)name;
// requires: the module's code, eg: 'CS1101S' and the class type, eg: 'Tutorial'; group name, eg: "LG5", "D5"
// effects: return an array of points; each point represents one time, eg: (3,8) represents: Wed 8:00 -9:00

- (NSArray*) getVenueFromModule:(NSString*)code ClassType:(NSString*)type GroupName:(NSString*)name;
// effects: return an array of NSString; each string represents one venue

- (NSArray*) getFrequenciesFromModule:(NSString*)code ClassType:(NSString*)type GroupName:(NSString*)name;
// effects: return an array of NSString

@end
