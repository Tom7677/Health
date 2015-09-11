//
//  QuestionListTableViewCell.h
//  health
//
//  Created by tom.sun on 15/9/7.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
