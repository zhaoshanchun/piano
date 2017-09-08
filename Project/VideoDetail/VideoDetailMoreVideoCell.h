//
//  VideoDetailMoreVideoCell.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/8.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "UIBaseTableViewCell.h"
#import "VideoDetailMoreVideoCellModel.h"

#define kVideoDetailMoreVideoCellIdentifier @"kVideoDetailMoreVideoCellIdentifier"

@interface VideoDetailMoreVideoCell : UIBaseTableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) VideoDetailMoreVideoCellModel *cellModel;

@end
