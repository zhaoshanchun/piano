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

@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIImageView *placeHolderImageView;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UILabel *titleLabel;

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
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.placeHolderImageView];
    [self.contentView addSubview:self.playButton];
    [self.contentView addSubview:self.titleLabel];
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

- (void)setCellModel:(PublicShareCellModel *)cellModel {
    if (!cellModel) {
        return;
    }
    _cellModel = cellModel;
    
    if (cellModel.contentAttribute.length > 0) {
        self.contentLabel.hidden = NO;
        self.contentLabel.frame = cellModel.contentFrame;
        self.contentLabel.attributedText = cellModel.contentAttribute;
    }
    
    if (cellModel.detailAttribute.length > 0) {
        self.detailLabel.hidden = NO;
        self.detailLabel.frame = cellModel.detailFrame;
        self.detailLabel.attributedText = cellModel.detailAttribute;
    }
    
    [self stopedPlay];
    self.placeHolderImageView.frame = cellModel.playViewFrame;
    self.playButton.center = self.placeHolderImageView.center;
    __block UIImage *placeholderImage = [UIImage imageNamed:@"Placeholder"];
    [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:self.cellModel.iconUrl] completion:^(BOOL isInCache) {
        if (isInCache) {
            // 本地存在图片, 替换占位图片
            placeholderImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cellModel.iconUrl];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.placeHolderImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.iconUrl] placeholderImage:placeholderImage];
        });
    }];
    
    if (cellModel.titleAttribute.length > 0) {
        self.titleLabel.hidden = NO;
        self.titleLabel.frame = cellModel.titleFrame;
        self.titleLabel.attributedText = cellModel.titleAttribute;
    }
    
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
- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.numberOfLines = 0;
        _contentLabel.hidden = YES;
    }
    return _contentLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.numberOfLines = 0;
        _detailLabel.hidden = YES;
    }
    return _detailLabel;
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
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

@end
