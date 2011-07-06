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

- (NSMutableArray*) getGroupNamesFromModule:(NSString*)code ModuleClassType:(NSString*)type;
// requires: a module's code in NSString (this module can be any module)
// effects: return an array of NSString: eg: ['Lecture', 'Tutorial', 'Lab']

- (NSMutableArray*) getGroupNamesFromModule:(NSString*)code ModuleClassType:(NSString*)type;
// requires: the module's code, eg: 'CS1101S' and the class type, eg: 'Tutorial'
// effects: return an array of string; each string represents the group name, eg: "1", or "LG1", "D5"

- (NSMutableArray*) getTimesFromModule:(NSString*)code ModuleClassType:(NSString*)type GroupName:(NSString*)name;
// requires: the module's code, eg: 'CS1101S' and the class type, eg: 'Tutorial'; group name, eg: "LG5", "D5"
// effects: return an array(arr) of arrays(subArr); subArr[0] is NSNumber(1-7) representing day, subArr[1] is start time (1530, say), and subArr[2] is end time

- (NSMutableArray*) getVenuesFromModule:(NSString*)code ModuleClassType:(NSString*)type GroupName:(NSString*)name;
// effects: return an array of NSString; each string represents one venue

- (NSMutableArray*) getFrequenciesFromModule:(NSString*)code ModuleClassType:(NSString*)type GroupName:(NSString*)name;
// effects: return an array of NSString

- (void) generateDefaultTimetableFromModules:(NSMutableArray*)modulesSelected Active:(NSMutableArray*)activeIndexes;
// effects: nothing returned but will store the defaultTimetable inside model logic

- (void) generateBasicTimetableFromModules:(NSMutableArray*)modulesSelected Active:(NSMutableArray*)activeIndexes;
// effects: nothing returned but will store the basicTimetable inside model logic

// Not useful, the xml only has examinable to be "-"
- (NSMutableArray*) getExamDatesForActiveModulesTogetherWithConflits;
// Return an NSMutableArray arr:
// arr[0] is a NSString denoting whether there are conflicts in active modules ("YES" or "NO")
// arr[1..n] contains size-2 arrays subArr with subArr[0] denoting module code and subArr[1] denoting exam date
- (NSMutableArray*) getActiveModules;
// requires: nothing
// effects: return all the active modules' code (NSString)

- (NSMutableArray*) getClassTypesFromModuleCode:(NSString*)code;
// requires: a module's code in NSString; 
// effects: return an array of NSString: eg: ['Lecture', 'Tutorial', 'Lab']

- (NSMutableArray*) getSelectedGroupTimesFromActiveModule:(NSString*)code ModuleClassType:(NSString*)type;
// requires: the module's code, eg: 'CS1101S' and the class type, eg: 'Tutorial'; the group type is the one selected in basicTimetable or defaultTimetable
// Returns: same as getTimesFromModule

- (NSMutableArray*) getSelectedGroupVenuesFromActiveModule:(NSString*)code ClassType:(NSString*)type;
// requires: the module's code, eg: 'CS1101S' and the class type, eg: 'Tutorial'; the group type is the one selected in basicTimetable or defaultTimetable
// effects: return an array of NSString; each string represent one venue

- (void) syncModulesWithBasket:(NSMutableArray*)modules;
//sync the modules in timetable with those from basket.

- (NSMutableArray*)getSelectedGroupsInfoFromModules:(NSMutableArray*)modulesSelected Active:(NSMutableArray*)activeIndexes;
//get all selected groups information eg. each slots information
@end
