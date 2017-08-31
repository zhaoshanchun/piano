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

@property (strong, nonatomic) MainTabBarController *tabbarController;

@property (nonatomic, assign) BOOL statusBarStyleLightContent;
@property (nonatomic, assign, readonly) BOOL isInteractivePopGesturing;
@property (nonatomic, assign, readonly) BOOL isNavigationBarTransparent;


// Set with transparent background
- (instancetype)initWithTransparentBackground;
// Instantly set navigation bar transparent
- (void)setNavigationBarTransparent;
- (void)updateNavigationBarTranslucent:(BaseViewController *)viewController;

@end

