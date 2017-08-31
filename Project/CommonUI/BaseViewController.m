//
//  BaseViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/15.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.hidesBottomBarWhenPushed = YES;    // 默认当前页面不需要 Bottom Bar
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateColorForNavBar:[UIColor orThemeColor] withAlpha:1.0];
    self.view.backgroundColor = [UIColor colorForKey:@"lgy"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.animating = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.animating = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)interactivePopGestureShouldBegin {
    return YES;
}


- (void)hideNavigationBarIfNeed {
    // TODO...
}


- (CGFloat)pageWidth {
    return SCREEN_WIDTH;
}

- (CGFloat)pageHeight {
    // translunt,hidenavigationBar,tabbar等情况
    CGFloat pageHeight = SCREEN_HEIGHT;
    
    if (!self.hidesBottomBarWhenPushed) {
        pageHeight -= TAB_BAR_HEIGHT;
    }
    
    if (!self.navigationController.isNavigationBarHidden || !self.navigationBarTranslucent || self.navigationController.navigationBar.translucent) {
        pageHeight -= (STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT);
    }
    
    return pageHeight;
}

@end
