//
//  BaseTableViewController.h
//  base
//
//  Created by kun on 2017/4/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "BaseViewController.h"
#import "UIBaseTableViewCell.h"

@interface BaseTableViewController : BaseViewController

@property (assign, nonatomic) UITableViewStyle tableStyle;

@property (strong, nonatomic) UITableView *tableView;

@end
