//
//  UIViewWithLine.m
//  iRemember
//
//  Created by Zhang Ying on 4/12/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import "UIViewWithLine.h"
#define LINE_WIDTH 5.0

@implementation UIViewWithLine

@synthesize point1X;
@synthesize point1Y;
@synthesize point2X;
@synthesize point2Y;

- (id)initWithFrame:(CGRect)frame Point1X:(NSInteger)x1 Point1Y:(NSInteger)y1 Point2X:(NSInteger)x2 Point2Y:(NSInteger)y2 {
	self = [super initWithFrame:frame];
	if (self) {
		self.point1X = x1;
		self.point1Y = y1;
		self.point2X = x2;
		self.point2Y = y2;
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, LINE_WIDTH);
	
	CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
	
	CGContextMoveToPoint(context, point1X, point1Y);
	CGContextAddLineToPoint(context, point2X, point2Y);
	
	CGContextStrokePath(context);
}


- (void)dealloc {
    [super dealloc];
}


@end
