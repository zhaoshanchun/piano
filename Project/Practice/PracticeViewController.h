//
//  PracticeViewController.h
//  apps
//
//  Created by zhaosc on 2017/10/23.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "BaseViewController.h"
#import "PracticeListCellModel.h"

@interface PracticeViewController : BaseViewController

- (id)initWithDocument:(PracticeListCellModel *)exerciseModel;
//- (id)initWithDocument:(NSString *)documentName NS_DESIGNATED_INITIALIZER;
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
//- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
