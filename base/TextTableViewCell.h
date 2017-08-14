//
//  TextTableViewCell.h
//  base
//
//  Created by kun on 2017/4/24.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *nextImageView;
+ (CGFloat)fixedHeight;

@end
