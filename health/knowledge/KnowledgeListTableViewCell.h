//
//  KnowledgeListTableViewCell.h
//  health
//
//  Created by ECarChina on 15/7/19.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KnowledgeListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *visitCountLabel;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
