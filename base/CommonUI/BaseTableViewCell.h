//
//  BaseTableViewCell.h
//  base
//
//  Created by kun on 2017/4/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *playTime;
@property (nonatomic, strong) UIActivityIndicatorView *loading;
@property (nonatomic, strong) UIView *bottom;

+ (CGFloat)fixedHeight;

@end

