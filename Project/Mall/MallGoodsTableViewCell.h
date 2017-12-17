//
//  MallGoodsTableViewCell.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 2017/12/10.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBaseTableViewCell.h"
#import "MallGoodsTableViewCellModel.h"

static NSString *kMallGoodsTableViewCellIdentifier = @"kMallGoodsTableViewCellIdentifier";

@interface MallGoodsTableViewCell : UIBaseTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *priceLabel;

@property (strong, nonatomic) MallGoodsTableViewCellModel *cellModel;

@end
