//
//  APIManager.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking.h"


#define kUserName @"user"
#define kFullName @"alias"
#define kPassword @"password"
#define kAlias @"alias"
#define kPhone @"phone"
#define kMail @"mail"
#define kCode @"code"

#define kRequestHeaderAuthorization @"Authorization"
#define kRequestHeaderLanguage @"Accept-Language"
#define kRequestHeaderUserAgent @"User-Agent"
#define kRequestHeaderImageProfileId @"X-OR-ImageProfileId"
#define kRequestHeaderORChecksum @"X-OR-Checksum"
#define kRequestHeaderDeviceId @"X-DeviceId"
#define kRequestHeaderSendDate @"X-SendDate"
#define kRequestHeaderFPApiKey @"X-FP-API-KEY"

typedef NS_ENUM(NSInteger, APIMethod) {
    APIMethodGet,
    APIMethodPost,
    APIMethodPut,
    APIMethodDelete
};

typedef void (^ApiResponseHandler)(id model, NSInteger statusCode, NSError *err);
typedef void (^DownLoadResponseHandler)(NSURLResponse *response, NSURL *filePath, NSError *error);
typedef void (^ResponseHndler)(NSURLResponse *response, NSData *data, NSError *connectionError);

@interface APIManager : NSObject

+ (NSOperationQueue *)queue;

//- (NSURLSessionDataTask *)getData:(ApiResponseHandler)handler;

+ (void)downloadWithUrl:(NSString *)url completedHandler:(DownLoadResponseHandler)handler;

+ (NSURLSessionDataTask *)requestWithApi:(NSString *)url
                               apiMethod:(APIMethod)apiMethod
                               andParams:(id)params
                           progressBlock:(void (^)(NSProgress *progress))progress
                       completionHandler:(ApiResponseHandler)handler;

+ (void)requestWithApi:(NSString *)api
            httpMethod:(NSString *)httpMethod
              httpBody:(NSString *)httpBody
       responseHandler:(ResponseHndler )handler;

@end



