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
#define kShareListTableViewCellMidMargin 10.f
#define kShareListTableViewCellLPadding 10.f
#define kShareListTableViewCellRPadding 15.f
#define kShareListTableViewCellPlayViewWidth (kShareListTableViewCellWidth - kShareListTableViewCellLPadding - kShareListTableViewCellRPadding)
#define kShareListTableViewCellPlayViewHeight (kShareListTableViewCellPlayViewWidth*9)/16

#define kPublicShareCellAvatarSize 44.f

#define PublicShareCellHeight (SCREEN_WIDTH*9)/16
#define PublicShareCellImageHeight PublicShareCellHeight

@interface PublicShareCellModel : NSObject

@property (strong, nonatomic) ShareModel *shareModel;
@property (assign, nonatomic) CGFloat cellHeight;

@property (assign, nonatomic) CGRect avatarImageFrame;

@property (assign, nonatomic) CGRect userNameTitleFrame;
@property (strong, nonatomic) NSAttributedString *userNameAttribute;

@property (assign, nonatomic) CGRect contentFrame;
@property (strong, nonatomic) NSAttributedString *contentAttribute;

@property (strong, nonatomic) NSAttributedString *titleAttribute;
@property (assign, nonatomic) CGRect titleFrame;

@property (strong, nonatomic) NSAttributedString *timeAttribute;
@property (assign, nonatomic) CGRect timeFrame;

@property (assign, nonatomic) CGRect playViewFrame;


- (NSString *)iconUrl;

@end
