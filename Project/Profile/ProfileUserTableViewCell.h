//
//  ProfileUserTableViewCell.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/26.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "UIBaseTableViewCell.h"
#import "ProfileUserTableViewCellModel.h"

#define kProfileUserTableViewCellIdentifier @"kProfileUserTableViewCellIdentifier"

@protocol ProfileUserTableViewCellDelegate <NSObject>

- (void)tapedAvatar;

@end

@interface ProfileUserTableViewCell : UIBaseTableViewCell

@property (weak, nonatomic) id<ProfileUserTableViewCellDelegate> delegate;
@property (strong, nonatomic) ProfileUserTableViewCellModel *cellModel;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end
