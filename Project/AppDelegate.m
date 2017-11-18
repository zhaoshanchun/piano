//
//  AppDelegate.m
//  base
//
//  Created by kun on 2017/4/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "GlobalValue.h"
#import "DownloadManage.h"
//@import Firebase;

#import "APIManager.h"

#import "AFNetworkReachabilityManager.h"

#import <AlibcTradeBiz/AlibcTradeBiz.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>

// http://console.baichuan.taobao.com/appoverview.htm?appId=127476 (淘宝账号：1355477529x)
#define appkey @"24684986"

@interface AppDelegate ()

@property (strong, nonatomic) DownloadManage *downladManage;

@end

@import FirebaseCore;
@import GoogleMobileAds;

@implementation AppDelegate

@synthesize globalValue;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    saveObjectToUserDefaults(kLanguagekey, nil);
    
    _downladManage = [DownloadManage sharedInstance];
    [self.downladManage start];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [MainTabBarController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self setupNavBar];
    
    // Use Firebase library to configure APIs
    [FIRApp configure];
    // Initialize Google Mobile Ads SDK
    [GADMobileAds configureWithApplicationID:AdmobApplicationID];
    globalValue = [[GlobalValue alloc] init];
    [NSThread sleepForTimeInterval:4.0];
    
    saveObjectToUserDefaults(kSourceEtag, nil);
    saveObjectToUserDefaults(kSourceEtagCacheTime, nil);
    
    
    /*
    // 监控网络状态
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"移动数据网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
        }
    }];
    [manager startMonitoring];
    */
    saveObjectToUserDefaults(kMobileNetworkPlayUsable, nil);
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
    // 阿里百川
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        
    } failure:^(NSError *error) {
        NSLog(@"Init failed: %@", error.description);
    }];
    
    // 开发阶段打开日志开关，方便排查错误信息 // 默认调试模式打开日志,release关闭,可以不调用下面的函数
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];
    
    // 配置全局的淘客参数  //如果没有阿里妈妈的淘客账号,setTaokeParams函数需要调用
    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
    taokeParams.pid = @"mm_XXXXX"; //mm_XXXXX为你自己申请的阿里妈妈淘客pid，一定得填写，不然无法初始化
    [[AlibcTradeSDK sharedInstance] setTaokeParams:taokeParams];
    
    //设置全局的app标识，在电商模块里等同于isv_code
    //没有申请过isv_code的接入方,默认不需要调用该函数
    //    [[AlibcTradeSDK sharedInstance] setISVCode:@"your_isv_code"];
    
    // 设置全局配置，是否强制使用h5
    [[AlibcTradeSDK sharedInstance] setIsForceH5:YES];
    
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                             options:options]) {
        //处理其他app跳转到自己的app，如果百川处理过会返回YES
    }
    
    return YES;
}

// IOS9.0 系统新的处理openURL 的API
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation]) {
        // 处理其他app跳转到自己的app
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.downladManage stop];
}

- (void)setupNavBar {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor groupTableViewBackgroundColor];//[UIColor colorWithRed:57/255.0 green:157/255.0 blue:229/255.0 alpha:0.9];
    bar.tintColor = [UIColor blackColor];
    bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
}

//- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
//    if ([self.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
//        MainTabBarController *vc = (MainTabBarController *)self.window.rootViewController;
//        if (vc.tabBar.hidden != hidden) {
//            vc.tabBar.hidden = hidden;
//        }
//    }
//}


@end


