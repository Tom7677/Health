//
//  TSLoadingView.h
//  health
//
//  Created by tom.sun on 15/7/23.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface TSLoadingView : UIView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imageView;

- (void)show;
- (void)dismiss;

- (void)setGifWithImages:(NSArray *)images;
- (void)setGifWithImageName:(NSString *)imageName;
- (void)setGifWithURL:(NSURL *)gifUrl;
@end
