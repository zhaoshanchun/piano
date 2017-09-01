//
//  ContentListCollectionViewCell.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/1.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ContentListCollectionViewCell.h"

@interface ContentListCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
//@property (strong, nonatomic) UILabel *detailLabel;

@end

@implementation ContentListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor greenColor].CGColor;
        self.layer.borderWidth = 0.5f;
        
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
    
    // TODO...
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
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kContentListItemWidth, kContentListItemHeight*2/3)];
        _imageView.backgroundColor = [UIColor colorForKey:@"lgy"];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.imageView.frame), CGRectGetMaxY(self.imageView.frame) + 5, CGRectGetWidth(self.imageView.frame), kContentListItemHeight - CGRectGetMaxY(self.imageView.frame) - 5)];
        _titleLabel.attributedText = formatAttributedStringByORFontGuide(@[@"最佳拍档", @"BR16N"], nil);
    }
    return _titleLabel;
}
//- (UILabel *)detailLabel {
//    if (_detailLabel == nil) {
//        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _detailLabel.hidden = YES;
//    }
//    return _detailLabel;
//}

@end

