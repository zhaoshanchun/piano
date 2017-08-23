//
//  APIManager.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking.h"


#define kUser @"user"
#define kPassword @"password"
#define kAlias @"alias"
#define kPhone @"phone"
#define kMail @"mail"
#define kCode @"code"


typedef void (^ApiResponseHandler)(id *model, NSInteger statusCode, NSError *err);

@interface APIManager : NSObject

//- (NSURLSessionDataTask *)getData:(ApiResponseHandler)handler;


@end
