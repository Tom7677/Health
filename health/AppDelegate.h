//
//  AppDelegate.h
//  health
//
//  Created by tom.sun on 15/5/21.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworkReachabilityManager.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) AFNetworkReachabilityStatus networkStatus;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) CGFloat X;
@property (nonatomic, assign) CGFloat Y;
@end

