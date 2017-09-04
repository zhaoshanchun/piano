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

/*
 所有页面
 viewController.navigationBar 的显示与否, default is NO
 navigationController.navigationBar.translucent, All is NO。
 BottomBar 的用 hidesBottomBarWhenPushed, default is NO
 */
@property (nonatomic, assign) BOOL hideNavigationBar;

/*
 防止重叠present
 避免问题：比如有时点按钮进子页面，还没开始present时，第二次按了按钮，这时就会重叠present。
 */
@property (nonatomic, assign) BOOL animating;

/*
 为AFNetworking做网络控制用的。比如dealloc时，把未完成的 apiTask=nil
 */
@property (strong, nonatomic) NSURLSessionDataTask *apiTask;

// 在屏幕左边缘往右滑返回上一页面用到
// Should begin interactivePopGesture or not, implement it optionally, default return YES
- (BOOL)interactivePopGestureShouldBegin;

- (CGFloat)pageWidth;
- (CGFloat)pageHeight;


#pragma mark - Empty page and Action
- (void)showEmptyTitle:(NSString *)emptyTitle;
- (void)hideEmptyParam;
- (void)emptyAction;

@end


