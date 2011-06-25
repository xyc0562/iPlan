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

+ (NSArray*) frequencyStringToNSArray:(NSString*)fre
{
    NSMutableArray *freArray = [[NSMutableArray alloc] initWithCapacity:15] ;
    if ([fre isEqualToString:@"EVERY WEEK"])
    {
        for(int i = 0; i < 15; i++)
        {
            [freArray addObject:@"YES"];
        }
    }
    else if ([fre isEqualToString:@"ODD WEEK"])
    {
        for(int i = 0; i < 7; i++)
        {
            [freArray addObject:@"NO"];
            [freArray addObject:@"YES"];
        }
            [freArray addObject:@"NO"];
    }
    else if ([fre isEqualToString:@"EVEN WEEK"])
    {
        for(int i = 0; i < 7; i++)
        {
            [freArray addObject:@"YES"];
            [freArray addObject:@"NO"];
        }
            [freArray addObject:@"YES"];
    }
    else
        // Now must be irregular weeks
    {
        for (int i = 0; i < 15; i ++)
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
                NSLog(@"%i", number);
                [freArray replaceObjectAtIndex:number withObject:@"YES"];
            }
        }
    }

return [freArray autorelease];
}

@end
