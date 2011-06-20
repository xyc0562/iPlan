//
//  XMLFaculty.m
//  iPlan
//
//  Created by Xu Yecheng on 6/18/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "XMLFaculty.h"


@implementation XMLFaculty

@synthesize modules;

- (void)addModule:(XMLModule *)module
{
    if (!modules)
    {
        modules = [[NSMutableArray alloc] init];
    }
    [modules addObject:module];
}

@end
