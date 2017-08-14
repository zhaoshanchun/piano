//
//  SearchViewController.h
//  kuaijiazhicheng
//
//  Created by kun on 2017/6/16.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchDetailView.h"

@interface SearchViewController : UIViewController

@property (strong, nonatomic) SearchDetailView *searchDetailView;
@property (strong, nonatomic) UIActivityIndicatorView *searchLoadView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSLayoutConstraint *tableBottomConstraint;

@end
