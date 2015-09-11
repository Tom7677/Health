//
//  HealthQuestionViewController.h
//  health
//
//  Created by tom.sun on 15/8/13.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface HealthQuestionViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *questionClassArray;
@property (nonatomic, strong) NSMutableDictionary *questionListDic;
@end
