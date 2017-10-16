//
//  UserModel.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/26.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

// {"msg":"successful","user":{"mail":"594935658@qq.com","user":"kunhuang","alias":"kk","phone":"18688934656","icon":"9934827abb16e007a149e0c930cd603a"},"error":0}
+(JSONKeyMapper*)keyMapper {
    // 左边是api返回的字段 : 右边是我们Model中匹配的字段
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"user": @"userName",
                                                       @"alias": @"fullName",
                                                       @"phone": @"phone",
                                                       @"icon": @"icon",
                                                       @"mail": @"email",
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt64:self.userId forKey:@"userId"];
    if (self.userName.length > 0) {
        [encoder encodeObject:self.userName forKey:@"userName"];
    }
    if (self.fullName.length > 0) {
        [encoder encodeObject:self.fullName forKey:@"fullName"];
    }
    if (self.phone.length > 0) {
        [encoder encodeObject:self.phone forKey:@"phone"];
    }
    if (self.icon.length > 0) {
        [encoder encodeObject:self.icon forKey:@"icon"];
    }
    if (self.email.length > 0) {
        [encoder encodeObject:self.email forKey:@"email"];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.userId = [decoder decodeInt64ForKey:@"userId"];
        self.userName = [decoder decodeObjectForKey:@"userName"];
        self.fullName = [decoder decodeObjectForKey:@"fullName"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.icon = [decoder decodeObjectForKey:@"icon"];
        self.email = [decoder decodeObjectForKey:@"email"];
    }
    return  self;
}

@end


@implementation LoginResponseModel

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"user": @"user",
                                                       @"error": @"errorCode",
                                                       @"msg": @"message",
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end


@implementation UploadPhotoResponseModel

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"error": @"errorCode",
                                                       @"msg": @"message",
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end
