//
//  HistoryListCollectionViewCellModel.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "HistoryListCollectionViewCellModel.h"

@implementation HistoryListCollectionViewCellModel

- (void)setContentModel:(ContentModel *)contentModel {
    if (contentModel == nil) {
        return;
    }
    _contentModel = contentModel;
    
    self.imageUrl = contentModel.preview;
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentLeft;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleAttribute = formatAttributedStringByORFontGuide(@[contentModel.title, @"BR15N"], @[style]);
}

@end
