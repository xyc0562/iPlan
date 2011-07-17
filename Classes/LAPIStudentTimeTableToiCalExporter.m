//
//  LAPIStudentTimeTableToiCalExporter.m
//  iPlan
//
//  Created by Xu Yecheng on 7/16/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "LAPIStudentTimeTableToiCalExporter.h"


@implementation LAPIStudentTimeTableToiCalExporter

@synthesize acadYear;
@synthesize classNo;
@synthesize dayCode;
@synthesize endTime;
@synthesize lessonType;
@synthesize moduleCode;
@synthesize semester;
@synthesize startTime;
@synthesize venue;
@synthesize weekText;
@synthesize currentProperty;

- (id) delegate
{
    return _delegate;
}
- (void) setDelegate:(id)new_delegate
{
    _delegate = new_delegate;
}

// Assuming data is valid!
- (id) initWithNSDataParseAndExport:(NSData*)data
{
    [super init];
    if(super !=nil)
    {
        if (LAPIStudentTimeTableParser)
        {
            [LAPIStudentTimeTableParser release];
        }
        LAPIStudentTimeTableParser = [[NSXMLParser alloc] initWithData:data];
        [LAPIStudentTimeTableParser setDelegate:self];
        [LAPIStudentTimeTableParser setShouldResolveExternalEntities:YES];
        [LAPIStudentTimeTableParser setShouldProcessNamespaces:NO]; // We don't care about namespaces
        [LAPIStudentTimeTableParser setShouldReportNamespacePrefixes:NO]; //
        [LAPIStudentTimeTableParser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
        //NSLog(@"begin parsing");
        [LAPIStudentTimeTableParser parse];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.currentProperty)
    {
        // Remove the annoying <CR> suffix, -_- 
        NSString *CR = [NSString stringWithFormat:@"%c", 10];
        if ([[string substringFromIndex:[string length] - 1] isEqualToString:CR])
        {
            string = [string substringToIndex:[string length] - 1];
        }
        [self.currentProperty appendString:string];
        //NSLog(@"!%@!", currentProperty);
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentProperty = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (qName)
    {
        elementName = qName;
    }

    if ([elementName isEqualToString:@"AcadYear"])
    {
        self.acadYear = self.currentProperty;
    }
    else if ([elementName isEqualToString:@"ClassNo"])
    {
        self.classNo = self.currentProperty;
    }
    else if ([elementName isEqualToString:@"DayCode"])
    {
        self.dayCode = self.currentProperty;
    }
    else if ([elementName isEqualToString:@"EndTime"])
    {
        self.endTime = self.currentProperty;
    }
    else if ([elementName isEqualToString:@"LessonType"])
    {
        self.lessonType = self.currentProperty;
    }
    else if ([elementName isEqualToString:@"ModuleCode"])
    {
        self.moduleCode = self.currentProperty;
    }
    else if ([elementName isEqualToString:@"Semester"])
    {
        self.semester = self.currentProperty;
    }
    else if ([elementName isEqualToString:@"StartTime"])
    {
        self.startTime = self.currentProperty;
    }
    else if ([elementName isEqualToString:@"Venue"])
    {
        self.venue = self.currentProperty;
    }
    else if ([elementName isEqualToString:@"WeekText"])
    {
        self.weekText = self.currentProperty;
    }
    // Start exporting
    else if ([elementName isEqualToString:@"Data_Timetable_Student"])
    {
        NSDate *semesterStart = [IPlanUtility LAPIGetSemesterStartFromAY:self.acadYear Semester:self.semester];
        EKEventStore *eventDB = [[EKEventStore alloc] init];
        int weeks = [self.semester integerValue] > 2 ? NUMBER_OF_WEEKS_FOR_SPECIAL_TERM : NUMBER_OF_WEEKS_FOR_NORMAL_SEMESTER;
        NSArray *freArr = [IPlanUtility frequencyStringToNSArray:self.weekText Weeks:weeks];

        for (int i = 1; i < [freArr count]; i ++)
        {
            EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB];
            myEvent.title     = [NSString stringWithFormat:@"%@[%@] %@", self.moduleCode, self.classNo, self.lessonType];
            int startInterval = [IPlanUtility getTimeIntervalFromWeek:i Day:[self.dayCode integerValue] Time:[NSNumber numberWithInt:[self.startTime integerValue]]];
            int endInterval = [IPlanUtility getTimeIntervalFromWeek:i Day:[self.dayCode integerValue] Time:[NSNumber numberWithInt:[self.endTime integerValue]]];
            myEvent.startDate = [semesterStart dateByAddingTimeInterval:startInterval];
            myEvent.endDate = [semesterStart dateByAddingTimeInterval:endInterval];
            myEvent.notes = [IPlanUtility decodeFrequency:freArr];
            myEvent.allDay = NO;
            // For now we use the default calendar, we may change to other specific calendars later
            [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
            [eventDB saveEvent:myEvent span:EKSpanThisEvent error:nil];
        }
    }
}

// Destructor
- (void) dealloc
{
    [LAPIStudentTimeTableParser release];
    [super dealloc];
}

@end
