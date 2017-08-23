//
//  LoginTableViewCellModel.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/23.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLoginTableViewCellWidth SCREEN_WIDTH
#define kLoginTableViewCellLRMargin 15.f
#define kLoginTableViewCellTBMargin 15.f
#define kLoginTableViewCellTitleWidth 80.f
#define kLoginTableViewCellInputHeight 30.f

typedef enum {
    LoginTableViewCellNormal,   // title + input
    LoginTableViewCellMail,     // 右边有一个选择邮箱类型的开关
    LoginTableViewCellVerification, // 验证码
} LoginTableViewCellType;


@interface LoginTableViewCellModel : NSObject

@property (assign, nonatomic) BOOL isFirstCell;
@property (assign, nonatomic) BOOL isLastCell;
@property (assign, nonatomic) LoginTableViewCellType loginCellellType;
@property (strong, nonatomic) NSAttributedString *titleAttriute;
@property (strong, nonatomic) NSString *imageUrl;
@property (assign, nonatomic) CGFloat cellHeight;

@property (assign, nonatomic) CGRect titleFrame;
@property (assign, nonatomic) CGRect inputFrame;
@property (assign, nonatomic) CGRect verificationFrame;
@property (strong, nonatomic) NSString *placeHolder;
@property (strong, nonatomic) NSString *inputContent;

- (id)initWithType:(LoginTableViewCellType)loginCellType;
- (void)updateFrame;

@end
