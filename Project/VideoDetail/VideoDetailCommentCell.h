//
//  VideoDetailCommentCell.h
//  apps
//
//  Created by zhaosc on 2017/10/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "UIBaseTableViewCell.h"
#import "VideoDetailCommentCellModel.h"

#define kVideoDetailCommentCellIdentifier @"kVideoDetailCommentCellIdentifier"

@interface VideoDetailCommentCell : UIBaseTableViewCell

@property (strong, nonatomic) VideoDetailCommentCellModel *cellModel;

@end
