//
//  HealthInfoViewController.m
//  health
//
//  Created by tom.sun on 15/9/8.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "HealthInfoViewController.h"
#import "TBAnimationButton.h"
#import "ZQLRotateView.h"
#import "QuestionListTableViewCell.h"
#import "NSDate+Translate.h"
#import "DrugDetailViewController.h"

@interface HealthInfoViewController ()<UITableViewDelegate,UITableViewDataSource,ZQLRotateViewDelegate>
@property (nonatomic, strong) ZQLRotateView *rotateView;
@property (nonatomic, strong) NSArray *infoClassArray;
@property (nonatomic, strong) NSMutableArray *infoListArray;
@property (nonatomic, strong) TBAnimationButton *leftBtn;
@property (nonatomic, assign) long page;
@property (nonatomic, assign) NSInteger index;
@end

@implementation HealthInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康资讯";
    _leftBtn = [[TBAnimationButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _infoListArray = [[NSMutableArray alloc]init];
    _leftBtn.currentState = TBAnimationButtonStateMenu;
    [_leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:_leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self startProgress];
    [self refreshData];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.header = [MJLoadingHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    _tableView.footer = [MJLoadingFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    [_tableView registerNib:[UINib nibWithNibName:@"QuestionListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshData
{
    [[HttpRequest shared]getHealthInfoClassFinish:^(NSArray *array) {
        _infoClassArray = array;
        NSMutableArray *nameArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < array.count; i ++) {
            [nameArray addObject:array[i][@"name"]];
        }
        _rotateView = [[ZQLRotateView alloc]initWithTitleArrays:nameArray];
        _rotateView.delegate = self;
        [self refreshList:0];
    }];
}

- (void)refreshList:(NSInteger)index
{
    _page = 1;
    _index = index;
    [[HttpRequest shared]getHealthInfoListById:[_infoClassArray[_index][@"id"] longValue] byPage:_page withFinish:^(NSArray *infoListArray, NSError *error, int total) {
        [self stopProgress];
        [_tableView.header endRefreshing];
        [_infoListArray removeAllObjects];
        [_infoListArray addObjectsFromArray:infoListArray];
        [_tableView reloadData];
    }];
}

- (void)loadMoreData
{
    _page = _page + 1;
    [[HttpRequest shared]getHealthInfoListById:[_infoClassArray[_index][@"id"] longValue] byPage:_page withFinish:^(NSArray *infoListArray, NSError *error, int total) {
        [_infoListArray addObjectsFromArray:infoListArray];
        if (_infoListArray.count >= total) {
            //已加载全部
            [_tableView.footer noticeNoMoreData];
        }
        else {
            [_tableView.footer endRefreshing];
        }
        [_tableView reloadData];
    }];
}

- (void)leftBtnAction:(TBAnimationButton *)sender
{
    if (sender.currentState == TBAnimationButtonStateMenu) {
        [sender animationTransformToState:TBAnimationButtonStateCross];
        [_rotateView showMenu:self.view];
    } else if (sender.currentState == TBAnimationButtonStateCross) {
        [sender animationTransformToState:TBAnimationButtonStateMenu];
        [_rotateView hideMenu];
    }
}

- (void)ZQLRotateView:(UIView *)view DidChoose:(NSInteger)tag
{
    [_leftBtn animationTransformToState:TBAnimationButtonStateMenu];
    [self refreshList:tag];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoListArray.count;
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
    TSInfoList *model = _infoListArray[indexPath.row];
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
    TSInfoList *model = _infoListArray[indexPath.row];
    DrugDetailViewController *vc= [[DrugDetailViewController alloc]init];
    vc.Id = model.Id;
    vc.name = model.title;
    vc.tag = 7;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
