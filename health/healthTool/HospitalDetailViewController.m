//
//  HospitalDetailViewController.m
//  health
//
//  Created by tom.sun on 15/9/11.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "HospitalDetailViewController.h"

@interface HospitalDetailViewController ()

@end

@implementation HospitalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self startProgress];
    [self refreshData];
    self.title = _name;
}

- (void) refreshData
{
    [[HttpRequest shared]getHospitalShowById:_Id withFinish:^(TSHospitalDetail *model, NSError *error) {
        [self stopProgress];
        if (error == nil) {
            _model = model;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)caculateSize
{
    UIImageView *coverImageView= [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, self.mainScreenWidth - 30, (self.mainScreenWidth - 30) * 240 / 290)];
    coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    [coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,_model.img]] placeholderImage:nil];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, coverImageView.originY + coverImageView.height + 10, self.mainScreenWidth - 20, 14)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"乘车路线";
    UILabel *goBusLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, label.originY + label.height + 5, self.mainScreenWidth - 20, 0)];
    goBusLabel.font = [UIFont systemFontOfSize:14];
    goBusLabel.numberOfLines = 0;
    goBusLabel.attributedText = _gobus;
    [goBusLabel setTextLineSpacing:4 paragraphSpacing:6];
    goBusLabel.height = [goBusLabel getTextHeightWithLineSpacing:4 paragraphSpacing:6];
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, goBusLabel.originY + goBusLabel.height + 10, self.mainScreenWidth - 20, 0)];
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.numberOfLines = 0;
    messageLabel.attributedText = _model.message;
    [messageLabel setTextLineSpacing:4 paragraphSpacing:6];
    messageLabel.height = [messageLabel getTextHeightWithLineSpacing:4 paragraphSpacing:6];
    [_scrollView addSubview:coverImageView];
    [_scrollView addSubview:label];
    [_scrollView addSubview:goBusLabel];
    [_scrollView addSubview:messageLabel];
    [_scrollView setContentSize:CGSizeMake(self.mainScreenWidth, messageLabel.originY + messageLabel.height + 10)];
}

@end
