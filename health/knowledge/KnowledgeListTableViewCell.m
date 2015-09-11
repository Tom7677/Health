//
//  KnowledgeListTableViewCell.m
//  health
//
//  Created by ECarChina on 15/7/19.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "KnowledgeListTableViewCell.h"
#import "UIView+frame.h"

@implementation KnowledgeListTableViewCell

- (void)awakeFromNib {
    [_line toCommonLineHight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
