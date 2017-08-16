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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)pageWidth {
    return SCREEN_WIDTH;
}

- (CGFloat)pageHeight {
    return SCREEN_HEIGHT - (STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT);
}

@end
