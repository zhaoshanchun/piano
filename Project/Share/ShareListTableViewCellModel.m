//
//  ShareListTableViewCellModel.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/16.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ShareListTableViewCellModel.h"

@implementation ShareListTableViewCellModel

- (void)setShareModel:(ShareModel *)shareModel {
    if (shareModel == nil) {
        return;
    }
    _shareModel = shareModel;
    self.cellHeight = kShareListTableViewCellTBPadding;
    
    if (shareModel.content.length > 0) {
        self.contentAttribute = formatAttributedStringByORFontGuide(@[shareModel.content, @"BR15N"], nil);
        CGSize size = getSizeForAttributedString(self.contentAttribute, kShareListTableViewCellPlayViewWidth, MAXFLOAT);
        self.contentFrame = CGRectMake(kShareListTableViewCellLRPadding, kShareListTableViewCellTBPadding, kShareListTableViewCellPlayViewWidth, size.height);
        self.cellHeight = CGRectGetMaxY(self.contentFrame) + kShareListTableViewCellTBPadding;
    }
    
    if (shareModel.alias.length > 0) {
        self.detailAttribute = formatAttributedStringByORFontGuide(@[shareModel.alias, @"DGY13N"], nil);
        CGSize size = getSizeForAttributedString(self.detailAttribute, kShareListTableViewCellPlayViewWidth, MAXFLOAT);
        self.detailFrame = CGRectMake(kShareListTableViewCellLRPadding, CGRectGetMaxY(self.contentFrame), kShareListTableViewCellPlayViewWidth, size.height);
        self.cellHeight = CGRectGetMaxY(self.detailFrame) + kShareListTableViewCellTBPadding;
    }
    
    self.playViewFrame = CGRectMake(kShareListTableViewCellLRPadding, self.cellHeight, kShareListTableViewCellPlayViewWidth, kShareListTableViewCellPlayViewHeight);
    self.cellHeight = CGRectGetMaxY(self.playViewFrame) + kShareListTableViewCellTBPadding;
    
    if (shareModel.title.length > 0) {
        self.titleAttribute = formatAttributedStringByORFontGuide(@[shareModel.title, @"W14N"], nil);
        CGSize size = getSizeForAttributedString(self.titleAttribute, kShareListTableViewCellPlayViewWidth - kShareListTableViewCellLRPadding*2, MAXFLOAT);
        self.titleFrame = CGRectMake(kShareListTableViewCellLRPadding, kShareListTableViewCellTBPadding, kShareListTableViewCellPlayViewWidth - kShareListTableViewCellLRPadding*2, size.height);
    }
    
    
}

@end
