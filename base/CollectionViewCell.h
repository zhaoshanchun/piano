//
//  CollectionViewCell.h
//  huazhuangjiaocheng
//
//  Created by kun on 2017/6/10.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *playTime;
@property (nonatomic, strong) UIActivityIndicatorView *loading;
@property (nonatomic, strong) UIView *bottom;
@property long itemIndex;

@end
