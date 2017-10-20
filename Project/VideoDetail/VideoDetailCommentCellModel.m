//
//  VideoDetailCommentCellModel.m
//  apps
//
//  Created by zhaosc on 2017/10/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "VideoDetailCommentCellModel.h"

@implementation VideoDetailCommentCellModel

- (void)setCommentModel:(CommentModel *)commentModel {
    if (!commentModel) {
        return;
    }
    _commentModel = commentModel;
    
    self.imageUrl = commentModel.iconUrl;
    self.imageFrame = CGRectMake(kVideoDetailCommentCellLRPadding, kVideoDetailCommentCellTBPadding, kVideoDetailCommentCellImageWidth, kVideoDetailCommentCellImageWidth);
    
    self.userNameAttribute = formatAttributedStringByORFontGuide(@[(commentModel.alias.length > 0) ? commentModel.alias : @"", @"BR14N"], nil);
    CGFloat titleWidth = kVideoDetailCommentCellWidth - kVideoDetailCommentCellLRPadding*2 - CGRectGetMaxX(self.imageFrame) - kVideoDetailCommentCellHMidMargin;
    CGSize size = getSizeForAttributedString(self.userNameAttribute, titleWidth, MAXFLOAT);
    self.userNameFrame = CGRectMake(CGRectGetMaxX(self.imageFrame) + kVideoDetailCommentCellHMidMargin, kVideoDetailCommentCellTBPadding, titleWidth, size.height);
    
    self.commentAttribute = formatAttributedStringByORFontGuide(@[(commentModel.content.length > 0) ? commentModel.content : @"", @"BR14N"], nil);
    size = getSizeForAttributedString(self.commentAttribute, titleWidth, MAXFLOAT);
    self.commentFrame = CGRectMake(CGRectGetMinX(self.userNameFrame), CGRectGetMaxY(self.userNameFrame) + kVideoDetailCommentCellVMidMargin, titleWidth, size.height);
    
    self.timeAttribute = formatAttributedStringByORFontGuide(@[(commentModel.time.length > 0) ? commentModel.time : @"", @"DGY12N"], nil);
    size = getSizeForAttributedString(self.timeAttribute, titleWidth, MAXFLOAT);
    self.timeFrame = CGRectMake(CGRectGetMinX(self.userNameFrame), CGRectGetMaxY(self.commentFrame) + kVideoDetailCommentCellVMidMargin, titleWidth, size.height);
    
    self.cellHeight = CGRectGetMaxY(self.timeFrame) + kVideoDetailCommentCellTBPadding;
    
}

@end
