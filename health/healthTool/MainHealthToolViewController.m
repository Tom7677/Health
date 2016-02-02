//
//  MainHealthToolViewController.m
//  health
//
//  Created by tom.sun on 15/8/3.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "MainHealthToolViewController.h"
#import "DrugClassViewController.h"
#import "DiseaseListViewController.h"
#import "BookListViewController.h"
#import "DrugListViewController.h"
#import "HospitalViewController.h"

@interface MainHealthToolViewController ()

@end

@implementation MainHealthToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康工具";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _bgView.width = self.mainScreenWidth;
    [_scrollView addSubview:_bgView];
    if (self.mainScreenHeight >= self.iphone5Height) {
        [_scrollView setScrollEnabled:NO];
    }
    else {
        [_scrollView setContentSize:CGSizeMake(self.mainScreenWidth, _bgView.height - self.tabBarHeight)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)drugBtnAction:(id)sender {
    DrugClassViewController *vc = [[DrugClassViewController alloc]init];
    vc.tag = 2;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)healthBookAction:(id)sender {
    BookListViewController *vc = [[BookListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)laboratoryTestBtnAction:(id)sender {
    DrugClassViewController *vc = [[DrugClassViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tag = 4;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)surgeryBtnAction:(id)sender {
    DrugListViewController *vc = [[DrugListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tag = 5;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)hospitalBtnAction:(id)sender {
    HospitalViewController *vc = [[HospitalViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
