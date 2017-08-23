//
//  OtherTableViewCell.h
//  riyusuxue
//
//  Created by kun on 2017/5/15.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;

+ (CGFloat)fixedHeight;

@end
