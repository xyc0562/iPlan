//
//  ClassGroup.h
//  iPlan
//
//  Created by Yingbo Zhan on 11-6-18.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstantFile.h"
#import "Slot.h"

@interface ClassGroup : NSObject {

}
@property(nonatomic,readonly)NSString* name;
@property(nonatomic,readonly)NSArray* slots;
@property(nonatomic,readonly)NSString* frequency;
@property(nonatomic,readwrite,assign)NSString* selected;

-(id)initWithName:(NSString*)naming WithSlots:(NSArray*)slot WithFrequency:(NSString*)freq WithSelected:(NSString*)select;
    
@end
