//
//  TSImgeRightButton.m
//  health
//
//  Created by tom.sun on 15/9/10.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "TSImgeRightButton.h"

@implementation TSImgeRightButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    UILabel *label = [self titleLabel];
    UIImageView *imageView = [self imageView];
    CGRect imageFrame = imageView.frame;
    CGRect labelFrame = label.frame;
    labelFrame.origin.x = (self.bounds.size.width - labelFrame.size.width)/ 2 - 10;
    imageFrame.origin.x = labelFrame.origin.x + labelFrame.size.width + 10;
    imageView.frame = imageFrame;
    label.frame = labelFrame;
}

@end
