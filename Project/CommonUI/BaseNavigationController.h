//
//  BaseNavigationController.h
//  base
//
//  Created by kun on 2017/4/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class MainTabBarController;

@interface BaseNavigationController : UINavigationController

// Status Bar 的状态：白/黑
@property (nonatomic, assign) BOOL statusBarStyleLightContent;

// 是否正在执行动作【在屏幕左边右滑返回上一级页面】
@property (nonatomic, assign, readonly) BOOL isInteractivePopGesturing;

// 最外层的 Tabbar
@property (strong, nonatomic) MainTabBarController *tabbarController;


// 设置 Navigation Bar (show/hide)
- (void)updateNavigationBar:(BaseViewController *)viewController;

@end

