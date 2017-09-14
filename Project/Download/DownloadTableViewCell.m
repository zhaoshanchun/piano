//
//  DownloadTableViewCell.m
//  sifakaoshi
//
//  Created by kun on 2017/9/7.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "DownloadTableViewCell.h"

@implementation DownloadTableViewCell

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
        //self.frame = CGRectMake(10, 10, self.contentView.frame.size.width, self.contentView.frame.size.height);
        self.contentView.frame = CGRectMake(10, 10, 200, 60);

        //self.preservesSuperviewLayoutMargins = YES;
        //self.layoutMargins =(UIEdgeInsets){12, 12, 12, 12};
        //self.contentView.layoutMargins = (UIEdgeInsets){12, 12, 12, 12};
        [self setupView];
    }
    return self;
}

/*
- (void)setFrame:(CGRect)frame{
    frame.origin.x += 15;
    frame.size.width -= 30;
    [super setFrame:frame];
}
*/
- (void)setupView
{
    _iconImageView = [UIImageView new];
    _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.image = [UIImage imageNamed:@"XMjQ4Mjc4MjY4NA==.jpg"];
    _iconImageView.layer.cornerRadius = 3;
    _iconImageView.layer.masksToBounds =YES;

    [self.contentView addSubview:_iconImageView];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:8]];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:8]];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_iconImageView attribute:NSLayoutAttributeHeight multiplier:1.5 constant:0]];

    _playImageView = [UIImageView new];
    _playImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _playImageView.clipsToBounds = YES;
    _playImageView.image = [UIImage imageNamed:@"play.png"];
    _playImageView.layer.cornerRadius = 3;
    _playImageView.layer.masksToBounds =YES;
    _playImageView.hidden = YES;
    [self.contentView addSubview:_playImageView];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_playImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:35]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_playImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:35]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_playImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_playImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-8]];

    
    _title = [UILabel new];
    _title.translatesAutoresizingMaskIntoConstraints = NO;
    _title.font = [UIFont systemFontOfSize:12];
    _title.textColor = [UIColor blackColor];
    _title.text=@"标题标题标题标题标";
    [self.contentView addSubview:_title];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_iconImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:3]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_playImageView attribute:NSLayoutAttributeLeading multiplier:1 constant:-3]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:3]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:0.5 constant:-5]];

    _processValue = [UILabel new];
    _processValue.translatesAutoresizingMaskIntoConstraints = NO;
    _processValue.font = [UIFont systemFontOfSize:12];
    _processValue.textColor = [UIColor blackColor];
    _processValue.text=@"100%";
    [self.contentView addSubview:_processValue];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_processValue attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:35]];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_processValue attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:18]];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_processValue attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_playImageView attribute:NSLayoutAttributeLeading multiplier:1 constant:-3]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_processValue attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-5]];

    _processView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    _processView.translatesAutoresizingMaskIntoConstraints = NO;
    _processView.progress = 0.5;
    [self.contentView addSubview:_processView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_processView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_iconImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:3]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_processView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_processValue attribute:NSLayoutAttributeLeading multiplier:1 constant:-1]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_processView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:2]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_processView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-12]];

    _rateValue = [UILabel new];
    _rateValue.translatesAutoresizingMaskIntoConstraints = NO;
    _rateValue.font = [UIFont systemFontOfSize:12];
    _rateValue.textColor = [UIColor blackColor];
    _rateValue.text=@"0kb/s";
    [self.contentView addSubview:_rateValue];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rateValue attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:80]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rateValue attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:18]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rateValue attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_processView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rateValue attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_processView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

    _dlSwitchButton = [UIButton new];
    _dlSwitchButton.translatesAutoresizingMaskIntoConstraints = NO;
    _dlSwitchButton.clipsToBounds = YES;
    [_dlSwitchButton setImage:[UIImage imageNamed:@"download_start.png"] forState:UIControlStateNormal];
    [_dlSwitchButton setImage:[UIImage imageNamed:@"download_stop.png"] forState:UIControlStateSelected];
   // [_dlSwitchButton setBackgroundImage:[UIImage imageNamed:@"download_start.png"] forState:UIControlStateNormal];
    _dlSwitchButton.layer.cornerRadius = 3;
    _dlSwitchButton.layer.masksToBounds =YES;
    
    [self.contentView addSubview:_dlSwitchButton];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dlSwitchButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:35]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dlSwitchButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:25]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dlSwitchButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dlSwitchButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-8]];

}
@end
