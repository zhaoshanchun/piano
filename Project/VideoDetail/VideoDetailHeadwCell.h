//
//  VideoDetailHeadwCell.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/6.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "UIBaseTableViewCell.h"
#import "VideoDetailHeadwCellModel.h"

#define kVideoDetailHeadwCellIdentifier @"kVideoDetailHeadwCellIdentifier"

@protocol VideoDetailHeadwCellDelegate <NSObject>

- (void)commonAction;
- (void)shareAction;
- (void)downLoadAction;
- (void)praiseAction;

@end

@interface VideoDetailHeadwCell : UIBaseTableViewCell

@property (weak, nonatomic) id<VideoDetailHeadwCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) VideoDetailHeadwCellModel *cellModel;

@end
