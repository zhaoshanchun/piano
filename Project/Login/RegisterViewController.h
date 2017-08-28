//
//  RegisterViewController.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/22.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol RegisterViewControllerDelegate <NSObject>

- (void)registerSuccess;

@end

@interface RegisterViewController : BaseTableViewController

@property (weak, nonatomic) id<RegisterViewControllerDelegate> delegate;

@end
