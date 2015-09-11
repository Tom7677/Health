//
//  DrugDetailViewController.m
//  health
//
//  Created by tom.sun on 15/8/25.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "DrugDetailViewController.h"

@interface DrugDetailViewController ()

@end

@implementation DrugDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self startProgress];
    [self refreshData];
    self.title = _name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshData
{
    if (_tag == 2) {
        [[HttpRequest shared]getDrugShowById:_Id withFinish:^(TSDrugDetail *model, NSError *error) {
            [self stopProgress];
            if (error == nil) {
                _drugModel = model;
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
    if (_tag == 4) {
        [[HttpRequest shared]getCheckProjectShowById:_Id withFinish:^(TSCheckProjectDetail *model, NSError *error) {
            [self stopProgress];
            if (error == nil) {
                _checkModel = model;
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
    if (_tag == 5) {
        [[HttpRequest shared]getSurgeryShowById:_Id withFinish:^(TSSurgeryDetail *model, NSError *error) {
            [self stopProgress];
            if (error == nil) {
                _surgeryModel = model;
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
    if (_tag == 6) {
        [[HttpRequest shared]getQuestionShowById:_Id withFinish:^(TSQuestionDetail *model, NSError *error) {
            [self stopProgress];
            if (error == nil) {
                _questionModel = model;
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
    if (_tag == 7) {
        [[HttpRequest shared]getHealthInfoShowById:_Id withFinish:^(TSInfoDetail *model, NSError *error) {
            [self stopProgress];
            if (error == nil) {
                _infoModel = model;
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
}

- (void)caculateSize
{
    _coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, self.mainScreenWidth - 30, (self.mainScreenWidth - 30) * 240 / 290)];
    _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _coverImageView.originY + _coverImageView.height + 10, self.mainScreenWidth - 20, 0)];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines = 0;
    if (_tag == 2) {
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,_drugModel.img]] placeholderImage:nil];
        _contentLabel.attributedText = _drugModel.message;
    }
    if (_tag == 4) {
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,_checkModel.img]] placeholderImage:nil];
        _contentLabel.attributedText = _checkModel.message;
    }
    if (_tag == 5) {
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,_surgeryModel.img]] placeholderImage:nil];
        _contentLabel.attributedText = _surgeryModel.message;
    }
    if (_tag == 6) {
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,_questionModel.img]] placeholderImage:nil];
        _contentLabel.attributedText = _questionModel.message;
    }
    if (_tag == 7) {
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,_infoModel.img]] placeholderImage:nil];
        _contentLabel.attributedText = _infoModel.message;
    }
    [_contentLabel setTextLineSpacing:4 paragraphSpacing:6];
    _contentLabel.height = [_contentLabel getTextHeightWithLineSpacing:4 paragraphSpacing:6];
    [_scrollView addSubview:_coverImageView];
    [_scrollView addSubview:_contentLabel];
    [_scrollView setContentSize:CGSizeMake(self.mainScreenWidth, _contentLabel.height + _contentLabel.originY)];
}
@end
