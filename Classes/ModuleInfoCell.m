//
//  ModuleInfoCell.m
//  iPlan
//
//  Created by Zhao Cong on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModuleInfoCell.h"


@implementation ModuleInfoCell

@synthesize moduleInfoCell;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if(self){
		//Initialization code
	}
	return self;
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated{
	[super setSelected:selected animated:animated];
}


- (void)dealloc {
    [super dealloc];
}


@end
