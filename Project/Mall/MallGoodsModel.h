//
//  MallGoodsModel.h
//  apps
//
//  Created by zhaosc on 2017/12/10.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MallGoodsModel : NSObject

@property (strong,  nonatomic) NSString *itemId;
@property (strong,  nonatomic) NSString *logoUrl;
@property (strong,  nonatomic) NSString *itemName;
@property (strong,  nonatomic) NSString *price;

+ (MallGoodsModel *)shareManager;
+ (NSMutableArray *)getCurrentGoods;

@end
