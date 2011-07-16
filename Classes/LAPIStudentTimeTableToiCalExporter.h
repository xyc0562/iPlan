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

@interface LAPIStudentTimeTableToiCalExporter : NSObject
{
    NSXMLParser *LAPIStudentTimeTableParser;
}

- (id) initWithNSDataParseAndExport:(NSData*)data;

- (id) delegate;
- (void) setDelegate:(id)new_delegate;

@end
