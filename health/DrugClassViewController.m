//
//  DrugClassViewController.m
//  health
//
//  Created by tom.sun on 15/8/25.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "DrugClassViewController.h"
#import "DrugListViewController.h"

@interface DrugClassViewController ()

@end

@implementation DrugClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startProgress];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (_tag == 2) {
        self.title = @"药品分类";
        [[HttpRequest shared]getDrugClassFinish:^(NSArray *array) {
            [self stopProgress];
            _drugClassArray = array;
            [_tableView reloadData];
        }];
    }
    if (_tag == 4) {
        self.title = @"检查项目";
        [[HttpRequest shared]getCheckProjectClassFinish:^(NSArray *array) {
            [self stopProgress];
            _drugClassArray = array;
            [_tableView reloadData];
        }];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 40;
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _drugClassArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",(_drugClassArray[indexPath.row])[@"title"]];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, self.mainScreenWidth, 0.5)];
    [line setBackgroundColor:UIColorFromRGB(0xdddddd)];
    [cell.contentView addSubview:line];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DrugListViewController *vc = [[DrugListViewController alloc]init];
    vc.Id = [NSString stringWithFormat:@"%@",(_drugClassArray[indexPath.row])[@"id"]];
    vc.tag = _tag;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
