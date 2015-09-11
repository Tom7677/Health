//
//  TSTagView.h
//  health
//
//  Created by tom.sun on 15/8/12.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#define TSTagImageName @"size未选中.png"//按钮背景图
#define TSTagHeight 30.f//设置按钮高度
#define TSTagTextColor UIColorFromRGB(0x444444) //按钮字体颜色
#define TSTagTextFontSize 16.0//按钮字体大小
#define TSTagSpacing 20.f//俩个按钮之间的上下距离
#define TSTagRoomWidth 10.f//俩个按钮之间的左右距离
#define TSTagX 15.f
#define TSTagY 8.f
#define TSSelectedTagTextColor [UIColor whiteColor]
#define TSTagBgColor [UIColor whiteColor]

@interface TSTagView : UIView
@property(nonatomic,copy) void(^tagCallBack)(NSInteger index);
@property(nonatomic,assign) NSInteger selectIndex;
@property(nonatomic,strong) NSMutableArray *viewsArray;

+ (float)HeightWithArray:(NSArray *)array AndWidth:(float)viewWidth;
- (void)creatWithArray:(NSArray *)array AndWidth:(float)viewWidth;
- (void)selectedToButton:(NSInteger)index;
+ (NSInteger)RowWithArray:(NSArray *)array;
@end
