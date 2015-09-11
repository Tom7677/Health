//
//  HealthQuestionViewController.m
//  health
//
//  Created by tom.sun on 15/8/13.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "HealthQuestionViewController.h"
#import "QuestionListTableViewCell.h"
#import "NSDate+Translate.h"
#import "HealthQuestionListViewController.h"
#import "DrugDetailViewController.h"

@interface HealthQuestionViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HealthQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康问题";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self startProgress];
    [self refreshData];
    _questionListDic = [[NSMutableDictionary alloc]init];
    [_tableView registerNib:[UINib nibWithNibName:@"QuestionListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
}

- (void)refreshData
{
    [[HttpRequest shared]getHealthQuestionClassFinish:^(NSArray *array) {
        _questionClassArray = array;
        for (int i = 0; i < array.count; i ++) {
            [[HttpRequest shared]getHealthQuestionListById:[array[i][@"id"] longValue] byPage:1 withFinish:^(NSArray *questionListArray, NSError *error, int total) {
                [_questionListDic setObject:questionListArray forKey:array[i][@"id"]];
                if (i == array.count - 1) {
                    [self stopProgress];
                    [_tableView reloadData];
                }
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[_questionListDic objectForKey:_questionClassArray[section][@"id"]] count] > 5) {
        return 5;
    }
    else {
        return [[_questionListDic objectForKey:_questionClassArray[section][@"id"]] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_questionListDic objectForKey:_questionClassArray[indexPath.section][@"id"]] count] > 5) {
        if (indexPath.row <= 3) {
            QuestionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
            TSQuestionList *model = [_questionListDic objectForKey:_questionClassArray[indexPath.section][@"id"]][indexPath.row];
            [cell.line toCommonLineHight];
            cell.pic.contentMode = UIViewContentModeScaleAspectFit;
            if (model.img == nil) {
                cell.pic.image = [UIImage imageNamed:@"img_iInvalidphoto_75x75"];
            }
            else {
                [cell.pic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,model.img]] placeholderImage:nil];
            }
            cell.titleLabel.text = model.title;
            cell.countLabel.text = [NSString stringWithFormat:@"浏览%d次",model.visitCount];
            cell.timeLabel.text = [NSDate getTimeFromTimestamp:model.time];
            return cell;
        }
        if (indexPath.row > 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((self.mainScreenWidth - 100) / 2, 10, 100, 35)];
            [btn setTitle:@"查看更多" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.backgroundColor = UIColorFromRGB(0xcccccc);
            [btn circularBead:16];
            btn.tag = indexPath.section;
            [btn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            return cell;
        }
    }
    else {
        QuestionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        TSQuestionList *model = [_questionListDic objectForKey:_questionClassArray[indexPath.section][@"id"]][indexPath.row];
        [cell.line toCommonLineHight];
        cell.pic.contentMode = UIViewContentModeScaleAspectFit;
        if (model.img == nil) {
            cell.pic.image = [UIImage imageNamed:@"img_iInvalidphoto_75x75"];
        }
        else {
            [cell.pic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,model.img]] placeholderImage:nil];
        }
        cell.titleLabel.text = model.title;
        cell.countLabel.text = [NSString stringWithFormat:@"浏览%d次",model.visitCount];
        cell.timeLabel.text = [NSDate getTimeFromTimestamp:model.time];
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _questionClassArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_questionListDic objectForKey:_questionClassArray[indexPath.section][@"id"]] count] > 5) {
        if (indexPath.row < 4) {
            return 90;
        }
        else {
            return 55;
        }
    }
    else {
        return 90;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, self.mainScreenWidth, 40)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 40)];
    label.text = _questionClassArray[section][@"name"];
    label.textColor = MainColor;
    [bgView addSubview:label];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.mainScreenWidth, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xdddddd);
    [bgView addSubview:line];
    bgView.backgroundColor = [UIColor whiteColor];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_questionListDic objectForKey:_questionClassArray[indexPath.section][@"id"]] count] > 5) {
        if (indexPath.row < 4) {
            TSQuestionList *model = [_questionListDic objectForKey:_questionClassArray[indexPath.section][@"id"]][indexPath.row];
            DrugDetailViewController *vc= [[DrugDetailViewController alloc]init];
            vc.Id = model.Id;
            vc.name = model.title;
            vc.tag = 6;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else {
        TSQuestionList *model = [_questionListDic objectForKey:_questionClassArray[indexPath.section][@"id"]][indexPath.row];
        DrugDetailViewController *vc= [[DrugDetailViewController alloc]init];
        vc.Id = model.Id;
        vc.name = model.title;
        vc.tag = 6;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)moreBtnAction:(UIButton *)btn
{
    HealthQuestionListViewController *vc =[[HealthQuestionListViewController alloc]init];
    vc.Id = [[_questionClassArray objectAtIndex:btn.tag][@"id"] longValue];
    vc.name = [_questionClassArray objectAtIndex:btn.tag][@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
