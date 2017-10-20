//
//  VideoDetailMoreVideoCell.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/8.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "VideoDetailMoreVideoCell.h"

@interface VideoDetailMoreVideoCell ()

@property (strong, nonatomic) UIImageView *mainImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *bottomView;

@end

@implementation VideoDetailMoreVideoCell

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
    [self.contentView addSubview:self.mainImageView];
    [self.contentView addSubview:self.titleLabel];
    // [self.contentView addSubview:self.bottomView];
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

- (void)setCellModel:(VideoDetailMoreVideoCellModel *)cellModel {
    if (cellModel == nil) {
        return;
    }
    _cellModel = cellModel;
    
    self.mainImageView.frame = cellModel.imageFrame;
    self.mainImageView.clipsToBounds = YES;
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.imageUrl]
                      placeholderImage:[UIImage imageNamed:@"Placeholder"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
                             }];
    
    self.titleLabel.frame = cellModel.titleFrame;
    self.titleLabel.attributedText = cellModel.titleAttribute;
    
    if (cellModel.isLastOne) {
        self.bottomView.hidden = NO;
        self.bottomView.frame = CGRectMake(kVideoDetailMoreVideoCellTBPadding, cellModel.cellHeight - 0.5f, kVideoDetailMoreVideoCellWidth - kVideoDetailMoreVideoCellLRPadding*2, 0.5);
    }
}


#pragma mark - Factory method
- (UIImageView *)mainImageView {
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _mainImageView.backgroundColor = [UIColor colorForKey:@"lgy"];
        _mainImageView.layer.cornerRadius = 3.f;
        _mainImageView.layer.masksToBounds = YES;
        _mainImageView.image = [UIImage imageNamed:@"Placeholder"];
    }
    return _mainImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
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

