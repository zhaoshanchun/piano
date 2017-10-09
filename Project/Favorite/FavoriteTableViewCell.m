//
//  FavoriteTableViewCell.m
//  gangqinjiaocheng
//
//  Created by kun on 2017/9/26.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "FavoriteTableViewCell.h"

@implementation FavoriteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupView];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //NSLog(@"%s", __func__);
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.layer.cornerRadius = 5;
        self.layer.frame = CGRectMake(10, 10, 200, 60);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.contentView.frame = CGRectMake(10, 10, 200, 60);
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    _iconImageView = [UIImageView new];
    _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _iconImageView.clipsToBounds = YES;
   // _iconImageView.image = [UIImage imageNamed:@"XMjQ4Mjc4MjY4NA==.jpg"];
    _iconImageView.layer.cornerRadius = 3;
    _iconImageView.layer.masksToBounds =YES;
    
    [self.contentView addSubview:_iconImageView];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:8]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:8]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_iconImageView attribute:NSLayoutAttributeHeight multiplier:1.5 constant:0]];
    
    _title = [UILabel new];
    _title.translatesAutoresizingMaskIntoConstraints = NO;
    _title.font = [UIFont systemFontOfSize:14];
    _title.textColor = [UIColor blackColor];
    //_title.text=@"标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题";
    //_title.textAlignment = NSTextAlignmentNatural;
    [_title setNumberOfLines:0];
    [self.contentView addSubview:_title];
    
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_iconImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:3]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-3]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:3]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-3]];
    
}
@end
