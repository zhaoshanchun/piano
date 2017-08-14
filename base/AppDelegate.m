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
//@import Firebase;

@interface AppDelegate ()

@end

@import FirebaseCore;
@import GoogleMobileAds;

@implementation AppDelegate

@synthesize globalValue;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
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
}

- (void)setupNavBar {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor groupTableViewBackgroundColor];//[UIColor colorWithRed:57/255.0 green:157/255.0 blue:229/255.0 alpha:0.9];
    bar.tintColor = [UIColor blackColor];
    bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
}
@end