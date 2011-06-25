//
//  TimeTable.h
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Module.h"
#import "ConstantFile.h"

@interface TimeTable : NSObject {
	
}
@property(nonatomic,retain)NSString* name;
@property(nonatomic,retain)NSMutableArray* modules;
-(NSMutableArray*)planOneTimetable;
-(id)initWithName:(NSString*)naming WithModules:(NSMutableArray*)module;
@end
