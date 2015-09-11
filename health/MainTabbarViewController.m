//
//  MainTabbarViewController.m
//  health
//
//  Created by tom.sun on 15/5/29.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "MainTabbarViewController.h"
#import "KnowledgeListViewController.h"
#import "MainHealthToolViewController.h"
#import "HealthQuestionViewController.h"
#import "HealthInfoViewController.h"
#import "Macro.h"

@interface MainTabbarViewController ()

@end

@implementation MainTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = MainColor;
    KnowledgeListViewController *controller1 = [[KnowledgeListViewController alloc]init];
    UINavigationController *navigation1 = [[UINavigationController alloc]initWithRootViewController:controller1];
    UITabBarItem * item1 = [[UITabBarItem alloc] initWithTitle:@"知识" image:[UIImage imageNamed:@"btn_tabinfo_gray_normal"] tag:1];
    controller1.tabBarItem = item1;
    navigation1.navigationBar.barTintColor = MainColor;
    [navigation1.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    HealthInfoViewController *controller2 = [[HealthInfoViewController alloc]init];
    UINavigationController *navigation2 = [[UINavigationController alloc]initWithRootViewController:controller2];
    UITabBarItem * item2 = [[UITabBarItem alloc] initWithTitle:@"健康资讯" image:[UIImage imageNamed:@"btn_tabnews_gray_nomal"] tag:2];
    controller2.tabBarItem = item2;
    navigation2.navigationBar.barTintColor = MainColor;
    [navigation2.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    MainHealthToolViewController *controller3 = [[MainHealthToolViewController alloc]init];
    UINavigationController *navigation3 = [[UINavigationController alloc]initWithRootViewController:controller3];
    UITabBarItem * item3 = [[UITabBarItem alloc] initWithTitle:@"健康工具" image:[UIImage imageNamed:@"btn_tabdrug_gray_normal"] tag:3];
    controller3.tabBarItem = item3;
    navigation3.navigationBar.barTintColor = MainColor;
    [navigation3.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    HealthQuestionViewController *controller4 = [[HealthQuestionViewController alloc]init];
    UINavigationController *navigation4 = [[UINavigationController alloc]initWithRootViewController:controller4];
    UITabBarItem * item4 = [[UITabBarItem alloc] initWithTitle:@"健康问题" image:[UIImage imageNamed:@"btn_tabquestion_gray_normal"] tag:4];
    controller4.tabBarItem = item4;
    navigation4.navigationBar.barTintColor = MainColor;
    [navigation4.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    self.viewControllers = @[navigation1,navigation2,navigation3,navigation4];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
