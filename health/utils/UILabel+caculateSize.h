//
//  UILabel+caculateSize.h
//  health
//
//  Created by tom.sun on 15/7/31.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (caculateSize)
- (void)setTextLineSpacing:(float)line paragraphSpacing:(float)paragraph;
- (double)getTextHeightWithLineSpacing:(float)line paragraphSpacing:(float)paragraph;
- (double)getTextWidth;
@end
