//
//  LoginTableViewCellModel.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/23.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "LoginTableViewCellModel.h"

@implementation LoginTableViewCellModel

- (id)initWithType:(LoginTableViewCellType)loginCellType {
    self = [super init];
    if (self) {
        _loginCellellType = loginCellType;
    }
    return self;
}

- (void)updateFrame {
    // CGFloat topMargin = self.isFirstCell ? kLoginTableViewCellTBMargin : kLoginTableViewCellTBMargin/2;
    // CGFloat bottomMargin = self.isLastCell ? kLoginTableViewCellTBMargin : kLoginTableViewCellTBMargin/2;
    CGFloat topMargin = kLoginTableViewCellTBMargin;
    CGFloat bottomMargin = kLoginTableViewCellTBMargin;
    
    CGSize size = getSizeForAttributedString(self.titleAttriute, kLoginTableViewCellTitleWidth, MAXFLOAT);
    self.titleFrame = CGRectMake(kLoginTableViewCellLRMargin, topMargin, kLoginTableViewCellTitleWidth, size.height);
    
    switch (self.loginCellellType) {
        case LoginTableViewCellUserName:
        case LoginTableViewCellFullName:
        case LoginTableViewCellPassWord:
        case LoginTableViewCellConfirmPassWord:
        case LoginTableViewCellPhone: {
            self.inputFrame = CGRectMake(CGRectGetMaxX(self.titleFrame) + 10, topMargin, kLoginTableViewCellWidth - kLoginTableViewCellLRMargin - (CGRectGetMaxX(self.titleFrame) + 10), kLoginTableViewCellInputHeight);
            self.cellHeight = CGRectGetMaxY(self.titleFrame) + bottomMargin;
        }
            break;
        case LoginTableViewCellMail: {
            UIImage *image = [UIImage imageNamed:self.isDorpDowning ? @"common_up_arrow" : @"common_down_arrow"];
            CGSize size = getSizeForAttributedString(self.dorpDownTitleAttribute, MAXFLOAT, MAXFLOAT);
            CGFloat width = size.width + 5 + image.size.width;
            self.dorpDownButtonFrame = CGRectMake(kLoginTableViewCellWidth - kLoginTableViewCellLRMargin - width, kLoginTableViewCellTBMargin, width, kLoginTableViewCellInputHeight);
            self.inputFrame = CGRectMake(CGRectGetMaxX(self.titleFrame) + 10, topMargin, CGRectGetMinX(self.dorpDownButtonFrame) - 10 - CGRectGetMaxX(self.titleFrame) - 10, kLoginTableViewCellInputHeight);
            self.cellHeight = CGRectGetMaxY(self.titleFrame) + bottomMargin;
        }
            break;
        case LoginTableViewCellVerification: {
            self.verificationFrame = CGRectMake(kLoginTableViewCellWidth - kLoginTableViewCellLRMargin - kVerificationWidth, topMargin + (kLoginTableViewCellInputHeight - kVerificationHeight)/2, kVerificationWidth, kVerificationHeight);
            self.inputFrame = CGRectMake(CGRectGetMaxX(self.titleFrame) + 10, topMargin, CGRectGetMinX(self.verificationFrame) - 10 - CGRectGetMaxX(self.titleFrame) - 10, kLoginTableViewCellInputHeight);
            self.cellHeight = CGRectGetMaxY(self.titleFrame) + bottomMargin;
        }
            break;
        
        default:
            break;
    }
    
    if (CGRectGetMaxY(self.inputFrame) > CGRectGetMaxY(self.titleFrame)) {
        CGFloat margin = CGRectGetHeight(self.inputFrame) - CGRectGetHeight(self.titleFrame);
        self.titleFrame = CGRectMake(CGRectGetMinX(self.titleFrame), CGRectGetMinY(self.titleFrame) + margin/2, CGRectGetWidth(self.titleFrame), CGRectGetHeight(self.titleFrame));
        self.cellHeight = CGRectGetMaxY(self.inputFrame) + bottomMargin;
    }
}

@end
