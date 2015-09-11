//
//  DiseaseDetailViewController.m
//  health
//
//  Created by tom.sun on 15/8/24.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "DiseaseDetailViewController.h"

@interface DiseaseDetailViewController ()

@end

@implementation DiseaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = _diseaseName;
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)refreshData
{
    [self startProgress];
    [[HttpRequest shared ]getDiseaseShowById:[_diseaseId longLongValue] withFinish:^(TSDiseaseDetail *model, NSError *error) {
        [self stopProgress];
        _model = model;
        [_tableView setTableHeaderView:_header];
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,model.img]] placeholderImage:nil];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    _contentLabel =[[UILabel alloc]initWithFrame: CGRectMake(10, 10 , self.mainScreenWidth - 20, 20)];
    switch (indexPath.section) {
        case 0:{
            _contentLabel.attributedText = _model.summary;
            break;
        }case 1:{
            _contentLabel.attributedText = _model.symptom;
            break;
        }case 2:{
            _contentLabel.attributedText = _model.symptomText;
            break;
        }case 3:{
            _contentLabel.attributedText = _model.foodText;
            break;
        }case 4:{
            _contentLabel.attributedText = _model.disease;
            break;
        }case 5:{
            _contentLabel.attributedText = _model.diseaseText;
            break;
        }case 6:{
            _contentLabel.attributedText = _model.causeText;
            break;
        }case 7:{
            _contentLabel.attributedText = _model.careText;
            break;
        }
        default:
            break;
    }
    [cell.contentView addSubview:_contentLabel];
    cell.height = [self caculateSize];
    return cell;
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    titleLabel.textColor = UIColorFromRGB(0x444444);
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    [view addSubview:titleLabel];
    switch (section) {
        case 0:{
            titleLabel.text = @"疾病简介";
            break;
        }case 1:{
            titleLabel.text = @"相关病状";
            break;
        }case 2:{
            titleLabel.text = @"病状详情";
            break;
        }case 3:{
            titleLabel.text = @"食疗";
            break;
        }case 4:{
            titleLabel.text = @"相关疾病";
            break;
        }case 5:{
            titleLabel.text = @"疾病说明";
            break;
        }case 6:{
            titleLabel.text = @"病因";
            break;
        }case 7:{
            titleLabel.text = @"注意、医疗";
            break;
        }
        default:
            break;
    }
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self caculateSize];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 30;//section的高度
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)caculateSize
{
    [_contentLabel setTextLineSpacing:4 paragraphSpacing:6];
    _contentLabel.font =[UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = UIColorFromRGB(0x555555);
    _contentLabel.width = self.mainScreenWidth - 20;
    _contentLabel.height = [_contentLabel getTextHeightWithLineSpacing:4 paragraphSpacing:6];
    [_contentLabel setTextAlignment:NSTextAlignmentLeft];
    return  _contentLabel.originY + _contentLabel.height;
}
@end
