//
//  BaseNavigationController.h
//  base
//
//  Created by kun on 2017/4/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTabBarController;

@interface BaseNavigationController : UINavigationController

@property (strong, nonatomic) MainTabBarController *tabbarController;

@end
