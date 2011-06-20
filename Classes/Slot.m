//
//  Slot.m
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import "Slot.h"


@implementation Slot
@synthesize venue;
@synthesize day;
@synthesize startTime;
@synthesize endTime;
@synthesize groupName;
@synthesize frequency;

-(id)initWithVenue:(NSString*)place WithDay:(NSNumber*)date WithStartTime:(NSNumber*)start WithEndTime:(NSNumber*)end WithGroupName:(NSString*)group WithFrequency:(NSString*)fre;
{
    [super init];
    if(super !=nil)
    {
        venue = place;
        day = date;
        startTime = start;
        endTime = end;
        groupName = group;
        frequency = fre;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{

    [coder encodeObject:venue forKey:@"venue"];
    [coder encodeObject:day forKey:@"day"];
    [coder encodeObject:startTime forKey:@"startTime"];
    [coder encodeObject:endTime forKey:@"endTime"];
}

-(id)initWithCoder:(NSCoder *)decoder{
    if([super init]!=nil){
        [self initWithVenue:[decoder decodeObjectForKey:@"venue"] WithDay:[decoder decodeObjectForKey:@"day"]
              WithStartTime:[decoder decodeObjectForKey:@"startTime"] WithEndTime:[decoder decodeObjectForKey:@"endTime"]];
    }
    return self;
}

-(void)dealloc{
    [venue release];
    [day release];
    [startTime release];
    [endTime release];
    [super dealloc];
}
@end
