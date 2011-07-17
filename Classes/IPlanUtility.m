//
//  IPlanUtility.m
//  iPlan
//
//  Created by Xu Yecheng on 6/20/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IPlanUtility.h"

@implementation IPlanUtility

+ (NSNumber*) weekOfDayStringToNSNumber:(NSString*)day
{
    NSNumber *numDay;

    if ([day isEqualToString:@"MONDAY"])
    {
        numDay = [NSNumber numberWithInt:1];
    }
    else if ([day isEqualToString:@"TUESDAY"])
    {
        numDay = [NSNumber numberWithInt:2];
    }
    else if ([day isEqualToString:@"WEDNESDAY"])
    {
        numDay = [NSNumber numberWithInt:3];
    }
    else if ([day isEqualToString:@"THURSDAY"])
    {
        numDay = [NSNumber numberWithInt:4];
    }
    else if ([day isEqualToString:@"FRIDAY"])
    {
        numDay = [NSNumber numberWithInt:5];
    }
    else if ([day isEqualToString:@"SATURDAY"])
    {
        numDay = [NSNumber numberWithInt:6];
    }
    else if ([day isEqualToString:@"SUNDAY"])
    {
        numDay = [NSNumber numberWithInt:7];
    }
    
    return numDay;
}

+ (NSArray*) frequencyStringToNSArray:(NSString*)fre Weeks:(NSInteger)weeks
{
    weeks = weeks + 1;
    NSMutableArray *freArray = [[NSMutableArray alloc] initWithCapacity:15] ;
    if ([fre isEqualToString:@"EVERY WEEK"])
    {
        for(int i = 0; i < weeks; i++)
        {
            [freArray addObject:@"YES"];
        }
    }
    else if ([fre isEqualToString:@"ODD WEEK"])
    {
        for(int i = 0; i < weeks/2; i++)
        {
            [freArray addObject:@"NO"];
            [freArray addObject:@"YES"];
        }
            [freArray addObject:@"NO"];
    }
    else if ([fre isEqualToString:@"EVEN WEEK"])
    {
        for(int i = 0; i < weeks/2; i++)
        {
            [freArray addObject:@"YES"];
            [freArray addObject:@"NO"];
        }
            [freArray addObject:@"YES"];
    }
    else
        // Now must be irregular weeks
    {
        for (int i = 0; i < weeks; i ++)
        {
            [freArray addObject:@"NO"];
        }
        NSScanner *scanner = [NSScanner scannerWithString:fre] ;
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@",.WEEK "];
        [scanner setCharactersToBeSkipped:set];
        int number ;
        while (![scanner isAtEnd]) {
            if ([scanner scanInt:&number])
            {
                [freArray replaceObjectAtIndex:number withObject:@"YES"];
            }
        }
    }

return [freArray autorelease];
}

+ (NSString*) weekOfDayNSNumberToString:(NSNumber*)day
{
    NSString *dayStr;
    NSInteger dayInt = [day integerValue];

    switch (dayInt)
    {
    case 1:
        dayStr = [NSString stringWithString:@"MONDAY"];
        break;
    case 2:
        dayStr = [NSString stringWithString:@"TUESDAY"];
        break;
    case 3:
        dayStr = [NSString stringWithString:@"WEDNESDAY"];
        break;
    case 4:
        dayStr = [NSString stringWithString:@"THURSDAY"];
        break;
    case 5:
        dayStr = [NSString stringWithString:@"FRIDAY"];
        break;
    case 6:
        dayStr = [NSString stringWithString:@"SATURDAY"];
        break;
    case 7:
        dayStr = [NSString stringWithString:@"SUNDAY"];
        break;
    default:
        dayStr = [NSString stringWithString:@"UNKNOWN"];
    }

    return dayStr;
}

+ (NSString*) timeIntervalFromStartTime:(NSNumber*)start EndTime:(NSNumber*)end
{
    NSMutableString *startStr = [NSMutableString stringWithCapacity:5];
    NSMutableString *endStr = [NSMutableString stringWithCapacity:5];
    [startStr appendString:[start stringValue]];
    [endStr appendString:[end stringValue]];
    NSInteger startIdx = [startStr length] == 3 ? 1 : 2;
    NSInteger endIdx = [endStr length] == 3 ? 1 : 2;

    [startStr insertString:@":" atIndex:startIdx];
    [startStr appendString:@"-"];
    [endStr insertString:@":" atIndex:endIdx];
    
    NSMutableString *result = startStr;
    [result appendString:endStr];
    
    return result;
}

+ (NSString*) decodeFrequency:(NSArray*)freArr
{
    BOOL everyWeek = YES;
    for (int i = 1; i < [freArr count]; i ++)
    {
        if ([[freArr objectAtIndex:i] isEqualToString:@"NO"])
        {
            everyWeek = NO;
            break;
        }
    }
    if (everyWeek)
    {
        return @"EVERY WEEK";
    }

    BOOL oddWeek = YES;
    for (int i = 1; i < [freArr count]; i += 2)
    {
        if (([[freArr objectAtIndex:i] isEqualToString:@"NO"]) || ([[freArr objectAtIndex:i+1] isEqualToString:@"YES"]))
        {
            oddWeek = NO;
            break;
        }
    }
    if (oddWeek)
    {
        return @"ODD WEEK";
    }

    BOOL evenWeek = YES;
    for (int i = 2; i < [freArr count]; i += 2)
    {
        if (([[freArr objectAtIndex:i] isEqualToString:@"NO"]) || ([[freArr objectAtIndex:i-1] isEqualToString:@"YES"]))
        {
            evenWeek = NO;
            break;
        }
    }
    if (evenWeek)
    {
        return @"EVEN WEEK";
    }

    NSMutableString *str = [NSMutableString stringWithString:@"Weeks: "];
    BOOL start = YES;
    for (int i = 1; i < [freArr count]; i ++)
    {
        if ([[freArr objectAtIndex:i] isEqualToString:@"YES"])
        {
            if (!start)
            {
                [str appendString:@","];
            }
            [str appendString:[NSString stringWithFormat:@"%d", i]];
            start = NO;
        }
    }

    return str;
}

// According to NUS academic calendar, sem starts on 2nd Monday of Aug for sem 1 and 1st Monday of Jan for sem2
+ (NSDate*) getSemesterStart
{
    NSDate *today = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:today];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSDate *semesterStart;

    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = @"yyyy-MM-dd";

    // First sem
    if (month >= 3 && month <= 9 )
    {
        semesterStart = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-08-07", year]];
    }
    // Second sem
    else
    {
        semesterStart = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-12-31", year - 1]];
    }

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger weekday;
    do
    {
        semesterStart = [[semesterStart dateByAddingTimeInterval:86400] retain];
        NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:semesterStart];
        weekday = [weekdayComponents weekday];
        // weekday 2 = Monday for Gregorian calendar
    }while(weekday != 2);

    [gregorian release];

    return [semesterStart autorelease];
}

+ (int) getTimeIntervalFromWeek:(int)week Day: (int)day Time:(NSNumber*)time
{
    int32_t interval = 24*3600*7*(week - 1)+24*3600*(day - 1);
	int hour = [time integerValue]/100;
    int min = [time integerValue]%100;
    return interval + hour*3600 + min*60;
}

+ (NSDate*) LAPIGetSemesterStartFromAY:(NSString*)AY Semester:(NSString*)sem
{
    NSString *startYear = [AY substringToIndex:4];
    NSString *endYear = [AY substringFromIndex:5];

    NSDate *semesterStart;

    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = @"yyyy-MM-dd";

    // First sem
    if ([sem isEqualToString:@"1"])
    {
        semesterStart = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-08-07", startYear]];
    }
    // Second sem
    else if ([sem isEqualToString:@"2"])
    {
        semesterStart = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-01-07", endYear]];
    }
    else if ([sem isEqualToString:@"3"])
    {
        semesterStart = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-05-09", endYear]];
    }
    else if ([sem isEqualToString:@"4"])
    {
        semesterStart = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-06-20", endYear]];
    }

    // TODO, special terms

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger weekday;
    do
    {
        semesterStart = [[semesterStart dateByAddingTimeInterval:86400] retain];
        NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:semesterStart];
        weekday = [weekdayComponents weekday];
        // weekday 2 = Monday for Gregorian calendar
    }while(weekday != 2);

    [gregorian release];

    return [semesterStart autorelease];
}

@end
