//
//  XMLTimeTableSlot.h
//  iPlan
//
//  Created by Xu Yecheng on 6/18/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XMLTimeTableSlot : NSObject
{
    NSString *type;
    NSString *slot;
    NSString *day;
    NSString *time_start;
    NSString *time_end;
    NSString *venue;
    NSString *frequency;
}

@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *slot;
@property(nonatomic, retain) NSString *day;
@property(nonatomic, retain) NSString *time_start;
@property(nonatomic, retain) NSString *time_end;
@property(nonatomic, retain) NSString *venue;
@property(nonatomic, retain) NSString *frequency;

- (void) debugSlot;

@end
