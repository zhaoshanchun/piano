//
//  BaseNavigationController.m
//  base
//
//  Created by kun on 2017/4/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "BaseNavigationController.h"
#import "MainTabBarController.h"

@interface BaseNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isInit;

// 使用： 在屏幕左边右滑返回上一级页面
@property (nonatomic, assign, readwrite) BOOL isInteractivePopGesturing;

@end

@implementation BaseNavigationController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    /*
    // Present 的方式，暂时不用管
    if (IS_IOS_8_OR_ABOVE) {
        [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    } else {
        [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
    */
    
    
    // navigationBar.translucent 全部设置为NO
    self.navigationBar.translucent = NO;
    
    // 设置NavigationBar颜色，主题颜色
    [self updateColorForNavBar:[UIColor orThemeColor] withAlpha:1.0];
    
    // ViewController.view 那里设置每个页面默认背景色。所以这里设为 clearColor
    self.view.backgroundColor = [UIColor clearColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isInit = YES;
    
    __weak BaseNavigationController *weakSelf = self;
    self.interactivePopGestureRecognizer.delegate = weakSelf;
    self.delegate = weakSelf;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isInit) {
        BaseViewController *currentViewController = [self.viewControllers lastObject];
        [self updateNavigationBar:currentViewController];
        self.isInit = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateColorForNavBar:(UIColor *)color withAlpha:(CGFloat)alpha {
    /*
     alpha 两大作用：
     1. ios7 之前，是否需要显示navigation bar
     2. 对 navigation bar shadowImage 的显示与否。默认有shadowImage
     */
    
    // iOS 7
    if ([UINavigationBar instancesRespondToSelector:@selector(setBarTintColor:)]) {
        [self.navigationBar setBarTintColor:color];
        [self.navigationBar setBackgroundColor:color];
    } else {
        self.navigationBarHidden = (alpha != 1);
    }
    if (alpha == 1) {
        self.navigationBar.shadowImage = nil;
    } else {
        self.navigationBar.shadowImage = [UIImage new];
    }
}


#pragma mark - Overwrite UINavigationController method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.interactivePopGestureRecognizer.enabled = NO;
    if (self.isInteractivePopGesturing) {
        self.isInteractivePopGesturing = NO;
    }
    
    UIViewController *currentViewController = [self.viewControllers lastObject];
    if (animated && [currentViewController isKindOfClass:[BaseViewController class]]) {
        if ([(BaseViewController*)currentViewController animating]) {
            return;
        } else {
            ((BaseViewController*)currentViewController).animating = YES;
        }
    }
    
    // 设置 bottomBar (Show/hide) for new pushed viewController
    MainTabBarController *tabbarController = self.tabbarController;
    [tabbarController setTabBarHidden:viewController.hidesBottomBarWhenPushed animated:animated];
    
    // 执行本该执行的push
    [super pushViewController:viewController animated:animated];
    
    // 设置 navigationBar (Show/hide) for new pushed viewController
    [self updateNavigationBar:(BaseViewController *)viewController];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count >= 2) {
        // 设置 navigationBar (Show/hide) for going to shows viewController (eg:[A, B], pop B, then going to shows A.).
        UIViewController *popViewController = [self.viewControllers objectAtIndex:[self.viewControllers count]-2];
        [self updateNavigationBar:(BaseViewController *)popViewController];
        
        // 设置 bottomBar (Show/hide) for going to shows viewController
        if (!self.isInteractivePopGesturing) {
            MainTabBarController *tabbarController = self.tabbarController;
            [tabbarController setTabBarHidden:popViewController.hidesBottomBarWhenPushed animated:animated];
        }
    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    UIViewController *rootViewController = [self.viewControllers firstObject];
    if (rootViewController) {
        // 设置 bottomBar (Show/hide) for rootViewController
        MainTabBarController *tabbarController = self.tabbarController;
        [tabbarController setTabBarHidden:rootViewController.hidesBottomBarWhenPushed animated:animated];
        
        // 设置 navigationBar (Show/hide) for rootViewController
        [self updateNavigationBar:(BaseViewController *)rootViewController];
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController) {
        // 设置 navigationBar (Show/hide) for going to shows viewController (eg:[A, B, C], pop to A, then going to shows A.).
        MainTabBarController *rootViewController = (MainTabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
        [rootViewController setTabBarHidden:viewController.hidesBottomBarWhenPushed animated:animated];
        
        // 设置 bottomBar (Show/hide) for going to shows viewController
        [self updateNavigationBar:(BaseViewController *)rootViewController];
    }
    return [super popToViewController:viewController animated:animated];
}

- (void)updateNavigationBar:(BaseViewController *)viewController {
    if (self.isInteractivePopGesturing) {
        // 如果在【在屏幕左边右滑返回上一级页面】动作中，则不去更新
        return;
    }
    
    /*
    // 把Navigaton bar 设置为空白的代码
    if ([self.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] == nil)  {
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[UIImage new]];
    }
    */
    if ([self.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault]) {
        [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationBarHidden = viewController.hideNavigationBar;
    self.navigationBar.barTintColor = [UIColor orThemeColor];
}

/*
 // 把Navigaton bar 设置为空白的代码
- (void)setNavigationBarTransparent {
    self.navigationBar.translucent = YES;
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}
 */

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.statusBarStyleLightContent) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    // Enable the gesture again once the new controller is shown
    self.interactivePopGestureRecognizer.enabled = YES;
    if (self.isInteractivePopGesturing) {
        self.isInteractivePopGesturing = NO;
        MainTabBarController *tabbarController = self.tabbarController;
        [tabbarController setTabBarHidden:viewController.hidesBottomBarWhenPushed animated:animated];
        [self updateNavigationBar:(BaseViewController *)viewController];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    __weak BaseNavigationController *weakSelf = self;
    [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // It happens when it's interactivePopGesturing but it swipes less than 50% of screen width, and release to go back to original page
        if ([context isCancelled]) {
            UIViewController *fromViewController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
            [weakSelf navigationController:navigationController willShowViewController:fromViewController animated:animated];
            if([weakSelf respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
                NSTimeInterval animationCompletion = [context transitionDuration] * [context percentComplete];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (uint64_t)animationCompletion * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [weakSelf navigationController:navigationController didShowViewController:fromViewController animated:animated];
                });
            }
        }
    }];
}


// 【在屏幕左边右滑返回上一级页面】
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count > 1) {
        if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            BaseViewController *currentViewController = [self.viewControllers lastObject];
            if ([currentViewController interactivePopGestureShouldBegin]) {
                self.isInteractivePopGesturing = YES;
            } else {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}


@end
