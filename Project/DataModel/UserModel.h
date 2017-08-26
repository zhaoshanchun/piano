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
@property (strong, nonatomic) NSString *email;

@end
