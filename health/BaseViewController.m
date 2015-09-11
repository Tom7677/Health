//
//  BaseViewController.m
//  health
//
//  Created by tom.sun on 15/5/29.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"
#import "TSLoadingView.h"

@interface BaseViewController ()
@property (strong, nonatomic) UIView *emptyView;
@property (strong, nonatomic) TSLoadingView *loadAnimationView;
@property (strong, nonatomic) UIImageView *imgView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loadAnimationView = [[TSLoadingView alloc]init];
    [_loadAnimationView setGifWithImageName:@"bird.gif"];
    [self.view addSubview:_loadAnimationView];
    if (![self.title isEqualToString:@""]) {
        [self setBackItemTitle:@""];
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackItemTitle:(NSString *)title
{
    //当前Controller设定的BackBarButtonItem只影响下一个Controller的左侧返回键Title
    if (self.navigationController.viewControllers.count > 1)
    {
        UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:@selector(pop:)];
        [viewController.navigationItem setBackBarButtonItem:backButton];
    }
}

- (void)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startProgress
{
    [_loadAnimationView show];
    [self.view bringSubviewToFront:_loadAnimationView];
}

- (void)stopProgress
{
    [self performSelector:@selector(dismissAnimationView) withObject:nil afterDelay:0.5f];
}

- (void)dismissAnimationView
{
    [_loadAnimationView dismiss];
}

- (void)showEmptyView:(NSString *)error
{
    if (_emptyView == nil) {
        _emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.mainScreenWidth, self.mainScreenHeight)];
        _emptyView.backgroundColor = [UIColor whiteColor];
        if ([error isEqualToString:nonetwork]) {
             _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nonetwork_39x39"]];
        }
        else {
             _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_warn_nodata_39x39"]];
        }
       
        //102为25+28+28+21，为提示信息和行间距之和
        _imgView.originY = (self.mainScreenHeight - self.view.statusBarAndnavgationBarHeight - self.view.tabBarHeight -  (_imgView.height + 102/2))/2;
        _imgView.originX = (self.mainScreenWidth - _imgView.width)/2;
        [_emptyView addSubview:_imgView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, _imgView.originY + _imgView.height + 18, self.mainScreenWidth, 16)];
        label.textColor = UIColorFromRGB(0xcccccc);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [_emptyView addSubview:label];
        if ([error isEqualToString:nonetwork]) {
            label.text = @"数据加载失败，请检查网络是否可用";
        }
        else {
            label.text = @"数据加载失败，请稍后重试";
        }
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.mainScreenWidth, 20)];
        btn.originY = label.height + label.originY + 8;
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xB34C46) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
        btn.width = self.mainScreenWidth;
        [_emptyView addSubview:btn];
        _emptyView.hidden = YES;
        [_emptyView setUserInteractionEnabled:YES];
    }
    [self.view addSubview:_emptyView];
    _emptyView.hidden = NO;
}

- (void)reloadData
{
    [self startProgress];
    _emptyView.hidden = YES;
    [_emptyView removeFromSuperview];
    [self refreshData];
}

- (void)refreshData
{
    
}

// 当前设备屏幕宽(point)
- (CGFloat)mainScreenWidth
{
    return MainScreenWidth;
}

// 当前设备屏幕高(point)
- (CGFloat)mainScreenHeight
{
    return MainScreenHeight;
}

- (CGFloat)iphone5Width
{
    return Iphone5Width;
}

- (CGFloat)iphone5Height
{
    return  Iphone5Height;
}

- (CGFloat)iphone6Width
{
    return  Iphone6Width;
}

- (CGFloat)iphone6Height
{
    return  Iphone6Height;
}

- (CGFloat)iphone6plusWidth
{
    return  Iphone6PlusWidth;
}

- (CGFloat)iphone6plusHeight
{
    return  Iphone6PlusHeight;
}

- (CGFloat)statusBarHeight
{
    return StatusBarHeight;
}

- (CGFloat)navgationBarHeight
{
    return NavgationBarHeight;
}

- (CGFloat)statusBarAndnavgationBarHeight
{
    return self.navgationBarHeight + self.statusBarHeight;
}

- (CGFloat)tabBarHeight
{
    return TabBarHeight;
}
@end
