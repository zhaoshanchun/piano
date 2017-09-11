//
//  VideoDetailHistoryCell.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "UIBaseTableViewCell.h"
#import "HistoryListView.h"

#define kVideoDetailHistoryCellIdentifier @"kVideoDetailHistoryCellIdentifier"

@interface VideoDetailHistoryCell : UIBaseTableViewCell

@property (strong, nonatomic) HistoryListView *historyView;

@end
