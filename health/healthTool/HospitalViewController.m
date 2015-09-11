//
//  HospitalViewController.m
//  health
//
//  Created by tom.sun on 15/9/9.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "HospitalViewController.h"
#import "AreaListViewController.h"
#import "TSImgeRightButton.h"
#import "AppDelegate.h"
#import "HospitalListTableViewCell.h"
#import "HospitalDetailViewController.h"

@interface HospitalViewController ()<PassCityDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) long cityId;
@property (nonatomic, strong) TSImgeRightButton *btn;
@property (nonatomic, assign) CGFloat X;
@property (nonatomic, assign) CGFloat Y;
@property (nonatomic, assign) long page;
@property (nonatomic, strong) NSMutableArray *hospitalListArray;
@property (nonatomic, assign) BOOL isArea;
@end

@implementation HospitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isArea = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    _btn = [[TSImgeRightButton alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    if (!_isArea) {
        if ([delegate.city isEqualToString:@""]) {
            NSString *city = [[NSUserDefaults standardUserDefaults]stringForKey:@"CityName"];
            if (nil == city || [@"" isEqualToString:city]) {
                [_btn setTitle:@"上海市" forState:UIControlStateNormal];
                _cityId = 4;
            }
            else {
                [_btn setTitle:city forState:UIControlStateNormal];
                NSString *cityId =[[NSUserDefaults standardUserDefaults]stringForKey:@"CityId"];
                _cityId = (long)[cityId longLongValue];
            }
        }
        else {
            [_btn setTitle:delegate.city forState:UIControlStateNormal];
            _X = delegate.X;
            _Y = delegate.Y;
        }
    }
    _btn.titleLabel.textColor = [UIColor whiteColor];
    [_btn setImage:[UIImage imageNamed:@"iconfont-zhankai"] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(changeCity) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView= _btn;
    [self refreshData];
    _tableView.header = [MJLoadingHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    _tableView.footer = [MJLoadingFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    [_tableView registerNib:[UINib nibWithNibName:@"HospitalListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    _hospitalListArray = [[NSMutableArray alloc]init];
    [self startProgress];
}

- (void)refreshData
{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    _page = 1;
    if ([delegate.city isEqualToString:@""] || _isArea == YES) {
        [[HttpRequest shared]getHospitalListById:_cityId byPage:_page withFinish:^(NSArray *hospitalListArray, NSError *error, int total) {
            [self stopProgress];
            [_tableView.header endRefreshing];
            [_hospitalListArray removeAllObjects];
            [_hospitalListArray addObjectsFromArray:hospitalListArray];
            [_tableView reloadData];
        }];
    }
    else {
        [[HttpRequest shared]getHospitalListByX:_X Y:_Y byPage:_page withFinish:^(NSArray *hospitalListArray, NSError *error, int total) {
            [self stopProgress];
            [_tableView.header endRefreshing];
            [_hospitalListArray removeAllObjects];
            [_hospitalListArray addObjectsFromArray:hospitalListArray];
            [_tableView reloadData];
        }];
    }
}

- (void)loadMoreData
{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    _page = _page + 1;
    if ([delegate.city isEqualToString:@""] || _isArea == YES) {
        [[HttpRequest shared]getHospitalListById:_cityId byPage:_page withFinish:^(NSArray *hospitalListArray, NSError *error, int total) {
            [_hospitalListArray addObjectsFromArray:hospitalListArray];
            if (_hospitalListArray.count >= total) {
                //已加载全部
                [_tableView.footer noticeNoMoreData];
            }
            else {
                [_tableView.footer endRefreshing];
            }
            [_tableView reloadData];
        }];
    }
    else {
        [[HttpRequest shared]getHospitalListByX:_X Y:_Y byPage:_page withFinish:^(NSArray *hospitalListArray, NSError *error, int total) {
            [_hospitalListArray addObjectsFromArray:hospitalListArray];
            if (_hospitalListArray.count >= total) {
                //已加载全部
                [_tableView.footer noticeNoMoreData];
            }
            else {
                [_tableView.footer endRefreshing];
            }
            [_tableView reloadData];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)passCityName: (NSString *)cityName cityId:(long)cityId
{
    [_btn setTitle:cityName forState:UIControlStateNormal];
    _cityId = cityId;
    _isArea = YES;
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)changeCity
{
    AreaListViewController *vc = [[AreaListViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _hospitalListArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    HospitalListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    TSHospitalList *model = [_hospitalListArray objectAtIndex:indexPath.row];
    cell.pic.contentMode = UIViewContentModeScaleAspectFit;
    if (model.img == nil) {
        cell.pic.image = [UIImage imageNamed:@"img_iInvalidphoto_75x75"];
    }
    else {
        [cell.pic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,model.img]] placeholderImage:nil];
    }
    [cell.line toCommonLineHight];
    cell.nameLabel.text = model.name;
    cell.addressLabel.text = model.address;
    cell.mtypeLabel.text = model.mtype;
    cell.levelLabel.text = model.level;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSHospitalList *model = [_hospitalListArray objectAtIndex:indexPath.row];
    HospitalDetailViewController *vc = [[HospitalDetailViewController alloc]init];
    vc.name = model.name;
    vc.Id = model.Id;
    vc.gobus = model.gobus;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
