//
//  HospitalListTableViewCell.m
//  health
//
//  Created by tom.sun on 15/9/11.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "HospitalListTableViewCell.h"
#import "UIView+frame.h"

@implementation HospitalListTableViewCell

- (void)awakeFromNib {
    [_line toCommonLineHight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
