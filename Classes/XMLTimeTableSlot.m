//
//  XMLTimeTableSlot.m
//  iPlan
//
//  Created by Xu Yecheng on 6/18/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "XMLTimeTableSlot.h"


@implementation XMLTimeTableSlot

@synthesize type;
@synthesize slot;
@synthesize day;
@synthesize time_start;
@synthesize time_end;
@synthesize venue;
@synthesize frequency;

- (void) debugSlot
{
	/*
    NSLog(@"------ Start XMLTimeTableSlot ------");
    NSLog(@"type, %@", self.type);
    NSLog(@"slot, %@", self.slot);
    NSLog(@"day, %@", self.day);
    NSLog(@"time_start, %@", self.time_start);
    NSLog(@"time_end, %@", self.time_end);
    NSLog(@"venue, %@", self.venue);
    NSLog(@"frequency, %@", self.frequency);
    NSLog(@"------ End XMLTimeTableSlot ------");
	 */
}
@end
