//
//  PublicShareCellModel.m
//  CLPlayerDemo
//
//  Created by JmoVxia on 2017/8/4.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "PublicShareCellModel.h"

@implementation PublicShareCellModel

- (void)setShareModel:(ShareModel *)shareModel {
    if (shareModel == nil) {
        return;
    }
    _shareModel = shareModel;
    self.cellHeight = kShareListTableViewCellTBPadding;
    
    if (shareModel.content.length > 0) {
        self.contentAttribute = formatAttributedStringByORFontGuide(@[shareModel.content, @"BR17B"], nil);
        CGSize size = getSizeForAttributedString(self.contentAttribute, kShareListTableViewCellPlayViewWidth, MAXFLOAT);
        self.contentFrame = CGRectMake(kShareListTableViewCellLRPadding, kShareListTableViewCellTBPadding, kShareListTableViewCellPlayViewWidth, size.height);
        self.cellHeight = CGRectGetMaxY(self.contentFrame) + kShareListTableViewCellTBPadding;
    }
    
    if (shareModel.alias.length > 0 || shareModel.time.length > 0) {
        NSString *detailString = [NSString stringWithFormat:@"%@%@%@", shareModel.alias, (shareModel.alias.length > 0) ? @" " : @"", shareModel.time];
        self.detailAttribute = formatAttributedStringByORFontGuide(@[detailString, @"DGY13N"], nil);
        CGSize size = getSizeForAttributedString(self.detailAttribute, kShareListTableViewCellPlayViewWidth, MAXFLOAT);
        self.detailFrame = CGRectMake(kShareListTableViewCellLRPadding, CGRectGetMaxY(self.contentFrame), kShareListTableViewCellPlayViewWidth, size.height);
        self.cellHeight = CGRectGetMaxY(self.detailFrame) + kShareListTableViewCellTBPadding;
    }
    
    self.playViewFrame = CGRectMake(kShareListTableViewCellLRPadding, self.cellHeight, kShareListTableViewCellPlayViewWidth, kShareListTableViewCellPlayViewHeight);
    self.cellHeight = CGRectGetMaxY(self.playViewFrame) + kShareListTableViewCellTBPadding;
    
    if (shareModel.title.length > 0) {
        self.titleAttribute = formatAttributedStringByORFontGuide(@[shareModel.title, @"BR15N"], nil);
        CGSize size = getSizeForAttributedString(self.titleAttribute, kShareListTableViewCellPlayViewWidth - kShareListTableViewCellLRPadding*2, MAXFLOAT);
        self.titleFrame = CGRectMake(kShareListTableViewCellLRPadding, self.cellHeight, kShareListTableViewCellPlayViewWidth - kShareListTableViewCellLRPadding*2, size.height);
        self.cellHeight = CGRectGetMaxY(self.titleFrame) + kShareListTableViewCellTBPadding;
    }
}

- (NSString *)iconUrl {
    if (self.shareModel.icon.length > 0) {
        return [NSString stringWithFormat:@"%@/%@%@", kHTTPHomeAddress, kAPIGetImage, self.shareModel.icon];
    }
    return @"";
}


@end

