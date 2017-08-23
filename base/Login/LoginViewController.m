//
//  LoginViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/22.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:localizeString(@"profile_login")];
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, [self pageWidth] - 20*2, 40)];
    textField.layer.borderColor = [UIColor orLineColor].CGColor;
    textField.layer.borderWidth = 0.5f;
    textField.placeholder = @"请输入邮箱";
    [self.view addSubview:textField];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 200, 50)];
    button.layer.borderWidth = 0.5f;
    button.layer.borderColor = [UIColor redColor].CGColor;
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
    // [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
