//
//  PublicShareTableViewCell.m
//  CLPlayerDemo
//
//  Created by JmoVxia on 2017/8/4.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "PublicShareTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+CLSetRect.h"


@interface PublicShareTableViewCell ()

@property (strong, nonatomic) UIView *topGapLine;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *useNameLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *placeHolderImageView;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UILabel *timeLabel;

@end


@implementation PublicShareTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryView = nil;
        self.clipsToBounds = YES;
        [self addContent];
    }
    return self;
}

- (void)addContent {
    [self.contentView addSubview:self.topGapLine];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.useNameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.placeHolderImageView];
    [self.contentView addSubview:self.playButton];
    [self.contentView addSubview:self.timeLabel];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.topGapLine.hidden = (self.indexPath.row == 0);
}

- (void)setCellModel:(PublicShareCellModel *)cellModel {
    if (!cellModel) {
        return;
    }
    _cellModel = cellModel;
    
    
    self.avatarImageView.frame = cellModel.avatarImageFrame;
    if (cellModel.iconUrl.length > 0) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.iconUrl]
                                placeholderImage:[UIImage imageNamed:@"avatar"]
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           if (error) {
                                               [self.avatarImageView setImage:[UIImage imageNamed:@"avatar"]];
                                           }
                                       }];
    } else {
        self.avatarImageView.image = [UIImage imageNamed:@"avatar"];
    }
    
    
    self.useNameLabel.frame = cellModel.userNameTitleFrame;
    self.useNameLabel.attributedText = cellModel.userNameAttribute;
    
    self.contentLabel.frame = cellModel.contentFrame;
    self.contentLabel.attributedText = cellModel.contentAttribute;
    
    self.titleLabel.frame = cellModel.titleFrame;
    self.titleLabel.attributedText = cellModel.titleAttribute;
    
    
    [self stopedPlay];
    self.placeHolderImageView.frame = cellModel.playViewFrame;
    self.playButton.center = self.placeHolderImageView.center;
    __block UIImage *placeholderImage = [UIImage imageNamed:@"Placeholder"];
    [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:self.cellModel.shareModel.preview] completion:^(BOOL isInCache) {
        if (isInCache) {
            // 本地存在图片, 替换占位图片
            placeholderImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cellModel.shareModel.preview];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.placeHolderImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.shareModel.preview] placeholderImage:placeholderImage];
        });
    }];
    
    self.timeLabel.frame = cellModel.timeFrame;
    self.timeLabel.attributedText = cellModel.timeAttribute;
}

- (void)addPlayView:(CLPlayerView *)playView {
    [self.contentView addSubview:playView];
    playView.url = [NSURL URLWithString:self.cellModel.shareModel.video_url];
    [playView playVideo];
    [self startedPlay];
}

- (void)playAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(shouldPlayVideoForCell:)]){
        [_delegate shouldPlayVideoForCell:self];
    }
}

- (void)startedPlay {
    self.placeHolderImageView.hidden = YES;
    self.playButton.hidden = YES;
}

- (void)stopedPlay {
    self.placeHolderImageView.hidden = NO;
    self.playButton.hidden = NO;
}


#pragma mark - Factory method
- (UIView *)topGapLine {
    if (_topGapLine == nil) {
        _topGapLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kShareListTableViewCellWidth, 0.5f)];
        _topGapLine.backgroundColor = [UIColor orLineColor];
    }
    return _topGapLine;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kPublicShareCellAvatarSize, kPublicShareCellAvatarSize)];
        _avatarImageView.layer.cornerRadius = kPublicShareCellAvatarSize/2;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)useNameLabel {
    if (_useNameLabel == nil) {
        _useNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _useNameLabel.numberOfLines = 0;
    }
    return _useNameLabel;
}

- (UIButton *)playButton {
    if (_playButton == nil) {
        UIImage *playImage = [UIImage imageNamed:@"play"];
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, playImage.size.width, playImage.size.height)];
        [_playButton setImage:playImage forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIImageView *)placeHolderImageView {
    if (_placeHolderImageView == nil) {
        _placeHolderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, - (PublicShareCellImageHeight - PublicShareCellHeight) * 0.5, CLscreenWidth, PublicShareCellImageHeight)];
        _placeHolderImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _placeHolderImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.numberOfLines = 0;
    }
    return _timeLabel;
}


@end
