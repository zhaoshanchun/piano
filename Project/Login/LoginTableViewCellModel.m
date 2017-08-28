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
    switch (self.loginCellellType) {
        case LoginTableViewCellUserName:
        case LoginTableViewCellFullName:
        case LoginTableViewCellPassWord:
        case LoginTableViewCellConfirmPassWord:
        case LoginTableViewCellPhone:
        case LoginTableViewCellMail: {
            CGSize size = getSizeForAttributedString(self.titleAttriute, kLoginTableViewCellTitleWidth, MAXFLOAT);
            self.titleFrame = CGRectMake(kLoginTableViewCellLRMargin, topMargin, kLoginTableViewCellTitleWidth, size.height);
            self.inputFrame = CGRectMake(CGRectGetMaxX(self.titleFrame) + 10, topMargin, kLoginTableViewCellWidth - kLoginTableViewCellLRMargin - (CGRectGetMaxX(self.titleFrame) + 10), kLoginTableViewCellInputHeight);
            self.cellHeight = CGRectGetMaxY(self.titleFrame) + bottomMargin;
            
            if (CGRectGetMaxY(self.inputFrame) > CGRectGetMaxY(self.titleFrame)) {
                CGFloat margin = CGRectGetHeight(self.inputFrame) - CGRectGetHeight(self.titleFrame);
                self.titleFrame = CGRectMake(CGRectGetMinX(self.titleFrame), CGRectGetMinY(self.titleFrame) + margin/2, CGRectGetWidth(self.titleFrame), CGRectGetHeight(self.titleFrame));
                self.cellHeight = CGRectGetMaxY(self.inputFrame) + bottomMargin;
            }
        }
        break;
        case LoginTableViewCellVerification: {
            CGSize size = getSizeForAttributedString(self.titleAttriute, kLoginTableViewCellTitleWidth, MAXFLOAT);
            self.titleFrame = CGRectMake(kLoginTableViewCellLRMargin, topMargin, kLoginTableViewCellTitleWidth, size.height);
            
            self.verificationFrame = CGRectMake(kLoginTableViewCellWidth - kLoginTableViewCellLRMargin - kVerificationWidth, topMargin + (kLoginTableViewCellInputHeight - kVerificationHeight)/2, kVerificationWidth, kVerificationHeight);
            self.inputFrame = CGRectMake(CGRectGetMaxX(self.titleFrame) + 10, topMargin, CGRectGetMinX(self.verificationFrame) - 10 - CGRectGetMaxX(self.titleFrame) - 10, kLoginTableViewCellInputHeight);
            self.cellHeight = CGRectGetMaxY(self.titleFrame) + bottomMargin;
            
            if (CGRectGetMaxY(self.inputFrame) > CGRectGetMaxY(self.titleFrame)) {
                CGFloat margin = CGRectGetHeight(self.inputFrame) - CGRectGetHeight(self.titleFrame);
                self.titleFrame = CGRectMake(CGRectGetMinX(self.titleFrame), CGRectGetMinY(self.titleFrame) + margin/2, CGRectGetWidth(self.titleFrame), CGRectGetHeight(self.titleFrame));
                self.cellHeight = CGRectGetMaxY(self.inputFrame) + bottomMargin;
            }
        }
            break;
        
        default:
            break;
    }
}

@end
