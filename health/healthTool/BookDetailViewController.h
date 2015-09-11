//
//  BookDetailViewController.h
//  health
//
//  Created by tom.sun on 15/9/1.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface BookDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) long Id;
@property (strong, nonatomic) TSHealthBookDetail *model;
@property (strong, nonatomic) NSArray *sortArray;
@end
