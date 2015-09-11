//
//  UIView+frame.h
//  Carousel
//
//  Created by Harvey Zhang on 11/12/12.
//
//

#import "UIView+frame.h"
#import "Macro.h"

@implementation UIView (frame)

- (CGFloat)originX
{
    return self.frame.origin.x;
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOriginX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)setOriginY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)setSize:(CGSize)size
{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (void)setOriginX:(CGFloat)x originY:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    rect.origin.y = y;
    rect.size.width = width;
    rect.size.height = height;
    self.frame = rect;
}

#pragma mark - Device adaptation
// 将屏幕宽为320（iphone5的屏幕）转化为当前运行设备的宽度，该方法用户横向点位置以及宽度的运算，
// 同时要满足点位置和宽度的转换是成比例的
- (CGFloat)convertPointWidth320toCurDeviceWidth:(CGFloat)width
{
    CGFloat curDiviceWidth = [self mainScreenWidth];
    // 320:
    return (width / 320) * curDiviceWidth;
}



- (CGFloat)commonLineHeight
{
    return  CommonLineHeight;
}

- (CGFloat)iphone6PlusCommonLineHeight
{
    return Iphone6PlusCommonLineHeight;
}

- (CGFloat)bottomLineHeight
{
    return  BottomLineHeight;
}

- (void)toCommonLineHight
{
    CGRect rect = self.frame;
    if (Iphone6PlusHeight == MainScreenHeight) {
        rect.size.height = self.iphone6PlusCommonLineHeight;
    } else {
        rect.size.height = self.commonLineHeight;
    }
    self.frame = rect;
}

- (void)toBottomLineHeight
{
    CGRect rect = self.frame;
    rect.size.height = self.bottomLineHeight;
    self.frame = rect;
}

- (CGFloat)statusBarHeight
{
    return StatusBarHeight;
}

- (CGFloat)navgationBarHeight
{
    return NavgationBarHeight;
}

- (CGFloat)statusBarAndnavgationBarHeight
{
    return self.navgationBarHeight + self.statusBarHeight;
}

- (CGFloat)tabBarHeight
{
    return TabBarHeight;
}
@end
