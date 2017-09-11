//
//  HistoryListCollectionViewCellModel.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentListModel.h"

#define kHistoryListCollectionViewWidth SCREEN_WIDTH
#define kHistoryListItemNumber 3
#define kHistoryListItemMargin 10.f
#define kHistoryListItemWidth (kHistoryListCollectionViewWidth - kHistoryListItemMargin*(kHistoryListItemNumber+1))/kHistoryListItemNumber
#define kHistoryListItemImageHeight (kHistoryListItemWidth*9/16)    // 视频截图 16：9
#define kHistoryListItemHeight (kHistoryListItemImageHeight + kHistoryListItemTextHeight)

@interface HistoryListCollectionViewCellModel : NSObject

@property (strong, nonatomic) ContentModel *contentModel;

@property (assign, nonatomic) CGSize size;
@property (strong, nonatomic) NSString *imageUrl;
@property (assign, nonatomic) CGRect imageFrame;
@property (strong, nonatomic) NSAttributedString *titleAttribute;
@property (assign, nonatomic) CGRect titleFrame;

@end
