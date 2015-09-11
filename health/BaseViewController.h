//
//  BaseViewController.h
//  health
//
//  Created by tom.sun on 15/5/29.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+frame.h"
#import "HttpRequest.h"
#import "Macro.h"
#import "UILabel+caculateSize.h"
#import "UIView+border.h"
#import "MJLoadingFooter.h"
#import "MJLoadingHeader.h"
#import <UIImageView+WebCache.h>
#import "MJRefresh.h"

@interface BaseViewController : UIViewController

- (void)startProgress;
- (void)stopProgress;
- (void)showEmptyView:(NSString *)error;
- (void)refreshData;
- (CGFloat)mainScreenWidth;
- (CGFloat)mainScreenHeight;
- (CGFloat)iphone5Width;
- (CGFloat)iphone5Height;
- (CGFloat)iphone6Width;
- (CGFloat)iphone6Height;
- (CGFloat)iphone6plusWidth;
- (CGFloat)iphone6plusHeight;
- (CGFloat)statusBarHeight;
- (CGFloat)navgationBarHeight;
- (CGFloat)statusBarAndnavgationBarHeight;
- (CGFloat)tabBarHeight;
@end
