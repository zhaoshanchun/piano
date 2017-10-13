//
//  PublicShareTableViewCell.h
//  CLPlayerDemo
//
//  Created by JmoVxia on 2017/8/4.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "UIBaseTableViewCell.h"
#import "PublicShareCellModel.h"
#import "CLPlayerView.h"

@class PublicShareTableViewCell;

@protocol PublicShareTableViewCellDelegate <NSObject>

- (void)shouldPlayVideoForCell:(PublicShareTableViewCell *)cell;

@end

@interface PublicShareTableViewCell : UIBaseTableViewCell

@property (nonatomic, weak) id <PublicShareTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) PublicShareCellModel *cellModel;

- (CGFloat)cellOffset;
- (void)addPlayView:(CLPlayerView *)playView;
- (void)startedPlay;
- (void)stopedPlay;

@end
