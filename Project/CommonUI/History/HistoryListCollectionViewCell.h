//
//  HistoryListCollectionViewCell.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryListCollectionViewCellModel.h"

#define kHistoryListCollectionViewCellIdentifier @"kHistoryListCollectionViewCellIdentifier"

@interface HistoryListCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) HistoryListCollectionViewCellModel *cellModel;

@end
