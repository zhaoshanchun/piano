//
//  FavoriteTableViewCell.h
//  gangqinjiaocheng
//
//  Created by kun on 2017/9/26.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBaseTableViewCell.h"

#define kFavoriteTableViewCellHeight 80.f
#define kFavoriteTableViewCellLRPadding 10.f
#define kFavoriteTableViewCellTBPadding 10.f
#define kFavoriteTableViewCellMidMargin 10.f

@interface FavoriteTableViewCell : UIBaseTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *title;

@end
