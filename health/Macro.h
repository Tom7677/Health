//
//  Macro.h
//  health
//
//  Created by tom.sun on 15/5/29.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#ifndef health_Macro_h
#define health_Macro_h

const static NSString *APIKey = @"e7f0364f08a9312704d08086bceb3fe7";

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define iPhone6PlusIncludeDisplayZoom ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.height >= 2001 : NO)
#define nonetwork @"数据加载失败，请检查网络是否可用"
#define nodata @"数据加载失败，请稍后重试"
#pragma mark - Device adaptation

#define MainColor UIColorFromRGB(0xB34C46)

#define MainScreenWidth ([[UIScreen mainScreen] bounds].size.width)

#define MainScreenHeight ([[UIScreen mainScreen] bounds].size.height)

#define degreesToRadian(x) (M_PI * (x) / 180.0)

#define Iphone5Width 320

#define Iphone6Width 375

#define Iphone6PlusWidth 414

#define Iphone5Height 568

#define Iphone6Height 667

#define Iphone6PlusHeight 736

#define StatusBarHeight 20

#define NavgationBarHeight 44

#define TabBarHeight 49

#define CommonLineHeight 0.5

#define Iphone6PlusCommonLineHeight 0.4

#define BottomLineHeight 1.0
#endif
