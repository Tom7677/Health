//
//  DrugListTableViewCell.h
//  health
//
//  Created by tom.sun on 15/8/25.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrugListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *factoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UIView *line;
@end
