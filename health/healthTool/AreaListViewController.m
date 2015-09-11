//
//  AreaListViewController.m
//  health
//
//  Created by tom.sun on 15/9/9.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "AreaListViewController.h"

@interface AreaListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)NSMutableArray *provinceArray;
@property (strong, nonatomic)NSMutableDictionary *citysDic;
@property (strong, nonatomic)NSMutableArray *dateArray;
@property (nonatomic , strong) NSMutableArray *tempDataArray;//用于存储数据源（部分数据）
@end

@implementation AreaListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _provinceArray = [[NSMutableArray alloc]init];
    _citysDic = [[NSMutableDictionary alloc]init];
    _dateArray = [[NSMutableArray alloc]init];
    [self getAreaArray];
    [self initData];
    _tempDataArray = [NSMutableArray array];
    for (int i=0; i< _dateArray.count; i++) {
        TSArea *area = [_dateArray objectAtIndex:i];
        if (area.expand) {
            [_tempDataArray addObject:area];
        }
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)getAreaArray
{
    NSError *error = nil;
    NSString *regionInfoFilePath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSData *reionInfoData = [NSData dataWithContentsOfFile:regionInfoFilePath];
    NSArray *regionDetails = [NSJSONSerialization JSONObjectWithData:reionInfoData options:NSJSONReadingMutableContainers error:&error];
    for (int i = 0; i < regionDetails.count; i ++) {
        NSDictionary *temp = regionDetails[i];
        [_provinceArray addObject:temp[@"province"]];
        [_citysDic setObject:temp[@"citys"] forKey:temp[@"province"]];
    }
}

- (void)initData
{
    int nodeId = 0;
    int parentId = 0;
    for (int i = 0; i < _provinceArray.count; i ++) {
        TSArea *province = [[TSArea alloc]initWithParentId:-1 nodeId:nodeId  name:_provinceArray[i] depth:0 expand:YES cityId:-1];
        [_dateArray addObject:province];
        parentId = nodeId;
        for (int j = 0; j < [_citysDic[_provinceArray[i]] count]; j ++) {
            nodeId = nodeId + 1;
            NSArray *cityArray = _citysDic[_provinceArray[i]];
            TSArea *city = [[TSArea alloc]initWithParentId:parentId nodeId:nodeId  name:(cityArray[j])[@"city"] depth:1 expand:NO cityId:[(cityArray[j])[@"id"] longValue]];
            [_dateArray addObject:city];
        }
        nodeId = nodeId + 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tempDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"node_cell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    }
    
    TSArea *area= [_tempDataArray objectAtIndex:indexPath.row];
    NSMutableString *name = [NSMutableString string];
    for (int i=0; i<area.depth; i++) {
        [name appendString:@"     "];
    }
    [name appendString:area.name];
    cell.textLabel.text = name;
    
    return cell;
}

#pragma mark - Optional
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UITableViewDelegate

#pragma mark - Optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //先修改数据源
    TSArea *parentArea = [_tempDataArray objectAtIndex:indexPath.row];
    NSUInteger startPosition = indexPath.row+1;
    NSUInteger endPosition = startPosition;
    BOOL expand = NO;
    for (int i=0; i<_dateArray.count; i++) {
        TSArea *area = [_dateArray objectAtIndex:i];
        if (area.parentId == parentArea.nodeId) {
            area.expand = !area.expand;
            if (area.expand) {
                [_tempDataArray insertObject:area atIndex:endPosition];
                expand = YES;
            }else{
                expand = NO;
                endPosition = [self removeAllNodesAtParentNode:parentArea];
                break;
            }
            endPosition++;
        }
    }
    //获得需要修正的indexPath
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i=startPosition; i<endPosition; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:tempIndexPath];
    }
    
    //插入或者删除相关节点
    if (expand) {
        [_tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [_tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }
    if (_tempDataArray.count > 34 && expand == NO) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@市",parentArea.name] forKey:@"CityName"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",parentArea.cityId] forKey:@"CityId"];
        [_delegate passCityName:[NSString stringWithFormat:@"%@市",parentArea.name] cityId:parentArea.cityId];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *
 *  @param parentNode 父节点
 *
 *  @return 邻接父节点的位置距离该父节点的长度，也就是该父节点下面所有的子孙节点的数量
 */
-(NSUInteger)removeAllNodesAtParentNode : (TSArea *)parentArea{
    NSUInteger startPosition = [_tempDataArray indexOfObject:parentArea];
    NSUInteger endPosition = startPosition;
    for (NSUInteger i=startPosition + 1; i<_tempDataArray.count; i++) {
        TSArea *area = [_tempDataArray objectAtIndex:i];
        endPosition++;
        if (area.depth == parentArea.depth) {
            break;
        }
        area.expand = NO;
    }
    if (endPosition>startPosition) {
        [_tempDataArray removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
    }
    return endPosition;
}
@end
