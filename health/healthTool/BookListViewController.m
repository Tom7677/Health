//
//  BookListViewController.m
//  health
//
//  Created by tom.sun on 15/8/26.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BookListViewController.h"
#import "BookListTableViewCell.h"
#import "BookDetailViewController.h"

@interface BookListViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirst = YES;
    self.title = @"健康书籍";
    _bookClassTableView.delegate = self;
    _bookClassTableView.dataSource = self;
    _bookListTableView.delegate = self;
    _bookListTableView.dataSource = self;
    _bookListArray = [[NSMutableArray alloc]init];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([_bookClassTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_bookClassTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_bookClassTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_bookClassTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([_bookListTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_bookListTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_bookListTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_bookListTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [_bookClassTableView setLayoutMargins:UIEdgeInsetsZero];
    [self getBookClass];
    [self startProgress];
    _index = 0;
    _bookClassTableView.tableFooterView = [UIView new];
    [_bookListTableView registerNib:[UINib nibWithNibName:@"BookListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    _bookListTableView.header = [MJLoadingHeader headerWithRefreshingBlock:^{
        [self getBookList];
    }];
    _bookListTableView.footer = [MJLoadingFooter footerWithRefreshingBlock:^{
        [self getMoreBookList];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (_isFirst) {
        [_bookClassTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        if ([_bookClassTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        {
            [_bookClassTableView.delegate tableView:_bookClassTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        }
    }
    _isFirst = NO;
}

- (void)getBookClass
{
    [[HttpRequest shared]getHealthBookClassFinish:^(NSArray *array) {
        _bookClassArray = array;
        [_bookClassTableView reloadData];
    }];
}

- (void)getBookList
{
    _page = 1;
    [[HttpRequest shared]getHealthBookBybookClassId:[(_bookClassArray[_index])[@"id"] longValue] withPage:_page withFinish:^(NSArray *bookListArray, NSError *error, int total) {
        [self stopProgress];
        if (_bookListArray.count >= total) {
            _bookListTableView.footer.hidden = YES;
        }
        else {
            _bookListTableView.footer.hidden = NO;
        }
        [_bookListTableView.header endRefreshing];
        [_bookListArray removeAllObjects];
        [_bookListArray addObjectsFromArray:bookListArray];
        [_bookListTableView reloadData];
    }];
}

- (void)getMoreBookList
{
    _page = _page + 1;
    [[HttpRequest shared]getHealthBookBybookClassId:[(_bookClassArray[_index])[@"id"] longValue] withPage:_page withFinish:^(NSArray *bookListArray, NSError *error, int total) {
        [_bookListArray addObjectsFromArray:bookListArray];
        if (_bookListArray.count >= total) {
            //已加载全部
            [_bookListTableView.footer noticeNoMoreData];
        }
        else {
            [_bookListTableView.footer endRefreshing];
        }
        [_bookListTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (tableView.tag == 1) {
        return _bookClassArray.count;
    }
    if (tableView.tag == 2) {
        return _bookListArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView.tag == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        cell.textLabel.text = (_bookClassArray[indexPath.row])[@"name"];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = bgColorView;
        UIView *line = [[UIView alloc]initWithFrame: CGRectMake(0, 59, 100, 0.5)];
        line.backgroundColor = UIColorFromRGB(0xdddddd);
        [cell.contentView addSubview:line];
        return cell;
    }
    if (tableView.tag == 2) {
        BookListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        TSHealthBookList *model = _bookListArray[indexPath.row];
        cell.pic.contentMode = UIViewContentModeScaleAspectFit;
        if (model.img == nil) {
            cell.pic.image = [UIImage imageNamed:@"img_iInvalidphoto_75x75"];
        }
        else {
            [cell.pic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,model.img]] placeholderImage:nil];
        }
        cell.nameLabel.text = model.name;
        cell.authorLabel.text = model.author;
        cell.contentLabel.text = model.summary;
        return cell;
    }
    return nil;
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView.tag == 1) {
        return 60;
    }
    if (tableView.tag == 2) {
        return 90;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        [_bookListArray removeAllObjects];
        [_bookListTableView reloadData];
        _index = indexPath.row;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = MainColor;
        _bookListTableView.footer.hidden = YES;
        [self getBookList];
    }
    if (tableView.tag == 2) {
        TSHealthBookList *model = _bookListArray[indexPath.row];
        BookDetailViewController *vc = [[BookDetailViewController alloc]init];
        vc.Id = model.Id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor blackColor];
    }
}


//将tableview边上的空白去掉
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    if (tableView.tag == 2) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}
@end
