//
//  UIViewWithLine.h
//  iRemember
//
//  Created by Zhang Ying on 4/12/11.
//  Copyright 2011 SoC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewWithLine : UIView {
	NSInteger point1X;
	NSInteger point1Y;
	NSInteger point2X;
	NSInteger point2Y;
}

@property (nonatomic,assign) NSInteger point1X;
@property (nonatomic,assign) NSInteger point1Y;
@property (nonatomic,assign) NSInteger point2X;
@property (nonatomic,assign) NSInteger point2Y;

- (id)initWithFrame:(CGRect)frame Point1X:(NSInteger)x1 Point1Y:(NSInteger)y1 Point2X:(NSInteger)x2 Point2Y:(NSInteger)y2;
@end
