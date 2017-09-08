//
//  ContentListCollectionViewCell.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/1.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ContentListCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface ContentListCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;

@end

@implementation ContentListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
//        [self showBorder:[UIColor greenColor]];
        
        [self addContent];
    }
    return self;
}

- (void)addContent {
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
//    [self addSubview:self.detailLabel];
}

- (void)setCellModel:(ContentListCollectionViewCellModel *)cellModel {
    if (cellModel == nil) {
        return ;
    }
    _cellModel = cellModel;
    
    // [self.imageView sd_setImageWithURL:[NSURL URLWithString:cellModel.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:cellModel.imageUrl]
                      placeholderImage:[UIImage imageNamed:@"Placeholder"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             
                             }];
    
    self.titleLabel.attributedText = cellModel.titleAttribute;
    
//    if (cellModel.detailAttribute.length > 0) {
//        self.detailLabel.hidden = NO;
//        self.detailLabel.attributedText = cellModel.detailAttribute;
//    } else {
//        self.detailLabel.hidden = YES;
//    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor orTableViewCellHighlightedColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    [super setHighlighted:highlighted];
}


#pragma mark - Factory method
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kContentListItemWidth, kContentListItemImageHeight)];  // 45 是留给下面文字部分的
        _imageView.backgroundColor = [UIColor colorForKey:@"lgy"];
        _imageView.layer.cornerRadius = 3.f;
        _imageView.layer.masksToBounds = YES;
        
        _imageView.image = [UIImage imageNamed:@"Placeholder"];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.imageView.frame), CGRectGetMaxY(self.imageView.frame) + 5, CGRectGetWidth(self.imageView.frame), 40)];
        _titleLabel.numberOfLines = 2;
//        _titleLabel.attributedText = formatAttributedStringByORFontGuide(@[@"敦刻尔克", @"BR16N"], nil);
//        [_titleLabel showBorder:[UIColor redColor]];
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 2, CGRectGetWidth(self.titleLabel.frame), 18)];
        // _detailLabel.attributedText = formatAttributedStringByORFontGuide(@[@"9月2日开启登陆作战", @"dgy13N"], nil);
//        [_detailLabel showBorder:[UIColor blueColor]];
    }
    return _detailLabel;
}

@end

