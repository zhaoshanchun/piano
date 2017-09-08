//
//  VideoDetailViewController.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/30.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "BaseViewController.h"
#import "ContentListModel.h"

@interface VideoDetailViewController : BaseViewController

- (instancetype)initWithUUID:(NSString *)uuid NS_DESIGNATED_INITIALIZER; // 只能通过这个方法进这个页面
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@property (strong, nonatomic) NSArray *allContentsArray;

@end
