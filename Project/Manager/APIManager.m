//
//  APIManager.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "APIManager.h"
#import "AFURLRequestSerialization.h"
#import "AFHTTPSessionManager.h"

@implementation APIManager


//- (NSURLSessionDataTask *)getData:(ApiResponseHandler)handler {
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//
//    NSURL *URL = [NSURL URLWithString:@"http://httpbin.org/get"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            NSLog(@"%@ %@", response, responseObject);
//        }
//    }];
//    [dataTask resume];
//    return dataTask;
//}

+ (void)downloadWithUrl:(NSString *)url completedHandler:(DownLoadResponseHandler)handler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if (handler) {
            handler(response, filePath, error);
        }
    }];
    [downloadTask resume];
}


+ (NSURLSessionDataTask *)requestWithApi:(NSString *)url
                               apiMethod:(APIMethod)apiMethod
                               andParams:(id)params
                           progressBlock:(void (^)(NSProgress *progress))progress
                       completionHandler:(ApiResponseHandler)handler {

    AFHTTPRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setTimeoutInterval:30];
    [serializer setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    
//    [serializer setValue:[NSString stringWithFormat:@"Bearer %@", fpMetadataRMLObj.guestToken]
//      forHTTPHeaderField:kRequestHeaderAuthorization];
//    [serializer setValue:fpMetadataRMLObj.apiKey forHTTPHeaderField:kRequestHeaderFPApiKey];
//    [serializer setValue:fpMetadataRMLObj.localizedAcceptLanguage forHTTPHeaderField:kRequestHeaderLanguage];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = serializer;
    
    void (^successBlock)(NSURLSessionDataTask *, id)  = ^(NSURLSessionDataTask *task, id responseObject) {
        if (handler) {
            handler(responseObject, [(NSHTTPURLResponse *)task.response statusCode], nil);
        }
        [manager invalidateSessionCancelingTasks:NO];
    };
    void (^failureBlock)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, NSError *error) {
        if (handler) {
            handler(nil, [(NSHTTPURLResponse *)task.response statusCode], error);
        }
        [manager invalidateSessionCancelingTasks:NO];
    };
    NSURLSessionDataTask *task;
    switch (apiMethod) {
        case APIMethodGet:
            task = [manager GET:url
                     parameters:params
                       progress:progress
                        success:successBlock
                        failure:failureBlock];
            [manager setDataTaskWillCacheResponseBlock:^NSCachedURLResponse *(NSURLSession *session, NSURLSessionDataTask *dataTask, NSCachedURLResponse *proposedResponse) {
                return proposedResponse;
            }];
            break;
        case APIMethodPost:
            task = [manager POST:url
                      parameters:params
                        progress:progress
                         success:successBlock
                         failure:failureBlock];
            break;
        case APIMethodPut:
            task = [manager PUT:url
                     parameters:params
                        success:successBlock
                        failure:failureBlock];
            break;
        case APIMethodDelete:
            task = [manager DELETE:url
                        parameters:params
                           success:successBlock
                           failure:failureBlock];
            break;
        default:
            return nil;
            break;
    }
    [task resume];
    return task;
}

@end
