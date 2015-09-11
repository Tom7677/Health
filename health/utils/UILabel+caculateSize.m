//
//  UILabel+caculateSize.m
//  health
//
//  Created by tom.sun on 15/7/31.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "UILabel+caculateSize.h"

@implementation UILabel (caculateSize)
- (void)setTextLineSpacing:(float)line paragraphSpacing:(float)paragraph
{
    if (self.text != nil)
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:line];
        [paragraphStyle setParagraphSpacing:paragraph];
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
        [self setAttributedText:attributedString];
    }
}

- (double)getTextHeightWithLineSpacing:(float)line paragraphSpacing:(float)paragraph
{
    double dHeight = 0.0;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:self.font forKey:NSFontAttributeName];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:line];
    [paragraphStyle setParagraphSpacing:paragraph];
    
    [dic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:dic
                                          context:nil];
    
    dHeight = ceil(rect.size.height);
    return dHeight;
}

- (double)getTextWidth
{
    double dWidth = 0.0;
    NSDictionary *attributes = @{NSFontAttributeName:self.font};
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    
    dWidth = ceil(rect.size.width);
    return dWidth;
}
@end
