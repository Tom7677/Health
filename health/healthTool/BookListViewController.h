//
//  BookListViewController.h
//  health
//
//  Created by tom.sun on 15/8/26.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface BookListViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *bookClassTableView;
@property (weak, nonatomic) IBOutlet UITableView *bookListTableView;
@property (strong, nonatomic) NSArray *bookClassArray;
@property (strong, nonatomic) NSMutableArray *bookListArray;;
@property (assign, nonatomic) long page;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) BOOL isFirst;
@end
