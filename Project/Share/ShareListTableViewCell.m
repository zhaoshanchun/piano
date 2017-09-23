//
//  ShareListTableViewCell.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/16.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ShareListTableViewCell.h"
#import "CLPlayerView.h"

@interface ShareListTableViewCell ()

@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) CLPlayerView *playerView;
@property (strong, nonatomic) UIImageView *placeHolderImageView;
@property (strong, nonatomic) UIButton *placeHolderButton;
@property (strong, nonatomic) UILabel *titleLabel;

@end


@implementation ShareListTableViewCell

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
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.playerView];
    [self.playerView addSubview:self.titleLabel];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = [UIColor orTableViewCellHighlightedColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCellModel:(ShareListTableViewCellModel *)cellModel {
    if (cellModel == nil) {
        return;
    }
    _cellModel = cellModel;
    
    self.contentLabel.frame = cellModel.contentFrame;
    self.contentLabel.attributedText = cellModel.contentAttribute;
    
    if (cellModel.detailAttribute.length > 0) {
        self.detailLabel.frame = cellModel.detailFrame;
        self.detailLabel.attributedText = cellModel.detailAttribute;
    }
    
    self.playerView.frame = cellModel.playViewFrame;
    if (cellModel.shareModel.videoUrl.length > 0) {
        // self.playerView.url = [NSURL URLWithString:cellModel.shareModel.videoUrl];
        // [self.playerView pausePlay];
    }
    
    self.titleLabel.frame = cellModel.titleFrame;
    self.titleLabel.attributedText = cellModel.titleAttribute;
    
}


#pragma mark - Factory method
- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (CLPlayerView *)playerView {
    if (_playerView == nil) {
        _playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(kShareListTableViewCellLRPadding, kShareListTableViewCellTBPadding, kShareListTableViewCellPlayViewWidth, kShareListTableViewCellPlayViewHeight)];
        //返回按钮点击事件回调
        [_playerView backButton:^(UIButton *button) {
            if (_playerView) {
                [_playerView destroyPlayer];
                _playerView = nil;
            }
        }];
        //播放完成回调
        [_playerView endPlay:^{
            
        }];
    }
    return _playerView;
}

- (UIImageView *)placeHolderImageView {
    if (_placeHolderImageView == nil) {
        _placeHolderImageView = [[UIImageView alloc] init];
    }
    return _placeHolderImageView;
}

- (UIButton *)placeHolderButton {
    if (_placeHolderButton == nil) {
        UIImage *image = [UIImage imageNamed:@"play"];
        _placeHolderButton = [[UIButton alloc] init];
    }
    return _placeHolderButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}


@end


