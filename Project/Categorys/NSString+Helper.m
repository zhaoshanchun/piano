//
//  NSString+Helper.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/15.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

+ (NSString *)base64EncodedForString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
