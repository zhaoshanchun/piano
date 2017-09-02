//
//  ContentListCollectionViewCellModel.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/1.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>


// 每行显示多少个视频
#define kContentListCollectionViewCellWidth SCREEN_WIDTH
#define kContentListItemNumber 2
#define kContentListItemMargin 10.f
#define kContentListItemTextHeight 45 // 45 是留给下面文字部分的高度
#define kContentListItemWidth (kContentListCollectionViewCellWidth - kContentListItemMargin*(kContentListItemNumber+1))/kContentListItemNumber
#define kContentListItemImageHeight (kContentListItemWidth*9/16)    // 视频截图 16：9
#define kContentListItemHeight (kContentListItemImageHeight + kContentListItemTextHeight)
#define kContentListItemBottomPadding 10.f

@interface ContentListCollectionViewCellModel : NSObject

@property (assign, nonatomic) CGSize size;
@property (strong, nonatomic) NSString *imageUrl;
@property (assign, nonatomic) CGRect imageFrame;
@property (strong, nonatomic) NSAttributedString *titleAttribute;
@property (assign, nonatomic) CGRect titleFrame;
@property (strong, nonatomic) NSAttributedString *detailAttribute;
@property (assign, nonatomic) CGRect detialFrame;

@end
