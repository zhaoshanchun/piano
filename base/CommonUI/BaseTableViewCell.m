//
//  BaseTableViewCell.m
//  base
//
//  Created by kun on 2017/4/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    NSLog(@"%s", __func__);
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   // NSLog(@"%s", __func__);
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   // NSLog(@"%s", __func__);
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
   // NSLog(@"%s", __func__);
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconImageView = [UIImageView new];
    //_iconImageView.frame = CGRectMake(0, 0, 60*1.65, 60);
    _iconImageView.layer.cornerRadius = 5;
    
   // _iconImageView.clipsToBounds = YES;
   // _iconImageView.layoutMargins=(UIEdgeInsets){3,3,3,3};
    _iconImageView.backgroundColor = [UIColor clearColor];

    _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_iconImageView];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:3]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:3]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-3]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1.65 constant:0]];
    
    
    _playImageView = [UIImageView new];// initWithFrame:CGRectMake(100, 200, 80, 80)];
    _playImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _playImageView.contentMode = UIViewContentModeScaleAspectFit;
    _playImageView.layer.cornerRadius = 5;
    _playImageView.clipsToBounds = YES;
    _playImageView.image = [UIImage imageNamed:@"Play"];
    _playImageView.hidden = YES;
    _playImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_playImageView];
    
    NSDictionary *_playImageViewvD = NSDictionaryOfVariableBindings(_playImageView);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_playImageView(32)]" options:0 metrics:nil views:_playImageViewvD]];
    //设置宽度
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_playImageView(32)]" options:0 metrics:nil views:_playImageViewvD]];
    //垂直居中
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_playImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    //水平居中
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_playImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    _nextImageView = [UIImageView new];
    _nextImageView.layer.cornerRadius = 5;
    _nextImageView.image = [UIImage imageNamed:@"play.png"];
    _nextImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _nextImageView.contentMode = UIViewContentModeScaleAspectFit;
    _nextImageView.backgroundColor = [UIColor clearColor];

    NSDictionary *vD = NSDictionaryOfVariableBindings(_nextImageView);
    
    [self.contentView addSubview:_nextImageView];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_nextImageView(30)]" options:0 metrics:nil views:vD]];
    //设置宽度
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_nextImageView(30)]" options:0 metrics:nil views:vD]];
    //垂直居中
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nextImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-8]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nextImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-8]];
    
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.backgroundColor = [UIColor clearColor];

    _nameLabel.numberOfLines = 2;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self.contentView addSubview:_nameLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_iconImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_nextImageView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_nameLabel.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_timeLabel];
    
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.nextImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:20]];
    

    _loading = [UIActivityIndicatorView new];
    _loading.translatesAutoresizingMaskIntoConstraints = NO;
    _loading.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];;
    _loading.color = [UIColor whiteColor];
    [self.contentView addSubview:_loading];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_loading attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_loading attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    _bottom = [UIView new];
    _bottom.translatesAutoresizingMaskIntoConstraints = NO;
    _bottom.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    [self.iconImageView addSubview:_bottom];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bottom attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:17]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bottom attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bottom attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bottom attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    _playTime = [UILabel new];
    _playTime.font = [UIFont systemFontOfSize:12];
    _playTime.translatesAutoresizingMaskIntoConstraints = NO;
    _playTime.textColor = [UIColor whiteColor];
    _playTime.numberOfLines = 0;
    _playTime.backgroundColor = [UIColor clearColor];
    _playTime.lineBreakMode = NSLineBreakByWordWrapping;
    [_bottom addSubview:_playTime];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_playTime attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_bottom attribute:NSLayoutAttributeTrailing multiplier:1 constant:-2]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_playTime attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_bottom attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

+ (CGFloat)fixedHeight {
    return 60;
}

@end
