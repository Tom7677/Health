//
//  KnowledgeDetailViewController.m
//  health
//
//  Created by tom.sun on 15/7/31.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "KnowledgeDetailViewController.h"

@interface KnowledgeDetailViewController ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation KnowledgeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"健康知识详情";
    [self startProgress];
    [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)refreshData
{
    [[HttpRequest shared]getLoreShowById:_Id withFinish:^(TSLoreDetail *model, NSError *error) {
        [self stopProgress];
        if (error == nil) {
            _titleLabel.text = model.title;
            _contentLabel =[[UILabel alloc]initWithFrame: CGRectMake(10, 55, self.mainScreenWidth - 20, 20)];
            _contentLabel.attributedText = model.message;
            [self caculateSize];
        }
        else {
            if (error.code == NSURLErrorNotConnectedToInternet) {
                [self showEmptyView:nonetwork];
            }
            else {
                [self showEmptyView:nodata];
            }
        }
    }];
}

- (void)caculateSize
{
    [_contentLabel setTextLineSpacing:4 paragraphSpacing:6];
    _contentLabel.font =[UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = UIColorFromRGB(0x555555);
    _contentLabel.width = self.mainScreenWidth - 20;
    _contentLabel.height = [_contentLabel getTextHeightWithLineSpacing:4 paragraphSpacing:6];
    [_contentLabel setTextAlignment:NSTextAlignmentLeft];
    _contentView.height = _contentLabel.originY + _contentLabel.height + 20;
    [_contentView addSubview:_contentLabel];
    _bgView.height = _contentView.height;
    _bgView.width = self.mainScreenWidth;
    [_scrollView addSubview:_bgView];
    [_scrollView setContentSize:CGSizeMake(self.mainScreenWidth, _bgView.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
