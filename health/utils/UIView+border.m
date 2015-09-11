//
//  UIView+border.m
//  Hiking
//
//  Created by benny on 13-11-26.
//  Copyright (c) 2013年 augmentum. All rights reserved.
//

#import "UIView+border.h"
#import "QuartzCore/QuartzCore.h"
#import "Macro.h"

@implementation UIView (border)
- (void)border
{
    if (iPhone6PlusIncludeDisplayZoom) {
        self.layer.borderWidth = 0.4;
    } else {
        self.layer.borderWidth = 0.5;
    }
    self.layer.borderColor = [UIColorFromRGB(0xdddddd) CGColor];
}

- (void)circularBead
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
}

- (void)border:(float)width
{
    self.layer.borderWidth = width;
    self.layer.borderColor = [UIColorFromRGB(0xdddddd) CGColor];
}

- (void)circularBead:(float)width
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = width;
}

- (void)circularBoarderBead:(float)width withBoarder:(float)w
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = width;
    self.layer.borderWidth = w;
    self.layer.borderColor = [UIColorFromRGB(0xcccccc) CGColor];
}

- (void)circularBoarderBead:(float)width withBoarder:(float)w color:(UIColor *)color
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = width;
    self.layer.borderWidth = w;
    self.layer.borderColor = [color CGColor];
}

- (void)rightBorder:(float)width
{
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(self.frame.size.width - width, 0.0f, width, self.frame.size.height);
    rightBorder.backgroundColor = [UIColorFromRGB(0xcccccc) CGColor];
    [self.layer addSublayer:rightBorder];
}

- (void)leftBorder:(float)width
{
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0.0f, 0.0f, width, self.frame.size.height);
    leftBorder.backgroundColor = [UIColorFromRGB(0xcccccc) CGColor];
    [self.layer addSublayer:leftBorder];
}

- (void)bottomBorder:(float)width
{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - width, self.frame.size.width, width);
    bottomBorder.backgroundColor = [UIColorFromRGB(0xcccccc) CGColor];
    [self.layer addSublayer:bottomBorder];
}

- (void)topBorder:(float)width
{
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, width);
    topBorder.backgroundColor = [UIColorFromRGB(0xcccccc) CGColor];
    [self.layer addSublayer:topBorder];
}

- (void)circular
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
}
@end
