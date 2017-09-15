//
//  ProfileUserTableViewCellModel.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/26.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"


#define kProfileUserTableViewCellWidth SCREEN_WIDTH
#define kProfileUserTableViewCellLRMargin kCellDefaultLRMargin
#define kProfileUserTableViewCellTBMargin kCellDefaultTBMargin

#define kProfileUserTableViewCellAvatarSize 44.f


@interface ProfileUserTableViewCellModel : NSObject

@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) UserModel *userModel;

@property (strong, nonatomic) NSAttributedString *mainAttribute;
@property (strong, nonatomic) NSAttributedString *detailAttribute;

@property (assign, nonatomic) CGRect avatarImageFrame;
@property (assign, nonatomic) CGRect mainTitleFrame;
@property (assign, nonatomic) CGRect detailFrame;
@property (assign, nonatomic) CGRect rightImageFrame;

@property (assign, nonatomic) CGFloat cellHeight;

@end
