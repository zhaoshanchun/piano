//
//  VideoDetailCommentCellModel.h
//  apps
//
//  Created by zhaosc on 2017/10/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentListModel.h"


#define kVideoDetailCommentCellWidth SCREEN_WIDTH
#define kVideoDetailCommentCellTBPadding 10.f
#define kVideoDetailCommentCellLRPadding 10.f
#define kVideoDetailCommentCellHMidMargin 10.f
#define kVideoDetailCommentCellVMidMargin 5.f
#define kVideoDetailCommentCellImageWidth 30.f


@interface VideoDetailCommentCellModel : NSObject

@property (strong, nonatomic) CommentModel *commentModel;

@property (strong, nonatomic) NSString *imageUrl;
@property (assign, nonatomic) CGRect imageFrame;

@property (strong, nonatomic) NSAttributedString *userNameAttribute;
@property (assign, nonatomic) CGRect userNameFrame;

@property (strong, nonatomic) NSAttributedString *commentAttribute;
@property (assign, nonatomic) CGRect commentFrame;

@property (strong, nonatomic) NSAttributedString *timeAttribute;
@property (assign, nonatomic) CGRect timeFrame;

@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) BOOL isLastOne;

@end
