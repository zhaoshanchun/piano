//
//  MallGoodsModel.m
//  apps
//
//  Created by zhaosc on 2017/12/10.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "MallGoodsModel.h"

@implementation MallGoodsModel

+ (MallGoodsModel *)shareManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (NSMutableArray *)getCurrentGoods {
    NSMutableArray *currentGoods = [NSMutableArray new];
    
    MallGoodsModel *goods1 = [MallGoodsModel new];
    goods1.itemId = @"559163223052";
    goods1.itemName = @"备考2018护士执业资格考试轻松过考试达人护士资格考试用书人卫版";
    goods1.price = @"¥59.25";
    goods1.logoUrl = @"https://g-search3.alicdn.com/img/bao/uploaded/i4/i4/3379994517/TB1g3F0g6uhSKJjSspmXXcQDpXa_!!0-item_pic.jpg_80x80.jpg";
    [currentGoods addObject:goods1];
    
    MallGoodsModel *goods2 = [MallGoodsModel new];
    goods2.itemId = @"532960538882";
    goods2.itemName = @"2018年护士资格考试书过关精点 护考必备军医版送懒人必记";
    goods2.price = @"¥119.00";
    goods2.logoUrl = @"https://g-search2.alicdn.com/img/bao/uploaded/i4/i3/766915730/TB2EwNPXj3nyKJjSZFHXXaTCpXa_!!766915730.jpg_80x80.jpg";
    [currentGoods addObject:goods2];
    
    MallGoodsModel *goods3 = [MallGoodsModel new];
    goods3.itemId = @"560314460439";
    goods3.itemName = @"护士资格证考试用书2018年全国护士执业资格考试试题库护考2017护士资格考试历年真题冲刺试卷及解析搭人卫版军医版轻松过职业指导";
    goods3.price = @"¥ 15.80";
    goods3.logoUrl = @"https://g-search2.alicdn.com/img/bao/uploaded/i4/i2/1120654631/TB1mIyVc0LO8KJjSZPcXXaV0FXa_!!0-item_pic.jpg_80x80.jpg";
    [currentGoods addObject:goods3];
    
    MallGoodsModel *goods4 = [MallGoodsModel new];
    goods4.itemId = @"559485047706";
    goods4.itemName = @"现货 2018护士执业资格考试人卫版随身记 护士执业资格证考试2018人卫版护士执业资格考试用书 全国护考护士资格证考试试题2018年";
    goods4.price = @"¥ 39.75";
    goods4.logoUrl = @"https://g-search1.alicdn.com/img/bao/uploaded/i4/i4/2855675733/TB1479LgInI8KJjSspeXXcwIpXa_!!0-item_pic.jpg_80x80.jpg";
    [currentGoods addObject:goods4];
    
    MallGoodsModel *goods5 = [MallGoodsModel new];
    goods5.itemId = @"557994230575";
    goods5.itemName = @"全套】2018年护士资格证考试用书2018人卫版雪狐狸教材+护士资格考试模拟试卷及解析+考点随身记+口袋书护考轻松过试题职业军医版";
    goods5.price = @"¥ 98.00";
    goods5.logoUrl = @"https://g-search2.alicdn.com/img/bao/uploaded/i4/i4/1775910047/TB1Q3oMb7fb_uJkSndVXXaBkpXa_!!0-item_pic.jpg_80x80.jpg";
    [currentGoods addObject:goods5];
    
    MallGoodsModel *goods6 = [MallGoodsModel new];
    goods6.itemId = @"560221209932";
    goods6.itemName = @"现货新版 护士资格证考试用书2018人卫版护士执业资格考试用书教材轻松过+冲刺跑+随身记考试达人卫版2018年护士执业资格考试用书";
    goods6.price = @"¥ 200.30";
    goods6.logoUrl = @"https://g-search3.alicdn.com/img/bao/uploaded/i4/i4/2131382629/TB1sBzbaVHM8KJjSZFwXXcibXXa_!!0-item_pic.jpg_80x80.jpg";
    [currentGoods addObject:goods6];
    
    MallGoodsModel *goods7 = [MallGoodsModel new];
    goods7.itemId = @"562120420675";
    goods7.itemName = @"人卫版2018年全国护士执业资格证考试书全套 教材+习题+试卷+解析";
    goods7.price = @"¥88.00";
    goods7.logoUrl = @"https://g-search1.alicdn.com/img/bao/uploaded/i4/i2/3247180560/TB2oZBzggvD8KJjSsplXXaIEFXa_!!3247180560.jpg_80x80.jpg";
    [currentGoods addObject:goods7];
    
    MallGoodsModel *goods8 = [MallGoodsModel new];
    goods8.itemId = @"43321409127";
    goods8.itemName = @"全套12样】2018年护士执业资格考试用书应试指导教材人卫版+模拟试卷解析+必考点学霸笔记雪狐狸护士职业资格证人机对话软件真试题";
    goods8.price = @"¥ 108.00";
    goods8.logoUrl = @"https://g-search1.alicdn.com/img/bao/uploaded/i4/i3/2168050686/TB1KtymdDAKL1JjSZFCXXXFspXa_!!2-item_pic.png_80x80.jpg";
    [currentGoods addObject:goods8];
    
    MallGoodsModel *goods9 = [MallGoodsModel new];
    goods9.itemId = @"524902250164";
    goods9.itemName = @"【现货速发】人卫版护士资格证考试用书2018护考执业资格考试指导教材轻松过+随身记+冲刺跑共3本可搭军医历年真题试题职业急救包";
    goods9.price = @"¥ 200.25";
    goods9.logoUrl = @"https://g-search3.alicdn.com/img/bao/uploaded/i4/i1/2194134838/TB1QOBmckfb_uJkSndVXXaBkpXa_!!0-item_pic.jpg_80x80.jpg";
    [currentGoods addObject:goods9];
    
    MallGoodsModel *goods10 = [MallGoodsModel new];
    goods10.itemId = @"554092901380";
    goods10.itemName = @"护士资格证考试用书2018年护士资格考试教材历年真题及解析模拟试卷试题库全国护士执业护考职业指导搭轻松过随身记军医人卫版";
    goods10.price = @"¥ 39.80";
    goods10.logoUrl = @"https://g-search1.alicdn.com/img/bao/uploaded/i4/i3/2689011101/TB1VfoOh_nI8KJjSszbXXb4KFXa_!!0-item_pic.jpg_80x80.jpg";
    [currentGoods addObject:goods10];
    
    return currentGoods;
}

@end
