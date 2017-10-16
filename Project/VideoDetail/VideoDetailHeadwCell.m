//
//  VideoDetailHeadwCell.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/6.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "VideoDetailHeadwCell.h"



@interface VideoDetailHeadwCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
//@property (strong, nonatomic) UIButton *commonButton;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *downLoadButton;
@property (strong, nonatomic) UIButton *praiseButton;
@property (strong, nonatomic) UIButton *favoriteButton;

@property (strong, nonatomic) UIView *bottomLine;

@end

@implementation VideoDetailHeadwCell

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


- (void)addContent {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    
    // 评论的先不做
//    [self.contentView addSubview:self.commonButton];
    [self.contentView addSubview:self.shareButton];
    [self.contentView addSubview:self.downLoadButton];
    [self.contentView addSubview:self.praiseButton];
    [self.contentView addSubview:self.favoriteButton];
    [self.contentView addSubview:self.bottomLine];
}

- (void)setCellModel:(VideoDetailHeadCellModel *)cellModel {
    if (cellModel == nil) {
        return;
    }
    _cellModel = cellModel;
    
    self.titleLabel.frame = cellModel.titleFrame;
    self.titleLabel.attributedText = cellModel.titleAttribute;
    
    self.detailLabel.frame = cellModel.detailFrame;
    self.detailLabel.attributedText = cellModel.detailAttribute;

    // 收藏
    self.favoriteButton.frame = CGRectMake(kVideoDetailHeadwCellWidth - kVideoDetailHeadwCellLRPadding - kVideoDetailHeadwCellIconWidth, cellModel.cellHeight - kVideoDetailHeadwCellTBPadding - kVideoDetailHeadwCellIconHeight, kVideoDetailHeadwCellIconWidth, kVideoDetailHeadwCellIconHeight);
    // 点赞
    self.praiseButton.frame = CGRectMake(CGRectGetMinX(self.favoriteButton.frame) - kVideoDetailHeadwCellIconMargin - kVideoDetailHeadwCellIconWidth, cellModel.cellHeight - kVideoDetailHeadwCellTBPadding - kVideoDetailHeadwCellIconHeight, kVideoDetailHeadwCellIconWidth, kVideoDetailHeadwCellIconHeight);
    // 离线下载
    self.downLoadButton.frame = CGRectMake(CGRectGetMinX(self.praiseButton.frame) - kVideoDetailHeadwCellIconMargin - kVideoDetailHeadwCellIconWidth, CGRectGetMinY(self.praiseButton.frame), kVideoDetailHeadwCellIconWidth, kVideoDetailHeadwCellIconHeight);
    // 分享推荐
    self.shareButton.frame = CGRectMake(CGRectGetMinX(self.downLoadButton.frame) - kVideoDetailHeadwCellIconMargin - kVideoDetailHeadwCellIconWidth, CGRectGetMinY(self.praiseButton.frame), kVideoDetailHeadwCellIconWidth, kVideoDetailHeadwCellIconHeight);
    // 评论
//    self.commonButton.frame = CGRectMake(kVideoDetailHeadwCellTBPadding, cellModel.cellHeight - kVideoDetailHeadwCellTBPadding - kVideoDetailHeadwCellIconHeight, kVideoDetailHeadwCellIconWidth, kVideoDetailHeadwCellIconHeight);
    
    self.bottomLine.frame = CGRectMake(kVideoDetailHeadwCellTBPadding, cellModel.cellHeight - 0.5, kVideoDetailHeadwCellWidth - kVideoDetailHeadwCellLRPadding*2, 0.5);
}


#pragma mark - Button Action
//- (void)commonButtonActon {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(commonAction)]) {
//        [self.delegate commonAction];
//    }
//}
- (void)shareButtonActon {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareAction)]) {
        [self.delegate shareAction];
    }
}

- (void)downLoadButtonActon {
    if (self.delegate && [self.delegate respondsToSelector:@selector(downLoadAction)]) {
        [self.delegate downLoadAction];
    }
}
- (void)praiseButtonActon {
    if (self.delegate && [self.delegate respondsToSelector:@selector(praiseAction)]) {
        [self.delegate praiseAction];
        [_praiseButton setImage:[UIImage imageNamed:@"praiseed"] forState:UIControlStateNormal];
    }
}

- (void)favoriteButtonActon {
    if (self.delegate && [self.delegate respondsToSelector:@selector(favoriteAction)]) {
        [self.delegate favoriteAction];
        [_favoriteButton setImage:[UIImage imageNamed:@"sr2_sub_photo_like_on"] forState:UIControlStateNormal];
    }
}

#pragma mark - Factory method
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
    }
    return _detailLabel;
}

//- (UIButton *)commonButton {
//    if (_commonButton == nil) {
//        _commonButton = [[UIButton alloc] init];
//        [_commonButton setImage:[UIImage imageNamed:@"write_review_star_gy"] forState:UIControlStateNormal];
//        [_commonButton setTitle:localizeString(@"") forState:UIControlStateNormal];
//        [_commonButton addTarget:self action:@selector(commonButtonActon) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _commonButton;
//}
- (UIButton *)shareButton {
    if (_shareButton == nil) {
        _shareButton = [[UIButton alloc] init];
        [_shareButton setImage:[UIImage imageNamed:@"common_share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonActon) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}
- (UIButton *)downLoadButton {
    if (_downLoadButton == nil) {
        _downLoadButton = [[UIButton alloc] init];
        [_downLoadButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
        [_downLoadButton addTarget:self action:@selector(downLoadButtonActon) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downLoadButton;
}
- (UIButton *)praiseButton {
    if (_praiseButton == nil) {
        _praiseButton = [[UIButton alloc] init];
        [_praiseButton setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
        [_praiseButton addTarget:self action:@selector(praiseButtonActon) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseButton;
}

- (UIButton *)favoriteButton {
    if (_favoriteButton == nil) {
        _favoriteButton = [[UIButton alloc] init];
        [_favoriteButton setImage:[UIImage imageNamed:@"sr2_sub_photo_like_off"] forState:UIControlStateNormal];
        [_favoriteButton addTarget:self action:@selector(favoriteButtonActon) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favoriteButton;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor orLineColor];
    }
    return _bottomLine;
}

@end


