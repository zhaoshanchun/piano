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
    
    // Avatar
    self.avatarImageFrame = CGRectMake(kShareListTableViewCellLPadding, kShareListTableViewCellTBPadding, kPublicShareCellAvatarSize, kPublicShareCellAvatarSize);
    
    // User Name
    CGFloat titleWidth = kShareListTableViewCellPlayViewWidth - kPublicShareCellAvatarSize - kShareListTableViewCellMidMargin;
    self.userNameAttribute = formatAttributedStringByORFontGuide(@[shareModel.alias, @"BR15B"], nil);
    CGSize size = getSizeForAttributedString(self.userNameAttribute, titleWidth, MAXFLOAT);
    self.userNameTitleFrame = CGRectMake(CGRectGetMaxX(self.avatarImageFrame) + kShareListTableViewCellMidMargin, kShareListTableViewCellTBPadding, titleWidth, size.height);
    self.cellHeight = CGRectGetMaxY(self.userNameTitleFrame);
    
    // 分享的内容
    self.contentAttribute = formatAttributedStringByORFontGuide(@[shareModel.content, @"DGY13N"], nil);
    size = getSizeForAttributedString(self.contentAttribute, titleWidth, MAXFLOAT);
    self.contentFrame = CGRectMake(CGRectGetMinX(self.userNameTitleFrame), CGRectGetMaxY(self.userNameTitleFrame) + 5, titleWidth, size.height);
    self.cellHeight = CGRectGetMaxY(self.contentFrame);
    
    // 视频标题
    self.titleAttribute = formatAttributedStringByORFontGuide(@[shareModel.title, @"DGY13N"], nil);
    size = getSizeForAttributedString(self.titleAttribute, titleWidth, MAXFLOAT);
    self.titleFrame = CGRectMake(CGRectGetMinX(self.userNameTitleFrame), CGRectGetMaxY(self.contentFrame) + 5, titleWidth, size.height);
    self.cellHeight = CGRectGetMaxY(self.titleFrame);
    
    
    self.playViewFrame = CGRectMake(CGRectGetMinX(self.userNameTitleFrame), self.cellHeight + kShareListTableViewCellMidMargin, titleWidth, kShareListTableViewCellPlayViewHeight);
    self.cellHeight = CGRectGetMaxY(self.playViewFrame);
    
    self.timeAttribute = formatAttributedStringByORFontGuide(@[shareModel.time, @"DGY12N"], nil);
    size = getSizeForAttributedString(self.timeAttribute, titleWidth, MAXFLOAT);
    self.timeFrame = CGRectMake(CGRectGetMinX(self.userNameTitleFrame), self.cellHeight + kShareListTableViewCellMidMargin, titleWidth, size.height);
    self.cellHeight = CGRectGetMaxY(self.timeFrame) + kShareListTableViewCellTBPadding;
}

- (NSString *)iconUrl {
    if (self.shareModel.icon.length > 0) {
        return [NSString stringWithFormat:@"%@/%@%@", kHTTPHomeAddress, kAPIGetImage, self.shareModel.icon];
    }
    return @"";
}


@end

