//
//  HistoryListView.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryListCollectionViewCell.h"

@protocol HistoryListViewDelegate <NSObject>

- (void)selectedHistory:(ContentModel *)contentModel;

@end

@interface HistoryListView : UIView

@property (weak, nonatomic) id<HistoryListViewDelegate> delegate;
@property (strong, nonatomic) NSArray *historyList;

- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
- (instancetype)init:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
