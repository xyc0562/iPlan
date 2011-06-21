//
//  ModuleXMLParser.h
//  iPlan
//
//  Created by Xu Yecheng on 6/18/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSXMLParser.h>
//#import "XMLFaculty.h"
#import "Module.h"
#import "XMLModule.h"

@interface ModuleXMLParser : NSObject<NSXMLParserDelegate>
{
    NSXMLParser *modulesParser;
    NSString *XMLURLString;

    // XML struture related
    NSMutableString *currentProperty;
//    XMLFaculty *currentFaculty;
    XMLModule *currentModule;
    XMLTimeTableSlot *currentTimeTableSlot;
    id _delegate;
//    NSMutableArray *faculties;
}

@property (nonatomic, retain) NSMutableString *currentProperty;
// @property (nonatomic, retain) XMLFaculty *currentFaculty;
@property (nonatomic, retain) XMLModule *currentModule;
@property (nonatomic, retain) XMLTimeTableSlot *currentTimeTableSlot;
@property (nonatomic, retain) NSXMLParser *modulesParser;
// @property (nonatomic, readonly) NSMutableArray *faculties;

- (id) initWithURLStringAndParse:(NSString *)URLString;

- (id) delegate;
- (void) setDelegate:(id)new_delegate;

@end
