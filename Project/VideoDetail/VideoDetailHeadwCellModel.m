//
//  VideoDetailHeadwCellModel.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/6.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "VideoDetailHeadwCellModel.h"

@implementation VideoDetailHeadwCellModel

- (void)setSourceModel:(SourceModel *)sourceModel {
    if (sourceModel == nil) {
        return;
    }
    _sourceModel = sourceModel;
    
    NSMutableParagraphStyle *sytle = [NSMutableParagraphStyle new];
    sytle.alignment = NSTextAlignmentLeft;
    sytle.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleAttribute = formatAttributedStringByORFontGuide(@[sourceModel.title, @"BR16B"], nil);
    CGSize size = getSizeForAttributedString(self.titleAttribute, kVideoDetailHeadwCellWidth - kVideoDetailHeadwCellLRPadding*2, MAXFLOAT);
    self.titleFrame = CGRectMake(kVideoDetailHeadwCellLRPadding, kVideoDetailHeadwCellTBPadding, kVideoDetailHeadwCellWidth - kVideoDetailHeadwCellLRPadding*2, size.height);
    
    NSString *playsString = [NSString stringWithFormat:@"%ld%@ ", sourceModel.plays, localizeString(@"次播放")];
    NSString *scoreString = [NSString stringWithFormat:@"%@%@ ", sourceModel.score, localizeString(@"分")];
    NSString *praiseString = [NSString stringWithFormat:@"%ld%@ ", sourceModel.praise, localizeString(@"人点赞")];
    self.detailAttribute = formatAttributedStringByORFontGuide(@[playsString, @"DGY13N", scoreString, @"DGY13N", praiseString, @"DGY13N",], nil);
    size = getSizeForAttributedString(self.detailAttribute, kVideoDetailHeadwCellWidth - kVideoDetailHeadwCellLRPadding*2, MAXFLOAT);
    self.detailFrame = CGRectMake(kVideoDetailHeadwCellLRPadding, CGRectGetMaxY(self.titleFrame) + 5, kVideoDetailHeadwCellWidth - kVideoDetailHeadwCellLRPadding*2, size.height);
    
    self.cellHeight = CGRectGetMaxY(self.detailFrame) + 20 + kVideoDetailHeadwCellIconHeight + kVideoDetailHeadwCellTBPadding;
}

@end