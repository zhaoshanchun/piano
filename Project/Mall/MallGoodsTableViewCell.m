//
//  MallGoodsTableViewCell.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 2017/12/10.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "MallGoodsTableViewCell.h"

@implementation MallGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView = nil;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _iconImageView = [UIImageView new];
    _iconImageView.backgroundColor = [UIColor colorForKey:@"gy"];
    _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _iconImageView.contentMode = UIViewContentModeScaleToFill;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = 3;
    _iconImageView.layer.masksToBounds =YES;
    [self.contentView addSubview:_iconImageView];
    
    _title = [UILabel new];
    _title.translatesAutoresizingMaskIntoConstraints = NO;
    [_title setFontAndTextColorByKey:@"BR16B"];
    [_title setNumberOfLines:2];
//    _title.layer.borderColor = [UIColor redColor].CGColor;
//    _title.layer.borderWidth = 0.5f;
    [self.contentView addSubview:_title];
    
    
    _priceLabel = [UILabel new];
    _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_priceLabel setFontAndTextColorByKey:@"O16B"];
    [_priceLabel setNumberOfLines:1];
//    _priceLabel.layer.borderColor = [UIColor blueColor].CGColor;
//    _priceLabel.layer.borderWidth = 0.5f;
    [self.contentView addSubview:_priceLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:kMallGoodsTableViewCellTBPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:kMallGoodsTableViewCellLRPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-1*kMallGoodsTableViewCellTBPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.title attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:kMallGoodsTableViewCellMidMargin]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.title attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-1*kMallGoodsTableViewCellLRPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.title attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:kMallGoodsTableViewCellTBPadding]];
     // [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.title attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-1*kMallGoodsTableViewCellTBPadding]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.priceLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.title attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.priceLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.title attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.priceLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.title attribute:NSLayoutAttributeBottom multiplier:1 constant:3]];
}

@end
