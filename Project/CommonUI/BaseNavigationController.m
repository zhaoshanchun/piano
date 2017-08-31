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
@property (nonatomic, assign, readwrite) BOOL isInteractivePopGesturing;

@end

@implementation BaseNavigationController

- (instancetype)initWithTransparentBackground {
    self = [self init];
    if (self) {
        if (IS_IOS_8_OR_ABOVE) {
            [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        } else {
            [self setModalPresentationStyle:UIModalPresentationCurrentContext];
        }
        // Must set if the modlePresentationStyle is no default (UIModalPresentationFullScreen)
        self.modalPresentationCapturesStatusBarAppearance = YES;
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
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
        self.navigationBar.translucent = currentViewController.navigationBarTranslucent;
        [self updateNavigationBarTranslucent:currentViewController];
        self.isInit = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    MainTabBarController *tabbarController = self.tabbarController;
    [tabbarController setTabBarHidden:viewController.hidesBottomBarWhenPushed animated:animated];
    [super pushViewController:viewController animated:animated];
    [self updateNavigationBarTranslucent:(BaseViewController *)viewController];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count >= 2) {
        UIViewController *popViewController = [self.viewControllers objectAtIndex:[self.viewControllers count]-2];
        [self updateNavigationBarTranslucent:(BaseViewController *)popViewController];
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
        MainTabBarController *tabbarController = self.tabbarController;
        [tabbarController setTabBarHidden:rootViewController.hidesBottomBarWhenPushed animated:animated];
        [self updateNavigationBarTranslucent:(BaseViewController *)rootViewController];
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController) {
        MainTabBarController *rootViewController = (MainTabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
        [rootViewController setTabBarHidden:viewController.hidesBottomBarWhenPushed animated:animated];
        [self updateNavigationBarTranslucent:(BaseViewController *)rootViewController];
    }
    return [super popToViewController:viewController animated:animated];
}

- (void)updateNavigationBarTranslucent:(BaseViewController *)viewController {
    // Cannot updateNavigationBarTranslucent when it is interactivePopGesturing & navigationBar is transluencent
    // If not, views will be displaced
    if (self.navigationBar.translucent && !viewController.navigationBarTransparent && self.isInteractivePopGesturing) {
        return;
    }
    if (self.navigationBar.translucent != viewController.navigationBarTranslucent) {
        self.navigationBar.translucent = viewController.navigationBarTranslucent;
    }
    if (viewController.navigationBarTransparent) {
        if ([self.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] == nil)  {
            [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setShadowImage:[UIImage new]];
        }
    } else if ([self.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] && !self.isInteractivePopGesturing) {
        [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }
    
    // self.navigationController.navigationBarHidden = YES;
}

- (void)setNavigationBarTransparent {
    self.navigationBar.translucent = YES;
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}

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
        [(BaseViewController *)viewController hideNavigationBarIfNeed];
        MainTabBarController *tabbarController = self.tabbarController;
        [tabbarController setTabBarHidden:viewController.hidesBottomBarWhenPushed animated:animated];
        [self updateNavigationBarTranslucent:(BaseViewController *)viewController];
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
