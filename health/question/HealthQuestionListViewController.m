//
//  HealthQuestionListViewController.m
//  health
//
//  Created by tom.sun on 15/9/7.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "HealthQuestionListViewController.h"
#import "QuestionListTableViewCell.h"
#import "NSDate+Translate.h"
#import "DrugDetailViewController.h"

@interface HealthQuestionListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HealthQuestionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _name;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self startProgress];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _questionListArray = [[NSMutableArray alloc]init];
    [_tableView registerNib:[UINib nibWithNibName:@"QuestionListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    [self refreshData];
    _tableView.header = [MJLoadingHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    _tableView.footer = [MJLoadingFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshData
{
    _page = 1;
    [[HttpRequest shared]getHealthQuestionListById:_Id byPage:_page withFinish:^(NSArray *questionListArray, NSError *error, int total) {
        [self stopProgress];
        [_tableView.header endRefreshing];
        if (error == nil) {
            [_questionListArray removeAllObjects];
            [_questionListArray addObjectsFromArray:questionListArray];
            [_tableView reloadData];
            if (_questionListArray.count >= total) {
                _tableView.footer.hidden = YES;
            }
            else {
                _tableView.footer.hidden = NO;
            }
            if (_questionListArray.count == 0) {
                [self showEmptyView:nodata];
            }
        }
        else {
            _tableView.footer.hidden = YES;
            if (error.code == NSURLErrorNotConnectedToInternet) {
                [self showEmptyView:nonetwork];
            }
            else {
                [self showEmptyView:nodata];
            }
        }
    }];
}

- (void)loadMoreData
{
    _page = _page + 1;
    [[HttpRequest shared]getHealthQuestionListById:_Id byPage:_page withFinish:^(NSArray *questionListArray, NSError *error, int total) {
        if (error == nil) {
            [_questionListArray addObjectsFromArray:questionListArray];
            [_tableView reloadData];
            if (_questionListArray.count >= total) {
                //已加载全部
                [_tableView.footer noticeNoMoreData];
            }
            else {
                [_tableView.footer endRefreshing];
            }
        }
        else {
            if (error.code == NSURLErrorNotConnectedToInternet) {
                
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _questionListArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    TSQuestionList *model = _questionListArray[indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSQuestionList *model = _questionListArray[indexPath.row];
    DrugDetailViewController *vc= [[DrugDetailViewController alloc]init];
    vc.Id = model.Id;
    vc.name = model.title;
    vc.tag = 6;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
