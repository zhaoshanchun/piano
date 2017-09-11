//
//  HistoryListCollectionViewCell.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "HistoryListCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface HistoryListCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;

@end

@implementation HistoryListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        [self showBorder:[UIColor greenColor]];
        
        [self addContent];
    }
    return self;
}

- (void)addContent {
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
}

- (void)setCellModel:(HistoryListCollectionViewCellModel *)cellModel {
    if (cellModel == nil) {
        return ;
    }
    _cellModel = cellModel;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:cellModel.imageUrl]
                      placeholderImage:[UIImage imageNamed:@"Placeholder"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
                             }];
    
    self.titleLabel.attributedText = cellModel.titleAttribute;
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
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kHistoryListItemWidth, kHistoryListItemImageHeight)];  // 45 是留给下面文字部分的
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
        [_titleLabel showBorder:[UIColor redColor]];
    }
    return _titleLabel;
}

@end
