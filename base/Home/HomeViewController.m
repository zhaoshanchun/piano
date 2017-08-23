//
//  HomeViewController.m
//  gzwuli
//
//  Created by kun on 2017/5/8.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "HomeViewController.h"
@import GoogleMobileAds;

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startAdmob];

    // Do any additional setup after loading the view.
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"word.doc" ofType:nil];
    NSLog(@"-------->word pat: %@", path);
    NSURL *url = [NSURL fileURLWithPath:path];
    UIWebView *webView = [UIWebView new];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:rectStatus.size.height + rectNav.size.height]];
    
    CGRect tabFrame = self.tabBarController.tabBar.frame;
    _bottomConstraint = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-tabFrame.size.height];
    [self.view addConstraint:_bottomConstraint];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startAdmob {
    // Replace this ad unit ID with your own ad unit ID.
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID = AdUnitID;
    self.bannerView.rootViewController = self;
    [self.view addSubview:self.bannerView];
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    CGRect tabFrame = self.tabBarController.tabBar.frame;
    
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-tabFrame.size.height];
    constraint.active = YES;
    self.bannerView.alpha = 0;
    self.bannerView.hidden = YES;

    GADRequest *request = [GADRequest request];
    request.testDevices = @[TestDevice];
    [self.bannerView loadRequest:request];
    
    NSLog(@"----->%s", __func__);
}


- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"----->adView:didFailToReceiveAdWithError: %@", error.localizedDescription);
}

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"----->adViewWillPresentScreen");
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"----->adViewWillDismissScreen");
}

/// Tells the delegate that the full screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"----->adViewDidDismissScreen");
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    bannerView.hidden = NO;
    bannerView.alpha = 0;
    CGRect tabFrame = self.tabBarController.tabBar.frame;
    
    [self.view bringSubviewToFront:self.bannerView];
    [UIView animateWithDuration:1.0 animations:^{
        _bottomConstraint.constant = -tabFrame.size.height-50;
        [self.view setNeedsLayout]; //更新视图
        [self.view layoutIfNeeded];
        bannerView.alpha = 1;
    }];
    
    NSLog(@"----->%s", __func__);
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"----->adViewWillLeaveApplication");
    
    [UIView animateWithDuration:1.0 animations:^{
        CGRect tabFrame = self.tabBarController.tabBar.frame;
        _bottomConstraint.constant = -tabFrame.size.height;
        [self.view setNeedsLayout]; //更新视图
        [self.view layoutIfNeeded];
        self.bannerView.hidden = YES;
        
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:90
                                              target:self
                                            selector:@selector(showAds)
                                            userInfo:nil
                                             repeats:NO];
}

- (void)showAds {
    if([self getCurrentVC] != self) {
        NSLog(@"---UIViewController is not on the top");
        _timer = [NSTimer scheduledTimerWithTimeInterval:90
                                                  target:self
                                                selector:@selector(showAds)
                                                userInfo:nil
                                                 repeats:NO];
        return;
    }
    
    self.bannerView.hidden = NO;
    self.bannerView.alpha = 0;
    [self.view bringSubviewToFront:self.bannerView];
    [UIView animateWithDuration:1.0 animations:^{
        CGRect tabFrame = self.tabBarController.tabBar.frame;
        _bottomConstraint.constant = -tabFrame.size.height - 50;
        [self.view setNeedsLayout]; //更新视图
        [self.view layoutIfNeeded];
        self.bannerView.alpha = 1;
    }];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
