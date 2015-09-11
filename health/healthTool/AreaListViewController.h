//
//  AreaListViewController.h
//  health
///Users/tom.sun/Desktop/My/health/health.xcodeproj
//  Created by tom.sun on 15/9/9.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@protocol PassCityDelegate
- (void)passCityName: (NSString *)cityName cityId:(long)cityId;
@end

@interface AreaListViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id <PassCityDelegate> delegate;
@end
