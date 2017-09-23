//
//  LoginViewController.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/22.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "BaseTableViewController.h"
#import "RegisterViewController.h"

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginSuccess;

@end

@interface LoginViewController : BaseTableViewController

@property (weak, nonatomic) id<LoginViewControllerDelegate> delegate;

@end
