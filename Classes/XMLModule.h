//
//  XMLModule.h
//  iPlan
//
//  Created by Xu Yecheng on 6/18/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLTimeTableSlot.h"

@interface XMLModule : NSObject {
    NSString *code;
    NSString *title;
    NSString *description;
    NSString *examinable;
    NSString *open_book;
    NSString *exam_date;
    NSString *mc;
    NSString *prereq;
    NSString *workload;
    NSString *remarks;
    NSString *last_updated;
    NSString *preclude;
    NSMutableArray *timeTableSlots;
}

@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *examinable;
@property (nonatomic, retain) NSString *open_book;
@property (nonatomic, retain) NSString *exam_date;
@property (nonatomic, retain) NSString *mc;
@property (nonatomic, retain) NSString *prereq;
@property (nonatomic, retain) NSString *workload;
@property (nonatomic, retain) NSString *remarks;
@property (nonatomic, retain) NSString *last_updated;
@property (nonatomic, retain) NSString *preclude;
@property (readonly, retain) NSMutableArray *timeTableSlots;

- (void)addTimeTableSlot:(XMLTimeTableSlot *)timeTableSlot;

@end
