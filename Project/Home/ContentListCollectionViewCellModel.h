//
//  ContentListCollectionViewCellModel.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/1.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>


// 每行显示多少个视频
#define kContentListItemNumber 4
#define kContentListCollectionViewCellWidth SCREEN_WIDTH
#define kContentListItemMargin 10.f
#define kContentListItemWidth (kContentListCollectionViewCellWidth - kContentListItemMargin*3 - (kContentListItemMargin*1.5)*2)/kContentListItemNumber
#define kContentListItemHeight 100

@interface ContentListCollectionViewCellModel : NSObject

@property (assign, nonatomic) CGSize size;
@property (strong, nonatomic) NSString *imageUrl;
@property (assign, nonatomic) CGRect imageFrame;
@property (strong, nonatomic) NSAttributedString *titleAttribute;
@property (assign, nonatomic) CGRect titleFrame;
@property (strong, nonatomic) NSAttributedString *detailAttribute;
@property (assign, nonatomic) CGRect detialFrame;

@end
