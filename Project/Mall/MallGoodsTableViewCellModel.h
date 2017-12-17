//
//  MallGoodsTableViewCellModel.h
//  apps
//
//  Created by zhaosc on 2017/12/10.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MallGoodsModel.h"

#define kMallGoodsTableViewCellHeight 80.f
#define kMallGoodsTableViewCellLRPadding 10.f
#define kMallGoodsTableViewCellTBPadding 10.f
#define kMallGoodsTableViewCellMidMargin 15.f

@interface MallGoodsTableViewCellModel : NSObject

@property (strong, nonatomic) MallGoodsModel *itemModel;

@property (assign, nonatomic) CGRect imageFrame;
@property (assign, nonatomic) CGRect titleFrame;
@property (assign, nonatomic) CGRect priceFrame;
@property (assign, nonatomic) CGFloat cellHeight;

@end
