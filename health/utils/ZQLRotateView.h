//
//  ZQLRotateView.h
//  ZQLRotateMenu
//
//  Created by zangqilong on 15/1/4.
//  Copyright (c) 2015年 zangqilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQLRotateViewDelegate <NSObject>

- (void)ZQLRotateView:(UIView *)view DidChoose:(NSInteger)tag;

@end

@interface ZQLRotateView : UIView

@property (nonatomic, assign) id<ZQLRotateViewDelegate> delegate;

- (id)initWithTitleArrays:(NSArray *)titleArray;

- (void)showMenu:(UIView *)view;

- (void)hideMenu;

@end
