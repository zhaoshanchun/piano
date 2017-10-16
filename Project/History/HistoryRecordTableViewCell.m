//
//  TableViewCell.m
//  apps
//
//  Created by kun on 2017/10/16.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "HistoryRecordTableViewCell.h"

@implementation HistoryRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _iconImageView = [UIImageView new];
    _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = 3;
    _iconImageView.layer.masksToBounds =YES;
    [self.contentView addSubview:_iconImageView];
    
    _title = [UILabel new];
    _title.translatesAutoresizingMaskIntoConstraints = NO;
    [_title setFontAndTextColorByKey:@"BR14N"];
    [_title setNumberOfLines:0];
    [self.contentView addSubview:_title];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:kFavoriteTableViewCellTBPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:kFavoriteTableViewCellLRPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-1*kFavoriteTableViewCellTBPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_iconImageView attribute:NSLayoutAttributeHeight multiplier:1.78 constant:0]];    // 1.78 = (16/9)
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_iconImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:kFavoriteTableViewCellMidMargin]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-1*kFavoriteTableViewCellLRPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:kFavoriteTableViewCellTBPadding]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-1*kFavoriteTableViewCellTBPadding]];
}

@end
