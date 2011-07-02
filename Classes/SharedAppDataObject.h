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
	NSMutableArray *basket;
	BOOL zoomed;
}

@property (nonatomic, copy) NSString *settingsIdentity;
@property (nonatomic, copy) NSString *moduleCode;
@property (nonatomic, retain) NSMutableArray *basket;
@property (nonatomic, assign) BOOL zoomed;

@end
