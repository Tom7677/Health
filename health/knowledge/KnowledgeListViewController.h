//
//  KnowledgeListViewController.h
//  health
//
//  Created by tom.sun on 15/5/29.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface KnowledgeListViewController : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MAMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *reuseTableView;
@property (strong, nonatomic) NSArray *loreClassArray;
@property (strong, nonatomic) NSMutableArray *lorelistArray;
@property (strong, nonatomic) NSMutableArray *tableViewArray;
@property (strong, nonatomic) UIView *scrollBgView;
@property (assign, nonatomic) int page;
@property (assign, nonatomic) long loreclass;
@end
