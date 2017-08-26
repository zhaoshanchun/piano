//
//  UserModel.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/26.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

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
        self.email = [decoder decodeObjectForKey:@"email"];
    }
    return  self;
}

@end
