//
//  ProfileUserTableViewCell.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/26.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ProfileUserTableViewCell.h"


@interface ProfileUserTableViewCell ()

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *mainTitleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIImageView *rightImageView;

@end

@implementation ProfileUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addContent];
    }
    return self;
}

- (void)addContent {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.mainTitleLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.rightImageView];
}

- (void)setCellModel:(ProfileUserTableViewCellModel *)cellModel {
    if (cellModel == nil) {
        return;
    }
    _cellModel = cellModel;
    
    self.avatarImageView.hidden = YES;
    
    if (cellModel.userModel) {
        // Logined
        self.avatarImageView.hidden = NO;
        self.avatarImageView.frame = cellModel.avatarImageFrame;
        self.avatarImageView.image = [UIImage imageNamed:@"AppIcon"];
    
        if (cellModel.detailAttribute.length > 0) {
            self.detailLabel.frame = cellModel.detailFrame;
            self.detailLabel.attributedText = cellModel.detailAttribute;
        }
    }
    
    self.mainTitleLabel.frame = cellModel.mainTitleFrame;
    self.mainTitleLabel.attributedText = cellModel.mainAttribute;
    
    self.rightImageView.frame = cellModel.rightImageFrame;
}

#pragma mark - Factory method
- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatarImageView.backgroundColor = [UIColor colorForKey:@"lgr"];
        _avatarImageView.layer.cornerRadius = kProfileUserTableViewCellAvatarSize/2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.hidden = YES;
    }
    return _avatarImageView;
}

- (UILabel *)mainTitleLabel {
    if (_mainTitleLabel == nil) {
        _mainTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _mainTitleLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _detailLabel;
}

- (UIImageView *)rightImageView {
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
    }
    return _rightImageView;
}

@end
