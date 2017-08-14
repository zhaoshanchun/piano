//
//  AdCollectionViewCell.h
//  sifakaoshi
//
//  Created by kun on 2017/6/27.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalValue.h"

@protocol AdCollectionViewCellDelegate <NSObject>
/**返回点击代理*/
- (void)onClick:(VideoObject *)object;
@end

@interface AdCollectionViewCell : UICollectionViewCell

@property (nonatomic,weak) id<AdCollectionViewCellDelegate> delegate;

@end
