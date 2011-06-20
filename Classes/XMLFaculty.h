//
//  XMLFaculty.h
//  iPlan
//
//  Created by Xu Yecheng on 6/18/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLModule.h"


@interface XMLFaculty : NSObject
{
    NSMutableArray *modules;
}

@property (readonly, retain) NSMutableArray *modules;

- (void)addModule:(XMLModule *)module;

@end
