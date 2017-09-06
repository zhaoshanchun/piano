//
//  VideoDetailHeadwCellModel.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/6.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentListModel.h"


#define kVideoDetailHeadwCellWidth SCREEN_WIDTH
#define kVideoDetailHeadwCellTBPadding 10.f
#define kVideoDetailHeadwCellLRPadding 10.f
#define kVideoDetailHeadwCellIconWidth 20.f
#define kVideoDetailHeadwCellIconHeight 20.f
#define kVideoDetailHeadwCellIconMargin 30.f


@interface VideoDetailHeadwCellModel : NSObject

@property (strong, nonatomic) SourceModel *sourceModel;

@property (strong, nonatomic) NSAttributedString *titleAttribute;
@property (assign, nonatomic) CGRect titleFrame;

@property (strong, nonatomic) NSAttributedString *detailAttribute;
@property (assign, nonatomic) CGRect detailFrame;

@property (assign, nonatomic) CGFloat cellHeight;

//@property (assign, nonatomic) CGRect commonFrame;
//@property (assign, nonatomic) CGRect shareFrame;
//@property (assign, nonatomic) CGRect downLoadFrame;
//@property (assign, nonatomic) CGRect praiseFrame;

@end
