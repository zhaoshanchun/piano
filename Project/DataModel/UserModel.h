//
//  UserModel.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/26.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <JSONModel/JSONModel.h>


typedef enum {
    UserLoginStatusUnLogin,
    UserLoginStatusLogined
} UserLoginStatus;


@interface UserModel : JSONModel <NSCoding>

@property (assign, nonatomic) NSInteger userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *email;

@end
@protocol UserModel <NSObject>
@end


@interface LoginResponseModel : JSONModel

@property (assign, nonatomic) NSInteger errorCode;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) UserModel *user;

// {"msg":"successful","user":{"mail":"594935658@qq.com","user":"kunhuang","alias":"kk","phone":"18688934656","icon":"9934827abb16e007a149e0c930cd603a"},"error":0}

@end
@protocol LoginResponseModel <NSObject>
@end

