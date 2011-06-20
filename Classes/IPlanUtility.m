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
        numDay = [[NSNumber numberWithInt:1] retain];
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

+ (NSNumber*) frequencyStringToNSNumber:(NSString*)fre
{
    NSNumber *freNSNumber;
    if ([fre isEqualToString:@"EVERY WEEK"])
    {
        freNSNumber = [NSNumber numberWithInt:3];
    }
    if ([fre isEqualToString:@"ODD WEEK"])
    {
        freNSNumber = [NSNumber numberWithInt:1];
    }
    if ([fre isEqualToString:@"EVEN WEEK"])
    {
        freNSNumber = [NSNumber numberWithInt:2];
    }

    return freNSNumber;
}

@end
