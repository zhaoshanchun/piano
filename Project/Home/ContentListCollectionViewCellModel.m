//
//  ContentListCollectionViewCellModel.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/1.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ContentListCollectionViewCellModel.h"

@implementation ContentListCollectionViewCellModel

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
    
    // self.detailAttribute = formatAttributedStringByORFontGuide(@[@"9月2日开启登陆作战", @"dgy13N"], nil);
}

@end
