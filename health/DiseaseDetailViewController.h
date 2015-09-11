//
//  DiseaseDetailViewController.h
//  health
//
//  Created by tom.sun on 15/8/24.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface DiseaseDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (copy, nonatomic) NSString *diseaseId;
@property (copy, nonatomic) NSString *diseaseName;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) TSDiseaseDetail *model;
@end
