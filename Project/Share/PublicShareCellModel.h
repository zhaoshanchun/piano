//
//  PublicShareCellModel.h
//  CLPlayerDemo
//
//  Created by JmoVxia on 2017/8/4.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareModel.h"

#define kShareListTableViewCellWidth SCREEN_WIDTH
#define kShareListTableViewCellTBPadding 10.f
#define kShareListTableViewCellLRPadding 10.f
#define kShareListTableViewCellPlayViewWidth (kShareListTableViewCellWidth - kShareListTableViewCellLRPadding*2)
#define kShareListTableViewCellPlayViewHeight (kShareListTableViewCellPlayViewWidth*9)/16

#define PublicShareCellHeight (SCREEN_WIDTH*9)/16
#define PublicShareCellImageHeight PublicShareCellHeight

@interface PublicShareCellModel : NSObject

@property (strong, nonatomic) ShareModel *shareModel;
@property (assign, nonatomic) CGFloat cellHeight;

@property (assign, nonatomic) CGRect contentFrame;
@property (strong, nonatomic) NSAttributedString *contentAttribute;
@property (assign, nonatomic) CGRect detailFrame;
@property (strong, nonatomic) NSAttributedString *detailAttribute;
@property (assign, nonatomic) CGRect playViewFrame;
@property (assign, nonatomic) CGRect titleFrame;
@property (strong, nonatomic) NSAttributedString *titleAttribute;

- (NSString *)iconUrl;

@end
