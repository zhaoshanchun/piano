//
//  ShareListTableViewCell.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/16.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "UIBaseTableViewCell.h"
#import "ShareListTableViewCellModel.h"


#define kShareListTableViewCellIndentifier @"kShareListTableViewCellIndentifier"

@class ShareListTableViewCell;
@protocol ShareListTableViewCellDelegate <NSObject>

- (void)playVideoForCell:(ShareListTableViewCell *)cell;

@end

@interface ShareListTableViewCell : UIBaseTableViewCell

@property (weak, nonatomic) id<ShareListTableViewCellDelegate> delegate;
@property (strong, nonatomic) ShareListTableViewCellModel *cellModel;
@property (strong, nonatomic) NSIndexPath *indexPath;

// - (void)stopPlay;

@end
