//
//  ContentListCollectionViewCell.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/1.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentListCollectionViewCellModel.h"

#define kContentListCollectionViewCellIdentifier @"kContentListCollectionViewCellIdentifier"

@interface ContentListCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) ContentListCollectionViewCellModel *cellModel;

@end
