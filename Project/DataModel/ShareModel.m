//
//  ShareModel.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/15.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ShareModel.h"


@implementation ShareListModel

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"error": @"errorCode",
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end


@implementation ShareModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end
