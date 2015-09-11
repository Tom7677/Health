//
//  DrugListViewController.h
//  health
//
//  Created by tom.sun on 15/5/29.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface DrugListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *drugListArray;
@property (assign, nonatomic) NSInteger tag;
@end
