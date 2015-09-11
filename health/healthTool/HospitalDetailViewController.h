//
//  HospitalDetailViewController.h
//  health
//
//  Created by tom.sun on 15/9/11.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface HospitalDetailViewController : BaseViewController
@property (assign, nonatomic) long Id;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSMutableAttributedString *gobus;
@property (strong, nonatomic) TSHospitalDetail *model;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
