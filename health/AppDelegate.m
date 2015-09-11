//
//  AppDelegate.m
//  health
//
//  Created by tom.sun on 15/5/21.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "AppDelegate.h"
#import "HttpRequest.h"
#import "MainTabbarViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "Macro.h"

@interface AppDelegate ()<MAMapViewDelegate,AMapSearchDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *mapSearch;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window.backgroundColor = [UIColor whiteColor];
    _networkStatus = AFNetworkReachabilityStatusUnknown;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _networkStatus = status;
    }];
    [NSThread sleepForTimeInterval:1.5];
    MainTabbarViewController * tabBar = [[MainTabbarViewController alloc] init];
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];
    [self initMapService];
    return YES;
}

- (void)initMapService
{
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
    _mapView = [[MAMapView alloc] init];
    _mapView.delegate = self;
    _city = @"";
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestAlwaysAuthorization];
    }
    _mapView.showsUserLocation = YES;
    _mapSearch = [[AMapSearchAPI alloc]initWithSearchKey:(NSString *)APIKey Delegate:self];
}
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        regeoRequest.searchType = AMapSearchType_ReGeocode;
        regeoRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        _X = userLocation.coordinate.latitude;
        _Y = userLocation.coordinate.longitude;
        regeoRequest.requireExtension = YES;
        [_mapSearch AMapReGoecodeSearch: regeoRequest];
    }
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        if ([response.regeocode.addressComponent.city isEqualToString: @""]) {
            _city = response.regeocode.addressComponent.province;
        }
        else {
            _city = response.regeocode.addressComponent.city;
        }
    }
    else {
        _city = @"";
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
