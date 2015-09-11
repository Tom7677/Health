//
//  BookPageViewController.m
//  health
//
//  Created by tom.sun on 15/9/2.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BookPageViewController.h"

@interface BookPageViewController ()

@end

@implementation BookPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= _name;
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.mainScreenWidth - 20, 0)];
    messageLabel.attributedText = [self changeHtmlString:_message];
    messageLabel.numberOfLines = 0;
    messageLabel.font = [UIFont systemFontOfSize:14.0];
    [messageLabel setTextLineSpacing:4 paragraphSpacing:6];
    messageLabel.height = [messageLabel getTextHeightWithLineSpacing:4 paragraphSpacing:6];
    [_scrollView addSubview:messageLabel];
    [_scrollView setContentSize:CGSizeMake(self.mainScreenWidth, messageLabel.originY + messageLabel.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableAttributedString *)changeHtmlString:(NSString *)htmlString
{
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}
@end
