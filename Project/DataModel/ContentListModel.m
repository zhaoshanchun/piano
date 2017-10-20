//
//  ContentListModel.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/2.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ContentListModel.h"


@implementation ContentModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end


@implementation ContentListModel

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"error": @"errorCode",
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end


@implementation ClassifyModel

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"classify_name": @"classifyName",
                                                       @"classify_id": @"classifyId",
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end


@implementation SourceModel

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"video_uri": @"videoUri",
                                                       @"comment_id": @"commentId",
                                                       @"bad_review": @"badReview",
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end


@implementation SourceResponseModel

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"error": @"errorCode",
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end



@implementation CommentModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (NSString *)iconUrl {
    if (self.icon.length > 0) {
        return [NSString stringWithFormat:@"%@/%@%@", kHTTPHomeAddress, kAPIGetImage, self.icon];
    }
    return @"";
}

@end


@implementation CommentListModel

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"error": @"errorCode",
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

