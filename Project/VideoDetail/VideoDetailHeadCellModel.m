//
//  VideoDetailHeadCellModel.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/6.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "VideoDetailHeadCellModel.h"

@implementation VideoDetailHeadCellModel

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
    
    NSString *playsString = [NSString stringWithFormat:localizeString(@"view_play_times"), sourceModel.plays];
    NSString *scoreString = [NSString stringWithFormat:localizeString(@"view_play_score"), sourceModel.score];
    NSString *praiseString = [NSString stringWithFormat:localizeString(@"view_play_praise"), sourceModel.praise];
    NSString *detailString = playsString;
    detailString = [detailString stringByAppendingString:[NSString stringWithFormat:@"%@%@", (detailString.length > 0) ? @"，" : @"", scoreString]];
    detailString = [detailString stringByAppendingString:[NSString stringWithFormat:@"%@%@", (detailString.length > 0) ? @"，" : @"", praiseString]];
    self.detailAttribute = formatAttributedStringByORFontGuide(@[detailString, @"DGY13N"], nil);
    size = getSizeForAttributedString(self.detailAttribute, kVideoDetailHeadwCellWidth - kVideoDetailHeadwCellLRPadding*2, MAXFLOAT);
    self.detailFrame = CGRectMake(kVideoDetailHeadwCellLRPadding, CGRectGetMaxY(self.titleFrame) + 5, kVideoDetailHeadwCellWidth - kVideoDetailHeadwCellLRPadding*2, size.height);
    
    self.cellHeight = CGRectGetMaxY(self.detailFrame) + 20 + kVideoDetailHeadwCellIconHeight + kVideoDetailHeadwCellTBPadding;
}

@end
