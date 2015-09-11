//
//  DrugListViewController.m
//  health
//
//  Created by tom.sun on 15/5/29.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "DrugListViewController.h"
#import "DrugListTableViewCell.h"
#import "CheckListTableViewCell.h"
#import "DrugDetailViewController.h"

@interface DrugListViewController ()

@end

@implementation DrugListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_tag == 2) {
        self.title = @"药品列表";
        [_tableView registerNib:[UINib nibWithNibName:@"DrugListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    }
    if (_tag == 4) {
        self.title = @"检查项目列表";
        [_tableView registerNib:[UINib nibWithNibName:@"CheckListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    }
    if (_tag == 5) {
        self.title = @"手术项目列表";
        [_tableView registerNib:[UINib nibWithNibName:@"CheckListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    }
    _drugListArray = [[NSMutableArray alloc]init];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self startProgress];
    [self refreshData];
    _tableView.header = [MJLoadingHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    _tableView.footer = [MJLoadingFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

- (void)refreshData
{
    _page = 1;
    if (_tag == 2) {
        [[HttpRequest shared]getDrugListByDrugClass:[_Id longLongValue] withPage:_page withFinish:^(NSArray *drugListArray, NSError *error, int total) {
            [self stopProgress];
            [_tableView.header endRefreshing];
            if (error == nil) {
                [_drugListArray removeAllObjects];
                [_drugListArray addObjectsFromArray:drugListArray];
                [_tableView reloadData];
                if (_drugListArray.count >= total) {
                    _tableView.footer.hidden = YES;
                }
                else {
                    _tableView.footer.hidden = NO;
                }
                if (_drugListArray.count == 0) {
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
    if (_tag == 4) {
        [[HttpRequest shared]getCheckProjectListById:[_Id longLongValue] byPage:_page withFinish:^(NSArray *checkProjectListArray, NSError *error, int total) {
            [self stopProgress];
            [_tableView.header endRefreshing];
            if (error == nil) {
                [_drugListArray removeAllObjects];
                [_drugListArray addObjectsFromArray:checkProjectListArray];
                [_tableView reloadData];
                if (_drugListArray.count >= total) {
                    _tableView.footer.hidden = YES;
                }
                else {
                    _tableView.footer.hidden = NO;
                }
                if (_drugListArray.count == 0) {
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
    if (_tag == 5) {
        [[HttpRequest shared]getSurgeryListById:[_Id longLongValue] byPage:_page withFinish:^(NSArray *surgeryListArray, NSError *error, int total) {
            [self stopProgress];
            [_tableView.header endRefreshing];
            if (error == nil) {
                [_drugListArray removeAllObjects];
                [_drugListArray addObjectsFromArray:surgeryListArray];
                [_tableView reloadData];
                if (_drugListArray.count >= total) {
                    _tableView.footer.hidden = YES;
                }
                else {
                    _tableView.footer.hidden = NO;
                }
                if (_drugListArray.count == 0) {
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
}

- (void)loadMoreData
{
    _page = _page + 1;
    if (_tag == 2) {
        [[HttpRequest shared]getDrugListByDrugClass:[_Id longLongValue] withPage:_page withFinish:^(NSArray *drugListArray, NSError *error, int total) {
            if (error == nil) {
                [_drugListArray addObjectsFromArray:drugListArray];
                [_tableView reloadData];
                if (_drugListArray.count >= total) {
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
    if (_tag == 4) {
        [[HttpRequest shared]getCheckProjectListById:[_Id longLongValue] byPage:_page withFinish:^(NSArray *checkProjectListArray, NSError *error, int total) {
            if (error == nil) {
                [_drugListArray addObjectsFromArray:checkProjectListArray];
                [_tableView reloadData];
                if (_drugListArray.count >= total) {
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
    if (_tag == 5) {
        [[HttpRequest shared]getSurgeryListById:[_Id longLongValue] byPage:_page withFinish:^(NSArray *surgeryListArray, NSError *error, int total) {
            if (error == nil) {
                [_drugListArray addObjectsFromArray:surgeryListArray];
                [_tableView reloadData];
                if (_drugListArray.count >= total) {
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _drugListArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_tag == 2) {
        DrugListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        TSDrugList *model = [_drugListArray objectAtIndex:indexPath.row];
        cell.pic.contentMode = UIViewContentModeScaleAspectFit;
        if (model.img == nil) {
            cell.pic.image = [UIImage imageNamed:@"img_iInvalidphoto_75x75"];
        }
        else {
            [cell.pic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,model.img]] placeholderImage:nil];
        }
        cell.nameLabel.text = model.name;
        cell.factoryLabel.text = model.factory;
        cell.typeLabel.text = model.type;
        cell.countLabel.text = [NSString stringWithFormat:@"浏览%d次",model.visitCount];
        return cell;
    }
    if (_tag == 4 || _tag == 5) {
        CheckListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        TSCheckProjectList *model = [_drugListArray objectAtIndex:indexPath.row];
        cell.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        if (model.img == nil) {
            cell.coverImageView.image = [UIImage imageNamed:@"img_iInvalidphoto_75x75"];
        }
        else {
            [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,model.img]] placeholderImage:nil];
        }
        [cell.line toCommonLineHight];
        cell.nameLabel.text = model.name;
        cell.discription.text = model.des;
        cell.countLabel.text = [NSString stringWithFormat:@"浏览%d次",model.visitCount];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DrugDetailViewController *vc = [[DrugDetailViewController alloc]init];
    if (_tag == 2) {
        TSDrugList *model = [_drugListArray objectAtIndex:indexPath.row];
        vc.Id = model.Id;
        vc.name = model.name;
    }
    if (_tag == 4) {
        TSCheckProjectList *model = [_drugListArray objectAtIndex:indexPath.row];
        vc.Id = model.Id;
        vc.name = model.name;
    }
    if (_tag == 5) {
        TSSurgeryList *model = [_drugListArray objectAtIndex:indexPath.row];
        vc.Id = model.Id;
        vc.name = model.name;
    }
    vc.tag = _tag;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
