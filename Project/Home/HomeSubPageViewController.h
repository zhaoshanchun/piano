//
//  HomeSubPageViewController.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/29.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "BaseViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "ContentListModel.h"

@interface HomeSubPageViewController : BaseViewController <ZJScrollPageViewChildVcDelegate>

@property (strong, nonatomic) ClassifyModel *classModel;

@end
