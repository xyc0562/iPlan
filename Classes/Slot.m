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

-(id)initWithVenue:(NSString*)place WithDay:(NSNumber*)date WithStartTime:(NSNumber*)start WithEndTime:(NSNumber*)end WithGroupName:(NSString*)group WithFrequency:(NSArray*)fre;
{
    [super init];
    if(super !=nil)
    {
        venue = place;
        day = date;
        startTime = [NSNumber numberWithInt:([start intValue]/100)];
        endTime =  [NSNumber numberWithInt:([end intValue]/100)];
        groupName = group;
        frequency = fre;
		[self showContents];
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
              WithStartTime:[decoder decodeObjectForKey:@"startTime"] WithEndTime:[decoder decodeObjectForKey:@"endTime"]
              WithGroupName:[decoder decodeObjectForKey:@"groupName"] WithFrequency:[decoder decodeObjectForKey:@"frequency"]];
    }
    return self;
}

- (void) showContents
{
    NSLog(@"++++++ Start of Slot ++++++");
    NSLog(@"venue: %@", self.venue);
    NSLog(@"day: %d", [self.day integerValue]);
    NSLog(@"startTime: %d", [self.startTime integerValue]);
    NSLog(@"endTime: %d", [self.endTime integerValue]);
    NSLog(@"groupName: %@", self.groupName);
    NSLog(@"---- Start Frequency ----");
    for (NSString *fre in self.frequency)
    {
        NSLog(@"%@", fre);
    }
    NSLog(@"---- End Frequency ----");
    NSLog(@"++++++ End of Slot ++++++");
}

-(void)dealloc{
    [venue release];
    [day release];
    [startTime release];
    [endTime release];
    [super dealloc];
}
@end
