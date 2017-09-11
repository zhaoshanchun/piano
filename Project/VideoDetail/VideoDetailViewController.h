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

- (instancetype)initWithUUID:(NSString *)uuid NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithContentModel:(ContentModel *)contentModel NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@property (strong, nonatomic) NSArray *allContentsArray;

@end
