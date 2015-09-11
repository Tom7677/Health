//
//  MainHealthToolViewController.h
//  health
//
//  Created by tom.sun on 15/8/3.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface MainHealthToolViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)diseaseBtnAction:(id)sender;
- (IBAction)drugBtnAction:(id)sender;
- (IBAction)healthBookAction:(id)sender;
- (IBAction)laboratoryTestBtnAction:(id)sender;
- (IBAction)surgeryBtnAction:(id)sender;
- (IBAction)hospitalBtnAction:(id)sender;

@end
