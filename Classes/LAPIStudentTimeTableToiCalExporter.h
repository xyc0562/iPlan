//
//  LAPIStudentTimeTableToiCalExporter.h
//  iPlan
//
//  Created by Xu Yecheng on 7/16/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSXMLParser.h>
#import <EventKit/EventKit.h>

@interface LAPIStudentTimeTableToiCalExporter : NSObject<NSXMLParserDelegate>
{
    NSXMLParser *LAPIStudentTimeTableParser;
    id _delegate;
}

@property (nonatomic, retain) NSString *acadYear;
@property (nonatomic, retain) NSString *classNo;
@property (nonatomic, retain) NSString *dayCode;
@property (nonatomic, retain) NSString *endTime;
@property (nonatomic, retain) NSString *lessonType;
@property (nonatomic, retain) NSString *moduleCode;
@property (nonatomic, retain) NSString *semester;
@property (nonatomic, retain) NSString *startTime;
@property (nonatomic, retain) NSString *venue;
@property (nonatomic, retain) NSString *weekCode;
@property (nonatomic, retain) NSString *currentProperty;

- (id) initWithNSDataParseAndExport:(NSData*)data;

- (id) delegate;
- (void) setDelegate:(id)new_delegate;

@end
