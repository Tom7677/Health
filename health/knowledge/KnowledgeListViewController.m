//
//  KnowledgeListViewController.m
//  health
//
//  Created by tom.sun on 15/5/29.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "KnowledgeListViewController.h"
#import "UIView+frame.h"
#import "KnowledgeListTableViewCell.h"
#import "KnowledgeDetailViewController.h"

#define MENU_BUTTON_WIDTH  90

@interface KnowledgeListViewController ()
@end

@implementation KnowledgeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _tableViewArray = [[NSMutableArray alloc]init];
    _lorelistArray = [[NSMutableArray alloc]init];
    self.title = @"健康知识";
    [self startProgress];
    [[HttpRequest shared]getLoreClassFinish:^(id responseObject) {
        _loreClassArray = responseObject[@"tngou"];
        [self createBtn];
        [self refreshData];
        [self getLoreclassBy:0];
        [self refreshTableView:0];
    }];
    _scrollView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) refreshTableView :(int)index
{
    _reuseTableView = _tableViewArray[index];
    _reuseTableView.originX = self.mainScreenWidth * index;
    _reuseTableView.header = [MJLoadingHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    _reuseTableView.footer = [MJLoadingFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

- (void)getLoreclassBy:(long)index
{
    NSDictionary *dic = [_loreClassArray objectAtIndex:index];
    _loreclass = [dic[@"id"] longValue];
}

- (void)refreshData
{
    _page = 1;
    __weak KnowledgeListViewController *weakSelf = self;
    weakSelf.reuseTableView.footer.hidden = YES;
    [[HttpRequest shared]getLoreListByloreClass:_loreclass withPage:_page withFinish:^(NSArray *loreListArray, NSError *error, int total) {
        [weakSelf stopProgress];
        [weakSelf.reuseTableView.header endRefreshing];
        if (error == nil) {
            [weakSelf.lorelistArray removeAllObjects];
            [weakSelf.lorelistArray addObjectsFromArray:loreListArray];
            [weakSelf.reuseTableView reloadData];
            if (weakSelf.lorelistArray.count >= total) {
                weakSelf.reuseTableView.footer.hidden = YES;
            }
            else {
                weakSelf.reuseTableView.footer.hidden = NO;
            }
            if (weakSelf.lorelistArray.count == 0) {
                [self showEmptyView:nodata];
            }
        }
        else {
            weakSelf.reuseTableView.footer.hidden = YES;
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
    __weak KnowledgeListViewController *weakSelf = self;
    [[HttpRequest shared]getLoreListByloreClass:_loreclass withPage:_page withFinish:^(NSArray *loreListArray, NSError *error, int total) {
        if (error == nil) {
            [weakSelf.lorelistArray addObjectsFromArray:loreListArray];
            [weakSelf.reuseTableView reloadData];
            if (weakSelf.lorelistArray.count >= total) {
                //已加载全部
                [weakSelf.reuseTableView.footer noticeNoMoreData];
            }
            else {
                [weakSelf.reuseTableView.footer endRefreshing];
            }
        }
        else {
            if (error.code == NSURLErrorNotConnectedToInternet) {
                
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createBtn
{
    for (int i = 0; i < _loreClassArray.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(MENU_BUTTON_WIDTH * i, 0, MENU_BUTTON_WIDTH, _topScrollView.height)];
        NSDictionary *dic = [_loreClassArray objectAtIndex:i];
        [btn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(actionbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:btn];
    }
    [_topScrollView setContentSize:CGSizeMake(MENU_BUTTON_WIDTH * _loreClassArray.count, _topScrollView.height)];
    _scrollBgView = [[UIView alloc] initWithFrame:CGRectMake(0, _topScrollView.height - 2, MENU_BUTTON_WIDTH, 2)];
    [_scrollBgView setBackgroundColor:[UIColor redColor]];
    [_topScrollView addSubview:_scrollBgView];
    [_scrollView setContentSize:CGSizeMake(self.mainScreenWidth * _loreClassArray.count, 0)];
    [self addTableViewToScrollView:_scrollView count:_loreClassArray.count frame:CGRectZero];
}

- (void)addTableViewToScrollView:(UIScrollView *)scrollView count:(NSUInteger)pageCount frame:(CGRect)frame
{
    for (int i = 0; i < pageCount; i++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.mainScreenWidth * i, 0 , self.mainScreenWidth, self.mainScreenHeight - 40 - self.statusBarAndnavgationBarHeight - self.tabBarHeight)];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        tableView.tag = i;
        [tableView registerNib:[UINib nibWithNibName:@"KnowledgeListTableViewCell" bundle:nil] forCellReuseIdentifier:@"myIdentify"];
        [_tableViewArray addObject:tableView];
        [scrollView addSubview:tableView];
    }
}

- (void)changeView:(float)x
{
    float xx = x * (MENU_BUTTON_WIDTH / self.mainScreenWidth);
    [_scrollBgView setFrame:CGRectMake(xx, _scrollBgView.originY, _scrollBgView.width, _scrollBgView.height)];
}

- (void)actionbtn:(UIButton *)btn
{
    [_scrollView setContentOffset:CGPointMake(self.mainScreenWidth * (btn.tag - 1), 0) animated:YES];
    float xx = self.mainScreenWidth * (btn.tag - 1) * (MENU_BUTTON_WIDTH / self.mainScreenWidth) - MENU_BUTTON_WIDTH;
    [_topScrollView scrollRectToVisible:CGRectMake(xx, 0, self.mainScreenWidth, _topScrollView.height) animated:YES];
    [self getLoreclassBy:(int)btn.tag - 1];
    [self refreshTableView:(int)btn.tag - 1];
    [self refreshData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return _lorelistArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KnowledgeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myIdentify"];
    TSLoreList *model = [_lorelistArray objectAtIndex:indexPath.section];
    cell.imgView.contentMode = UIViewContentModeScaleAspectFit;
    if (model.img == nil) {
        cell.imgView.image = [UIImage imageNamed:@"img_iInvalidphoto_75x75"];
    }
    else {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,model.img]] placeholderImage:nil];
    }
    cell.titleLable.text = model.title;
    cell.visitCountLabel.text = [NSString stringWithFormat:@"浏览%d次",model.visitCount];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KnowledgeDetailViewController *vc = [[KnowledgeDetailViewController alloc]init];
    TSLoreList *model = _lorelistArray[indexPath.section];
    vc.Id = model.Id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        //tableView
    }
    else {
       [self changeView:scrollView.contentOffset.x];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        //tableView
    }
    else {
        float xx = scrollView.contentOffset.x * (MENU_BUTTON_WIDTH / self.mainScreenWidth) - MENU_BUTTON_WIDTH;
        [_topScrollView scrollRectToVisible:CGRectMake(xx, 0, self.mainScreenWidth, _topScrollView.height) animated:YES];
        int i = (scrollView.contentOffset.x / self.mainScreenWidth);
        [self getLoreclassBy:i];
        [self refreshTableView:i];
        [self refreshData];
    }
}
@end
