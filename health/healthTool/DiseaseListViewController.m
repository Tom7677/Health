//
//  DiseaseListViewController.m
//  health
//
//  Created by tom.sun on 15/5/29.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "DiseaseListViewController.h"
#import "TSTagView.h"
#import "DiseaseDetailViewController.h"

@interface DiseaseListViewController ()

@end

@implementation DiseaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见疾病";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _diseaseListArray = [[NSMutableArray alloc]init];
    _departmentNameArray = [[NSMutableArray alloc]init];
    _placeNameArray = [[NSMutableArray alloc]init];
    _diseaseNameArray = [[NSMutableArray alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self getClass];
    [_confirmBtn circularBead];
}

- (void)getClass
{
    [self startProgress];
    [[HttpRequest shared]getDiseaseDepartmentFinish:^(NSArray *array) {
        _departmentArray = array;
        for (int i = 0; i < _departmentArray.count; i ++) {
            [_departmentNameArray addObject:(_departmentArray[i])[@"name"]];
        }
        [[HttpRequest shared]getDiseasePlaceFinish:^(NSArray *array) {
            _placeArray = array;
            for (int i = 0; i < _placeArray.count; i ++) {
                [_placeNameArray addObject:(_placeArray[i])[@"name"]];
            }
            _page = 1;
            [self refreshData:0 placeIndex:0];
        }];
    }];
}

- (void)refreshData:(int)departmentIndex placeIndex :(int)placeIndex
{
    [[HttpRequest shared]getDiseaseListByDiseaseDepartment:[(_departmentArray[departmentIndex][@"id"]) longValue] byPlace:[(_placeArray[placeIndex][@"id"]) longValue] byPage:_page withFinish:^(NSArray *diseaseListArray, NSError *error, int total) {
        if (_page > 1) {
            [_diseaseListArray addObjectsFromArray:diseaseListArray];
        }
        else {
            [_diseaseListArray removeAllObjects];
            [_diseaseListArray addObjectsFromArray:diseaseListArray];
        }
        if (_diseaseListArray.count < total) {
            _page = _page + 1;
            [self refreshData:departmentIndex placeIndex:placeIndex];
        }
        else {
            [_diseaseNameArray removeAllObjects];
            for (int i = 0; i < _diseaseListArray.count; i ++) {
                TSDiseaseList *model = _diseaseListArray[i];
                [_diseaseNameArray addObject:model.name];
            }
            [self stopProgress];
            [_tableView reloadData];
        }
        if (total > 0) {
            [_confirmBtn setBackgroundColor:MainColor];
            _confirmBtn.enabled = YES;
            TSDiseaseList *model = [self.diseaseListArray objectAtIndex:0];
            _diseaseId = [NSString stringWithFormat:@"%ld",model.Id];
            _diseaseName = model.name;
        }
        else {
            [_confirmBtn setBackgroundColor:UIColorFromRGB(0x6A4847)];
            _confirmBtn.enabled = NO;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    for (int i=0; i<cell.contentView.subviews.count; i++) {
        UIView *view = [cell.contentView.subviews objectAtIndex:i];
        if ([view isKindOfClass:[TSTagView class]]) {
            TSTagView *tagView = (TSTagView *)view;
            for (UIView *view in [tagView subviews]) {
                [view removeFromSuperview];
            }
        }else{
            [view removeFromSuperview];
        }
    }
    if (indexPath.section ==0) {
        if (self.categoryName) {
            return cell;
        }
    }
    NSArray *array = nil;
    NSInteger index = 0;
    switch (indexPath.section) {
        case 0:
            index = _selectedDepartment;
            array = _departmentNameArray;
            break;
        case 1:
            index = _selectedPlace;
            array = _placeNameArray;
            break;
        case 2:
            index = _selectedDisease;
            array = _diseaseNameArray;
            break;
        default:
            break;
    }
    TSTagView *view = [[TSTagView alloc] initWithFrame:CGRectMake(0, 0, self.mainScreenWidth, [TSTagView HeightWithArray:array AndWidth:self.mainScreenWidth])];
    [view creatWithArray:array AndWidth:self.mainScreenWidth];
    [view selectedToButton:index];
    [cell.contentView addSubview:view];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xdddddd);
    [cell.contentView addSubview:line];
    line.frame = CGRectMake(0, cell.height - 0.5, self.mainScreenWidth, 0.5);
    [view setTagCallBack:^(NSInteger index) {
        switch (indexPath.section) {
            case 0:{
                _selectedDepartment = index;
                NSDictionary *dic = [self.departmentArray objectAtIndex:index];
                _departmentId = dic[@"id"];
                _departmentName = dic[@"name"];
                _selectedPlace = 0;
                _placeId = @"";
                _placeName = @"";
                
                if (self.fiterCidCallBack) {
                    self.fiterCidCallBack(_departmentId);
                }
                _page = 1;
                NSLog(@"%ld  %ld",(long)_selectedDepartment,_selectedPlace);
                [self refreshData:(int)_selectedDepartment placeIndex:(int)_selectedPlace];
                _selectedDisease = 0;
                _diseaseName = @"";
                _diseaseId = 0;
            }break;
            case 1:{
                _selectedPlace = index;
                NSDictionary *dic = [_placeArray objectAtIndex:index];
                _placeId = dic[@"id"];
                _placeName = dic[@"name"];
                
                if (self.fiterCidCallBack) {
                    self.fiterCidCallBack(_placeId);
                }
                _page = 1;
                [self refreshData:(int)_selectedDepartment placeIndex:(int)_selectedPlace];
                _selectedDisease = 0;
                _diseaseName = @"";
                _diseaseId = @"";
                
            }break;
            case 2:{
                _selectedDisease = index;
                TSDiseaseList *model = [self.diseaseListArray objectAtIndex:index];
                _diseaseId = [NSString stringWithFormat:@"%ld",model.Id];
                _diseaseName = model.name;
            }
            default:
                break;
        }
        [self.tableView reloadData];
    }];
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
            titleLabel.text = @"就诊科室";
            break;
        }case 1:{
            titleLabel.text = @"身体部位";
            break;
        }case 2:{
            titleLabel.text = @"相关疾病";
            break;
        }
        default:
            break;
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.categoryName) {
            return 0;
        }
        return [TSTagView HeightWithArray:_departmentNameArray AndWidth:self.mainScreenWidth];
    }
    if (indexPath.section ==1){
        return [TSTagView HeightWithArray:_placeNameArray AndWidth:self.mainScreenWidth];
    }
    if (indexPath.section ==2){
        return [TSTagView HeightWithArray:_diseaseNameArray AndWidth:self.mainScreenWidth];
    }
    return 0;
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
- (IBAction)confirmBtnAction:(id)sender {
    DiseaseDetailViewController *vc = [[DiseaseDetailViewController alloc]init];
    vc.diseaseId = _diseaseId;
    vc.diseaseName = _diseaseName;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
