//
//  VideoDetailMoreVideoCellModel.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/8.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentListModel.h"

#define kVideoDetailMoreVideoCellWidth SCREEN_WIDTH
#define kVideoDetailMoreVideoCellTBPadding 10.f
#define kVideoDetailMoreVideoCellLRPadding 10.f
#define kVideoDetailMoreVideoCellImageHeight 50.f
#define kVideoDetailMoreVideoCellImageWidth (kVideoDetailMoreVideoCellImageHeight*16)/9

@interface VideoDetailMoreVideoCellModel : NSObject

@property (strong, nonatomic) ContentModel *contentModel;

@property (strong, nonatomic) NSString *imageUrl;
@property (assign, nonatomic) CGRect imageFrame;
@property (strong, nonatomic) NSAttributedString *titleAttribute;
@property (assign, nonatomic) CGRect titleFrame;

@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) BOOL isLastOne;

@end
