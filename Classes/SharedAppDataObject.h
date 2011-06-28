//
//  SharedAppDataObject.h
//  iPlan
//
//  Created by HQ on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDataObject.h"

@interface SharedAppDataObject : AppDataObject {
	NSString *settingsIdentity;
	NSString *moduleCode;
}

@property (nonatomic, copy) NSString *settingsIdentity;
@property (nonatomic, copy) NSString *moduleCode;

@end
