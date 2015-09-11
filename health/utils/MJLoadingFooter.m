//
//  MJLoadingFooter.m
//  health
//
//  Created by tom.sun on 15/7/29.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "MJLoadingFooter.h"
#import <ImageIO/ImageIO.h>

@implementation MJLoadingFooter
- (void)prepare
{
    [super prepare];
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
