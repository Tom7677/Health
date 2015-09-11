//
//  DrugClassViewController.h
//  health
//
//  Created by tom.sun on 15/8/25.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface DrugClassViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *drugClassArray;
@property (assign, nonatomic) NSInteger tag;
@end
