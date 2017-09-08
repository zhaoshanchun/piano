//
//  VideoDetailMoreVideoCellModel.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/8.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "VideoDetailMoreVideoCellModel.h"

@implementation VideoDetailMoreVideoCellModel

- (void)setContentModel:(ContentModel *)contentModel {
    if (contentModel == nil) {
        return;
    }
    _contentModel = contentModel;
    
    self.imageUrl = contentModel.preview;
    self.imageFrame = CGRectMake(kVideoDetailMoreVideoCellLRPadding, 0, kVideoDetailMoreVideoCellImageWidth, kVideoDetailMoreVideoCellImageHeight);
    
    self.titleAttribute = formatAttributedStringByORFontGuide(@[contentModel.title, @"BR15N"], nil);
    CGFloat titleWidth = kVideoDetailMoreVideoCellWidth - kVideoDetailMoreVideoCellLRPadding*2 - CGRectGetMaxX(self.imageFrame);
    CGSize size = getSizeForAttributedString(self.titleAttribute, titleWidth, MAXFLOAT);
    self.titleFrame = CGRectMake(CGRectGetMaxX(self.imageFrame) + kVideoDetailMoreVideoCellLRPadding, 0, titleWidth, size.height);
    
    // title align center by vertical
    if (size.height > kVideoDetailMoreVideoCellImageHeight) {
        self.titleFrame = CGRectMake(CGRectGetMaxX(self.imageFrame) + kVideoDetailMoreVideoCellLRPadding, 0, titleWidth, kVideoDetailMoreVideoCellImageHeight);
    } else {
        CGFloat margin = kVideoDetailMoreVideoCellImageHeight - size.height;
        self.titleFrame = CGRectMake(CGRectGetMaxX(self.imageFrame) + kVideoDetailMoreVideoCellLRPadding, margin/2, titleWidth, size.height);
    }
    
    self.cellHeight = CGRectGetMaxY(self.imageFrame) + kVideoDetailMoreVideoCellTBPadding;
}

@end
