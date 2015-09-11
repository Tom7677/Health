//
//  DrugDetailViewController.h
//  health
//
//  Created by tom.sun on 15/8/25.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface DrugDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *coverImageView;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) TSDrugDetail *drugModel;
@property (strong, nonatomic) TSCheckProjectDetail *checkModel;
@property (strong, nonatomic) TSSurgeryDetail *surgeryModel;
@property (strong, nonatomic) TSQuestionDetail *questionModel;
@property (strong, nonatomic) TSInfoDetail *infoModel;
@property (assign, nonatomic) long Id;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger tag;
@end
