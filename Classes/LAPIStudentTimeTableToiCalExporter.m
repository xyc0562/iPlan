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
@synthesize weekCode;
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
        [[LAPIStudentTimeTableParser alloc] initWithData:data];
        [LAPIStudentTimeTableParser setDelegate:self];
        [LAPIStudentTimeTableParser setShouldResolveExternalEntities:YES];
        [LAPIStudentTimeTableParser setShouldProcessNamespaces:NO]; // We don't care about namespaces
        [LAPIStudentTimeTableParser setShouldReportNamespacePrefixes:NO]; //
        [LAPIStudentTimeTableParser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
        //NSLog(@"begin parsing");
        [LAPIStudentTimeTableParser parse];
    }
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
        [currentProperty appendString:string];
        //NSLog(@"!%@!", currentProperty);
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
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
    else if ([elementName isEqualToString:@"WeekCode"])
    {
        self.weekCode = self.currentProperty;
    }
    // Start exporting
    else if ([elementName isEqualToString:@"Data_Timetable_Student"])
    {
        
    }
}

// Destructor
- (void) dealloc
{
    [LAPIStudentTimeTableParser release];
    [super dealloc];
}

@end
