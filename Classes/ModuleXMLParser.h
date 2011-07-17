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
#import "ConstantFile.h"

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
@property (nonatomic, retain) NSString *lastUpdated;
@property (nonatomic, retain) NSString *semester;
@property (nonatomic, retain) NSString *weekMidtermBreakAfter;
@property (nonatomic, retain) NSString *weekOneDay;
@property (nonatomic, retain) NSString *weekOneMonth;
@property (nonatomic, retain) NSString *year;

- (id) initWithURLStringAndParse:(NSString *)URLString;
- (id) initWithDataAndParse:(NSData*)data;

- (id) delegate;
- (void) setDelegate:(id)new_delegate;

@end
