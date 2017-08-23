//
//  LoginViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/22.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) UIView *contentView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:localizeString(@"profile_login")];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Factory method
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, [self pageWidth] - 15*2, 0)];
        [_contentView showBorder:[UIColor orLineColor]];
    }
    return _contentView;
}


@end




