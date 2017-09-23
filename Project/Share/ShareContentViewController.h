//
//  ShareContentViewController.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/18.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "BaseViewController.h"

@protocol ShareContentViewControllerDelegate <NSObject>

- (void)shareWithContent:(NSString *)shareContent;

@end

@interface ShareContentViewController : BaseViewController

@property (weak, nonatomic) id<ShareContentViewControllerDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
