//
//  BaseNavigationController.m
//  base
//
//  Created by kun on 2017/4/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"
#import "MainTabBarController.h"

@interface BaseNavigationController ()

@property (nonatomic, assign, readwrite) BOOL isInteractivePopGesturing;

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // MainTabBarController *tabbarController = (MainTabBarController *)appDelegate.window.rootViewController;
    MainTabBarController *tabbarController = self.tabbarController;
    [tabbarController setTabBarHidden:viewController.hidesBottomBarWhenPushed animated:animated];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count >= 2) {
        UIViewController *popViewController = [self.viewControllers objectAtIndex:[self.viewControllers count]-2];
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
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController) {
        MainTabBarController *rootViewController = (MainTabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
        [rootViewController setTabBarHidden:viewController.hidesBottomBarWhenPushed animated:animated];
    }
    return [super popToViewController:viewController animated:animated];
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    // Enable the gesture again once the new controller is shown
    self.interactivePopGestureRecognizer.enabled = YES;
    if (self.isInteractivePopGesturing) {
        self.isInteractivePopGesturing = NO;
        // [(UIBaseViewController *)viewController hideFakeNavigationBarIfNeeded];
        // [(ORTabBarController *)[viewController rdv_tabBarController] setControlsHidden:viewController.hidesBottomBarWhenPushed animated:animated];
        [(BaseViewController *)viewController hideNavigationBarIfNeed];
        MainTabBarController *tabbarController = self.tabbarController;
        [tabbarController setTabBarHidden:viewController.hidesBottomBarWhenPushed animated:animated];
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
            if([weakSelf respondsToSelector:@selector(navigationController:didShowViewController:animated:)])
            {
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
