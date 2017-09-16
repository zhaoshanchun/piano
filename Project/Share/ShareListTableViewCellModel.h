//
//  ShareListTableViewCellModel.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/16.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareModel.h"

#define kShareListTableViewCellWidth SCREEN_WIDTH
#define kShareListTableViewCellTBPadding 10.f
#define kShareListTableViewCellLRPadding 10.f
#define kShareListTableViewCellPlayViewWidth (kShareListTableViewCellWidth - kShareListTableViewCellLRPadding*2)
#define kShareListTableViewCellPlayViewHeight (kShareListTableViewCellPlayViewWidth*9)/16

@interface ShareListTableViewCellModel : NSObject

@property (strong, nonatomic) ShareModel *shareModel;

@property (assign, nonatomic) CGRect contentFrame;
@property (strong, nonatomic) NSAttributedString *contentAttribute;
@property (assign, nonatomic) CGRect detailFrame;
@property (strong, nonatomic) NSAttributedString *detailAttribute;
@property (assign, nonatomic) CGRect playViewFrame;
@property (assign, nonatomic) CGRect titleFrame;
@property (strong, nonatomic) NSAttributedString *titleAttribute;

@property (assign, nonatomic) CGFloat cellHeight;

@end
