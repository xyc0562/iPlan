//
//  Module.h
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstantFile.h"
#import "ModuleClassType.h"

@interface Module : NSObject {

}
@property(nonatomic,readonly)NSString* code;
@property(nonatomic,readonly)NSString* description;
@property(nonatomic,readonly)NSString* title;
@property(nonatomic,readonly)NSString* examinable;
@property(nonatomic,readonly)NSString* openBook;
@property(nonatomic,readonly)NSString* examDate;
@property(nonatomic,readonly)NSString* moduleCredit;
@property(nonatomic,readonly)NSString* prerequisite;
@property(nonatomic,readonly)NSString* preclusion;
@property(nonatomic,readonly)NSString* workload;
@property(nonatomic,readonly)NSString* remarks;
@property(nonatomic,readonly)NSString* lastUpdated;
@property(nonatomic,retain)NSString* selected;
@property(nonatomic,readonly)NSArray* moduleClassTypes;
@property(nonatomic,retain)UIColor* color;
-(BOOL)checkSelected;

-(id)initWithDescription:(NSString*)desp
                WithCode:(NSString*)codes
               WithTitle:(NSString*)titl
          WithExaminable:(NSString*)exam
            WithOpenBook:(NSString*)open
            WithExamDate:(NSString*)date
              WithCredit:(NSString*)credit
        WithPrerequisite:(NSString*)prereq
          WithPreclusion:(NSString*)preclu
            WithWorkload:(NSString*)work
              WithRemark:(NSString*)remark
          WithLastUpdate:(NSString*)update
            WithSelected:(NSString*)select
     WithModuleClassType:(NSArray*)moduleClassType;

+(id)ModuleWithModuleCode:(NSString*)code;
-(UIColor*)getColorFromString:(NSString*)string;

- (void) showContents;
@end
