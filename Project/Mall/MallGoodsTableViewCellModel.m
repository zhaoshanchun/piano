//
//  MallGoodsTableViewCellModel.m
//  apps
//
//  Created by zhaosc on 2017/12/10.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "MallGoodsTableViewCellModel.h"

@implementation MallGoodsTableViewCellModel

- (id)init {
    self = [super init];
    if (self) {
        self.cellHeight = 100;
    }
    return self;
}

- (void)setItemModel:(MallGoodsModel *)itemModel {
    _itemModel = itemModel;
    
    // todo...
}

@end
