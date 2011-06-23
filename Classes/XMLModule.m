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

- (void) debugCurrentModule
{
    NSLog(@"------Start Module------");
    NSLog(@"code: %@", self.code);
    NSLog(@"title: %@", self.title);
    NSLog(@"description: %@", self.description);
    NSLog(@"examinable: %@", self.examinable);
    NSLog(@"open_book: %@", self.open_book);
    NSLog(@"exam_date: %@", self.exam_date);
    NSLog(@"mc: %@", self.mc);
    NSLog(@"prereq: %@", self.prereq);
    NSLog(@"preclude: %@", self.preclude);
    NSLog(@"workload: %@", self.workload);
    NSLog(@"remarks: %@", self.remarks);
    NSLog(@"last_updated: %@", self.last_updated);
    for (XMLTimeTableSlot* slot in self.timeTableSlots)
    {
        [slot debugSlot];
    }
    NSLog(@"------End Module------");
}

- (void) dealloc
{
    for (XMLTimeTableSlot* slot in self.timeTableSlots)
    {
        [slot release];
    }
    
    [super dealloc];
}

@end
