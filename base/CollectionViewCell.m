//
//  CollectionViewCell.m
//  huazhuangjiaocheng
//
//  Created by kun on 2017/6/10.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    // NSLog(@"%s", __func__);
    self.contentView.backgroundColor = [UIColor whiteColor];
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;

    _iconImageView = [UIImageView new];
    //_iconImageView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height - 20);//self.contentView.bounds;
    //_iconImageView.layer.cornerRadius = 5;
    _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _iconImageView.clipsToBounds = YES;
    [self.contentView addSubview:_iconImageView];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.backgroundColor = [UIColor whiteColor];
    //_nameLabel.numberOfLines = 0;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    _loading = [UIActivityIndicatorView new];
    _loading.translatesAutoresizingMaskIntoConstraints = NO;
    _loading.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];;
    _loading.color = [UIColor whiteColor];
    
    [self.iconImageView addSubview:_loading];
    
    [self.iconImageView addConstraint:[NSLayoutConstraint constraintWithItem:_loading attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.iconImageView addConstraint:[NSLayoutConstraint constraintWithItem:_loading attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    _bottom = [UIView new];
    _bottom.translatesAutoresizingMaskIntoConstraints = NO;
    _bottom.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    [self.iconImageView addSubview:_bottom];
    [self.iconImageView addConstraint:[NSLayoutConstraint constraintWithItem:_bottom attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:17]];
    
    [self.iconImageView addConstraint:[NSLayoutConstraint constraintWithItem:_bottom attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.iconImageView addConstraint:[NSLayoutConstraint constraintWithItem:_bottom attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [self.iconImageView addConstraint:[NSLayoutConstraint constraintWithItem:_bottom attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    _playTime = [UILabel new];
    _playTime.font = [UIFont systemFontOfSize:12];
    _playTime.translatesAutoresizingMaskIntoConstraints = NO;
    _playTime.textColor = [UIColor whiteColor];
    _playTime.numberOfLines = 0;
    _playTime.text = @"时长:00:00";
    _playTime.lineBreakMode = NSLineBreakByWordWrapping;
    [_bottom addSubview:_playTime];
    
    [self.iconImageView addConstraint:[NSLayoutConstraint constraintWithItem:_playTime attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_bottom attribute:NSLayoutAttributeTrailing multiplier:1 constant:-2]];
    
    [self.iconImageView addConstraint:[NSLayoutConstraint constraintWithItem:_playTime attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_bottom attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    _playImageView = [UIImageView new];// initWithFrame:CGRectMake(100, 200, 80, 80)];
    _playImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _playImageView.contentMode = UIViewContentModeScaleAspectFit;
    _playImageView.layer.cornerRadius = 5;
    _playImageView.clipsToBounds = YES;
    _playImageView.image = [UIImage imageNamed:@"Play"];
    _playImageView.hidden = YES;
    [self.iconImageView addSubview:_playImageView];
    
    NSDictionary *_playImageViewvD = NSDictionaryOfVariableBindings(_playImageView);
    [self.iconImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_playImageView(32)]" options:0 metrics:nil views:_playImageViewvD]];
    //设置宽度
    [self.iconImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_playImageView(32)]" options:0 metrics:nil views:_playImageViewvD]];
    
    //垂直居中
    [self.iconImageView addConstraint:[NSLayoutConstraint constraintWithItem:_playImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    //水平居中
    [self.iconImageView addConstraint:[NSLayoutConstraint constraintWithItem:_playImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];


}

@end
