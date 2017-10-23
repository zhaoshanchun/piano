//
//  VideoDetailCommentCell.m
//  apps
//
//  Created by zhaosc on 2017/10/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "VideoDetailCommentCell.h"

@interface VideoDetailCommentCell ()

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *commentLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIView *bottomView;

@end

@implementation VideoDetailCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView = nil;
        self.backgroundColor = [UIColor whiteColor];
        [self addContent];
    }
    return self;
}

- (void)addContent {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.commentLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.bottomView];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        // self.backgroundColor = [UIColor orTableViewCellHighlightedColor];
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCellModel:(VideoDetailCommentCellModel *)cellModel {
    if (cellModel == nil) {
        return;
    }
    _cellModel = cellModel;
    
    self.avatarImageView.frame = cellModel.imageFrame;
    self.avatarImageView.clipsToBounds = YES;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.imageUrl]
                          placeholderImage:[UIImage imageNamed:@"avatar"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                 }];
    
    self.userNameLabel.frame = cellModel.userNameFrame;
    self.userNameLabel.attributedText = cellModel.userNameAttribute;
    
    self.commentLabel.frame = cellModel.commentFrame;
    self.commentLabel.attributedText = cellModel.commentAttribute;
    
    self.timeLabel.frame = cellModel.timeFrame;
    self.timeLabel.attributedText = cellModel.timeAttribute;
    
    if (!cellModel.isLastOne) {
        self.bottomView.hidden = NO;
        self.bottomView.frame = CGRectMake(kVideoDetailCommentCellTBPadding, cellModel.cellHeight - 0.5f, kVideoDetailCommentCellWidth - kVideoDetailCommentCellLRPadding*2, 0.5);
    } else {
        self.bottomView.hidden = YES;
    }
}


#pragma mark - Factory method
- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatarImageView.backgroundColor = [UIColor colorForKey:@"lgy"];
        _avatarImageView.layer.cornerRadius = kVideoDetailCommentCellImageWidth/2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.image = [UIImage imageNamed:@"avatar"];
    }
    return _avatarImageView;
}

- (UILabel *)userNameLabel {
    if (_userNameLabel == nil) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userNameLabel.numberOfLines = 0;
    }
    return _userNameLabel;
}

- (UILabel *)commentLabel {
    if (_commentLabel == nil) {
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLabel.numberOfLines = 0;
    }
    return _commentLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.numberOfLines = 0;
    }
    return _timeLabel;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor orLineColor];
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

@end
