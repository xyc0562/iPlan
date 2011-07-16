//
//  LAPIStudentTimeTableToiCalExporter.m
//  iPlan
//
//  Created by Xu Yecheng on 7/16/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "LAPIStudentTimeTableToiCalExporter.h"


@implementation LAPIStudentTimeTableToiCalExporter

- (id) delegate
{
    return _delegate;
}
- (void) setDelegate:(id)new_delegate
{
    _delegate = new_delegate;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
}

// Destructor
- (void) dealloc
{
    [LAPIStudentTimeTableParser release];
    [super dealloc];
}

@end
