//
//  DrugListTableViewCell.m
//  health
//
//  Created by tom.sun on 15/8/25.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "DrugListTableViewCell.h"
#import "UIView+frame.h"

@implementation DrugListTableViewCell

- (void)awakeFromNib {
    [_line toCommonLineHight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
