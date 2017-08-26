//
//  ProfileUserTableViewCellModel.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/26.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ProfileUserTableViewCellModel.h"

@implementation ProfileUserTableViewCellModel

- (id)init {
    self = [super init];
    if (self) {
        self.cellHeight = kCellDefaultHeight;
        
        self.mainAttribute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_login"), @"BR15N"], nil);
        CGFloat titleWidth = kProfileUserTableViewCellWidth - kProfileUserTableViewCellLRMargin*2 - kCellDefaultAccessWidth - 10;
        NSLog(@"titleWidth = %f", titleWidth);
        CGSize size = getSizeForAttributedString(self.mainAttribute, titleWidth, CGFLOAT_MAX);
        self.mainTitleFrame = CGRectMake(kProfileUserTableViewCellLRMargin, (self.cellHeight - size.height)/2, titleWidth, size.height);
        
        self.rightImageFrame = CGRectMake(kProfileUserTableViewCellWidth - kProfileUserTableViewCellLRMargin - kCellDefaultAccessWidth, (self.cellHeight - kCellDefaultAccessHeight)/2, kCellDefaultAccessWidth, kCellDefaultAccessHeight);
    }
    return self;
}

- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    if (self.userModel == nil) {
        self.cellHeight = kCellDefaultHeight;
        
        self.mainAttribute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_login"), @"BR15N"], nil);
        CGFloat titleWidth = kProfileUserTableViewCellWidth - kProfileUserTableViewCellLRMargin*2 - kCellDefaultAccessWidth - 10;
        NSLog(@"titleWidth = %f", titleWidth);
        CGSize size = getSizeForAttributedString(self.mainAttribute, titleWidth, CGFLOAT_MAX);
        self.mainTitleFrame = CGRectMake(kProfileUserTableViewCellLRMargin, (self.cellHeight - size.height)/2, titleWidth, size.height);
        
        self.rightImageFrame = CGRectMake(kProfileUserTableViewCellWidth - kProfileUserTableViewCellLRMargin - kCellDefaultAccessWidth, (self.cellHeight - kCellDefaultAccessHeight)/2, kCellDefaultAccessWidth, kCellDefaultAccessHeight);
    } else {
        self.avatarImageFrame = CGRectMake(kProfileUserTableViewCellLRMargin, kProfileUserTableViewCellTBMargin, kProfileUserTableViewCellAvatarSize, kProfileUserTableViewCellAvatarSize);
        
        self.mainAttribute = formatAttributedStringByORFontGuide(@[userModel.userName, @"BR16B"], nil);
        CGFloat titleWidth = kProfileUserTableViewCellWidth - kProfileUserTableViewCellLRMargin - kCellDefaultAccessWidth - 10   - CGRectGetMaxX(self.avatarImageFrame) - 10;
        NSLog(@"titleWidth = %f", titleWidth);
        CGSize size = getSizeForAttributedString(self.mainAttribute, titleWidth, CGFLOAT_MAX);
        self.mainTitleFrame = CGRectMake(CGRectGetMaxX(self.avatarImageFrame) + 10, kProfileUserTableViewCellTBMargin, titleWidth, MIN(getFontByKey(@"BR16B").lineHeight*2, size.height));
        
        self.detailAttribute = formatAttributedStringByORFontGuide(@[userModel.fullName, @"BR14N"], nil);
        size = getSizeForAttributedString(self.detailAttribute, titleWidth, CGFLOAT_MAX);
        self.detailFrame = CGRectMake(CGRectGetMinX(self.mainTitleFrame), CGRectGetMaxY(self.mainTitleFrame) + 5, titleWidth, MIN(getFontByKey(@"BR14N").lineHeight*2, size.height));
        
        self.cellHeight = MAX(CGRectGetMaxY(self.avatarImageFrame), CGRectGetMaxY(self.detailFrame)) + kProfileUserTableViewCellTBMargin;
        self.rightImageFrame = CGRectMake(kProfileUserTableViewCellWidth - kProfileUserTableViewCellLRMargin - kCellDefaultAccessWidth, (self.cellHeight - kCellDefaultAccessHeight)/2, kCellDefaultAccessWidth, kCellDefaultAccessHeight);
    }
}

@end
