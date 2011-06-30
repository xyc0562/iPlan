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
@property(nonatomic, retain)TimeTable *timeTable;
@property(nonatomic, retain)NSMutableDictionary *moduleObjectsDict;


- (NSArray*) getAllModuleCodes;
// effects: return an array of NSString, which is the module code

- (NSString*) getTitleFromModule:(NSString*)code;

- (NSString*) getDescriptionFromModule:(NSString*)code;

- (NSString*) isExaminableFromModule:(NSString*)code;

- (NSString*) getExamDateFromModule:(NSString*)code;

// Not useful, the xml only has open_book to be "Unknown"
- (NSString*) isOpenbookFromModule:(NSString*)code;

- (NSString*) getMCFromModule:(NSString*)code;

- (NSString*) getPrerequisitesFromModule:(NSString*)code;

- (NSString*) getPreclusionFromModule:(NSString*)code;

- (NSString*) getWorkloadFromModule:(NSString*)code;

- (NSString*) getRemarksFromModule:(NSString*)code;

- (NSArray*) getGroupNamesFromModule:(NSString*)code ModuleClassType:(NSString*)type;
// requires: a module's code in NSString (this module can be any module)
// effects: return an array of NSString: eg: ['Lecture', 'Tutorial', 'Lab']

- (NSArray*) getGroupNamesFromModule:(NSString*)code ModuleClassType:(NSString*)type;
// requires: the module's code, eg: 'CS1101S' and the class type, eg: 'Tutorial'
// effects: return an array of string; each string represents the group name, eg: "1", or "LG1", "D5"

- (NSArray*) getTimesFromModule:(NSString*)code ModuleClassType:(NSString*)type GroupName:(NSString*)name;
// requires: the module's code, eg: 'CS1101S' and the class type, eg: 'Tutorial'; group name, eg: "LG5", "D5"
// effects: return an array of points; each point represents one time, eg: (3,8) represents: Wed 8:00 -9:00

- (NSArray*) getVenuesFromModule:(NSString*)code ModuleClassType:(NSString*)type GroupName:(NSString*)name;
// effects: return an array of NSString; each string represents one venue

- (NSArray*) getFrequenciesFromModule:(NSString*)code ModuleClassType:(NSString*)type GroupName:(NSString*)name;
// effects: return an array of NSString

- (void) generateDefaultTimetableFromModules:(NSArray*)modulesSelected Active:(NSArray*)activeIndexes;
// effects: nothing returned but will store the defaultTimetable inside model logic

- (void) generateBasicTimetableFromModules:(NSArray*)modulesSelected Active:(NSArray*)activeIndexes;
// effects: nothing returned but will store the basicTimetable inside model logic

// Not useful, the xml only has examinable to be "-"
- (NSArray*) getExamDatesForActiveModulesTogetherWithConflits;
// Return an NSArray arr:
// arr[0] is a NSString denoting whether there are conflicts in active modules ("YES" or "NO")
// arr[1..n] contains size-2 arrays subArr with subArr[0] denoting module code and subArr[1] denoting exam date
- (NSArray*) getActiveModules;
// requires: nothing
// effects: return all the active modules' code (NSString)

- (NSArray*) getClassTypeFromActiveModule:(NSString*)code;
// requires: a module's code in NSString; 
// effects: return an array of NSString: eg: ['Lecture', 'Tutorial', 'Lab']

- (NSArray*) getSelectedGroupTimesFromActiveModule:(NSString*)code ClassType:(NSString*)type;
// requires: the module's code, eg: 'CS1101S' and the class type, eg: 'Tutorial'; the group type is the one selected in basicTimetable or defaultTimetable
// effects: return an array of points; each point represents one time, eg: (3,8) represents: Wed 8:00 -9:00

- (NSArray*) getSelectedGroupVenuesFromActiveModule:(NSString*)code ClassType:(NSString*)type;
// requires: the module's code, eg: 'CS1101S' and the class type, eg: 'Tutorial'; the group type is the one selected in basicTimetable or defaultTimetable
// effects: return an array of NSString; each string representsk


@end
