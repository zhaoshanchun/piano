//
//  TextTableViewCell.m
//  base
//
//  Created by kun on 2017/4/24.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "TextTableViewCell.h"

@implementation TextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"%s", __func__);
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}
- (void)setupView
{
    NSLog(@"%s", __func__);
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconImageView = [UIImageView new];
    _iconImageView.frame = CGRectMake(5, 8, 120, 70);
    _iconImageView.layer.cornerRadius = 5;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.image = [UIImage imageNamed:@"piano"];
    _nameLabel = [UILabel new];
    _nameLabel.frame = CGRectMake(128, 20, self.bounds.size.width, self.bounds.size.height);
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_nameLabel];
    
    _nextImageView = [UIImageView new];
    _nextImageView.layer.cornerRadius = 5;
    _nextImageView.image = [UIImage imageNamed:@"Next"];
    _nextImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _nextImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSDictionary *vD = NSDictionaryOfVariableBindings(_nextImageView);
    
    [self.contentView addSubview:_nextImageView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_nextImageView(20)]" options:0 metrics:nil views:vD]];
    //设置宽度
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_nextImageView(20)]" options:0 metrics:nil views:vD]];
    
    //垂直居中
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nextImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nextImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-3]];
    
}


+ (CGFloat)fixedHeight
{
    return 88;
}


@end
