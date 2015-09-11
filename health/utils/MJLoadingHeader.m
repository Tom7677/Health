//
//  MJLoadingHeader.m
//  health
//
//  Created by tom.sun on 15/7/28.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "MJLoadingHeader.h"
#import <ImageIO/ImageIO.h>

@implementation MJLoadingHeader
- (void)prepare
{
    [super prepare];
    [self setImages:[NSArray arrayWithObject:[self praseGIFDataToImageArray][0]] forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [self setImages:[self praseGIFDataToImageArray] forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [self setImages:[self praseGIFDataToImageArray] forState:MJRefreshStateRefreshing];
}

- (NSMutableArray *)praseGIFDataToImageArray
{
    NSData *data = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"refresh" ofType:@"gif"]];
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    return frames;
}
@end
