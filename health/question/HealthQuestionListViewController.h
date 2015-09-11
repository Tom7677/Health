//
//  HealthQuestionListViewController.h
//  health
//
//  Created by tom.sun on 15/9/7.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface HealthQuestionListViewController : BaseViewController
@property (nonatomic ,assign) long Id;
@property (nonatomic ,copy) NSString *name;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *questionListArray;
@property (assign, nonatomic) long page;
@end
