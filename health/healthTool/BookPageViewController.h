//
//  BookPageViewController.h
//  health
//
//  Created by tom.sun on 15/9/2.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface BookPageViewController : BaseViewController
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *message;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
