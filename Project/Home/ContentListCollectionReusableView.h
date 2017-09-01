//
//  ContentListCollectionReusableView.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/1.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentListCollectionViewCellModel.h"

#define kContentListCollectionReusableViewIdentifier @"kContentListCollectionReusableViewIdentifier"
#define kContentListCollectionReusableViewHeight 50.f
#define kContentListCollectionReusableViewWidth SCREEN_WIDTH


@protocol ContentListCollectionReusableViewDelegate <NSObject>

- (void)moreButtonAction:(NSIndexPath *)indexPath;

@end

@interface ContentListCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) id<ContentListCollectionReusableViewDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSString *title;

@end
