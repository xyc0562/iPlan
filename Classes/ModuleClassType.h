//
//  ModuleClassType.h
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstantFile.h"
#import "ClassGroup.h"

@interface ModuleClassType : NSObject {

}
@property(nonatomic,readonly)NSString* name;
@property(nonatomic,readonly)NSArray* classGroups;
-(id)initWithName:(NSString*)naming WithGroups:(NSArray*)groups;
- (void) showContents;
@end
