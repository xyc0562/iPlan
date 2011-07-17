//
//  IPlanUtility.h
//  iPlan
//
//  Created by Xu Yecheng on 6/20/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstantFile.h"


@interface IPlanUtility : NSObject {

}

+ (NSNumber*) weekOfDayStringToNSNumber:(NSString*)day;
+ (NSArray*) frequencyStringToNSArray:(NSString*)fre;
+ (NSString*) weekOfDayNSNumberToString:(NSNumber*)day;
+ (NSString*) timeIntervalFromStartTime:(NSNumber*)start EndTime:(NSNumber*)end;
+ (NSString*) decodeFrequency:(NSArray*)freArr;
+ (NSDate*) getSemesterStart;
+ (int)getTimeIntervalFromWeek:(int)week Day:(int)day Time:(NSNumber*)time;
+ (NSDate*) LAPIGetSemesterStartFromAY:(NSString*)AY Semester:(NSString*)sem;

@end
