//
//  XMLModule.m
//  iPlan
//
//  Created by Xu Yecheng on 6/18/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "XMLModule.h"


@implementation XMLModule

@synthesize code;
@synthesize title;
@synthesize description;
@synthesize examinable;
@synthesize open_book;
@synthesize exam_date;
@synthesize mc;
@synthesize prereq;
@synthesize workload;
@synthesize remarks;
@synthesize last_updated;
@synthesize preclude;
@synthesize timeTableSlots;

- (void)addTimeTableSlot:(XMLTimeTableSlot *)timeTableSlot
{
    if (!timeTableSlots)
    {
        timeTableSlots = [[NSMutableArray alloc] init];
    }
    [timeTableSlots addObject:timeTableSlot];
}

@end
