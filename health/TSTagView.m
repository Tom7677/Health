//
//  TSTagView.m
//  health
//
//  Created by tom.sun on 15/8/12.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "TSTagView.h"

@implementation TSTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectIndex = -1;
        _viewsArray = [[NSMutableArray alloc]init];
    }
    return self;
}

+ (NSInteger)RowWithArray:(NSArray *)array
{
    CGFloat height = [TSTagView HeightWithArray:array AndWidth:MainScreenWidth];
    return height / (TSTagHeight + TSTagSpacing / 2);
}

+ (float)HeightWithArray:(NSArray *)array AndWidth:(float)viewWidth
{
    float nextX = 0.f;
    int floor = 1;
    for (int i = 0; i<array.count; i++) {
        CGFloat width = [[self class] stringForWidth:[array objectAtIndex:i]];
        if(nextX + width + TSTagX > viewWidth - TSTagX){
                nextX = TSTagX;
                floor = floor + 1;
        }else{
            if (i == 0) {
                nextX = TSTagX;
            }else{
                nextX = nextX + TSTagRoomWidth;
            }
        }
        nextX = nextX  + width;
    }
    if (array.count ==0) {
        return 0;
    }
    return (floor) * TSTagHeight + (floor - 1) * TSTagSpacing + TSTagY *2;  
}

- (void)creatWithArray:(NSArray *)array AndWidth:(float)viewWidth
{
    float nextX = 0.f;
    int floor = 1;
    for (int i = 0; i<array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat width = [[self class] stringForWidth:[array objectAtIndex:i]];
        if(nextX + width + TSTagX > viewWidth - TSTagX){
            nextX = TSTagX;
            floor = floor + 1;
        }else{
            if (i == 0) {
                nextX = TSTagX;
            }else{
                nextX = nextX + TSTagRoomWidth;
            }
        }
        [btn setFrame:CGRectMake(nextX, (floor - 1)*(TSTagHeight +TSTagSpacing ) + TSTagY, width, TSTagHeight)];
            nextX = nextX + width;
        CGFloat top = 10;
        CGFloat bottom = 10 ;
        CGFloat left = 10;
        CGFloat right = 10;
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        UIImage *image = [UIImage imageNamed:TSTagImageName];
        //btn做设置就可以改变按钮的样式
        [btn setAdjustsImageWhenHighlighted:NO];
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:TSTagTextColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize: TSTagTextFontSize];
        [btn setTitleColor:[UIColor whiteColor ]forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.viewsArray addObject:btn];
        [self addSubview:btn];
    }
}
- (void)buttonAction:(UIButton *)sender
{
    //这里设置代理方法用于点击回调
    if (_selectIndex == sender.tag) {
        return;
    }
    if (_selectIndex !=-1) {
        UIButton *btn = [self.viewsArray objectAtIndex:_selectIndex];
        [btn setBackgroundColor:TSTagBgColor];
        [btn setTitleColor:TSTagTextColor forState:UIControlStateNormal];
    }
    _selectIndex = sender.tag;
    [sender setBackgroundColor:UIColorFromRGB(0xB34C46)];
    [sender setTitleColor:TSSelectedTagTextColor forState:UIControlStateNormal];
    
    if (self.tagCallBack) {
        self.tagCallBack(sender.tag);
    }
}

- (void)selectedToButton:(NSInteger)index
{
    if (self.viewsArray.count >index) {
        if (_selectIndex !=-1) {
            UIButton *btn = [self.viewsArray objectAtIndex:_selectIndex];
            [btn setBackgroundColor:TSTagBgColor];
            [btn setTitleColor:TSTagTextColor forState:UIControlStateNormal];
        }
        UIButton *btn = [self.viewsArray objectAtIndex:index];
        _selectIndex = btn.tag;
        [btn setBackgroundColor:UIColorFromRGB(0xB34C46)];
        [btn setTitleColor:TSSelectedTagTextColor forState:UIControlStateNormal];
    }
}


+(CGFloat)stringForWidth:(NSString*)string
{
    CGSize sizeName = [string sizeWithFont:[UIFont systemFontOfSize:TSTagTextFontSize]
                         constrainedToSize:CGSizeMake(MAXFLOAT, 0.0)
                             lineBreakMode:NSLineBreakByWordWrapping];
    return sizeName.width+10;
}
@end
