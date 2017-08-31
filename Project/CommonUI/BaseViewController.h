//
//  BaseViewController.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/15.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+AppBar.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"

@interface BaseViewController : UIViewController

// 所有viewController.navigationBar的显示与否，通过navigationBarTranslucent来控制
@property (nonatomic, assign) BOOL navigationBarTranslucent;  //default is NO
@property (nonatomic, assign) BOOL navigationBarTransparent;  //default is NO


@property (strong, nonatomic) NSURLSessionDataTask *apiTask;
@property (nonatomic, assign) BOOL animating;

// Should begin interactivePopGesture or not, implement it optionally, default return YES
- (BOOL)interactivePopGestureShouldBegin;
- (void)hideNavigationBarIfNeed;


- (CGFloat)pageWidth;
- (CGFloat)pageHeight;

@end
