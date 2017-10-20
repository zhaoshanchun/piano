//
//  UIBaseTableViewCell.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/16.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

#define kUIBaseTableViewCellIndentifier @"kUIBaseTableViewCellIndentifier"

@interface UIBaseTableViewCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;

@end
