//
//  UIView+frame.h
//  Carousel
//
//  Created by Harvey Zhang on 11/12/12.
//
//

#import <UIKit/UIKit.h>

@interface UIView (frame)

- (CGFloat)originX;
- (CGFloat)originY;
- (CGPoint)origin;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;

- (void)setOriginX:(CGFloat)x;
- (void)setOriginY:(CGFloat)y;
- (void)setOrigin:(CGPoint)origin;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setSize:(CGSize)size;

- (void)setOriginX:(CGFloat)x originY:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

#pragma mark - Device adaptation
// 将屏幕宽为320（iphone5）转化为当前运行设备的宽度，该方法用户横向点位置以及宽度的运算，
// 同时要满足点位置和宽度的转换是成比例的
- (CGFloat)convertPointWidth320toCurDeviceWidth:(CGFloat)size;

// 当前设备屏幕宽(point)
- (CGFloat)mainScreenWidth;
// 当前设备屏幕高(point)
- (CGFloat)mainScreenHeight;

- (CGFloat)iphone5Width;
- (CGFloat)iphone6Width;
- (CGFloat)iphone6plusWidth;
- (CGFloat)iphone5Height;
- (CGFloat)iphone6Height;
- (CGFloat)iphone6plusHeight;

- (CGFloat)commonLineHeight;
- (CGFloat)iphone6PlusCommonLineHeight;
- (CGFloat)bottomLineHeight;
- (void)toCommonLineHight;
- (void)toBottomLineHeight;

- (CGFloat)statusBarHeight;
- (CGFloat)navgationBarHeight;
- (CGFloat)statusBarAndnavgationBarHeight;
- (CGFloat)tabBarHeight;

@end
