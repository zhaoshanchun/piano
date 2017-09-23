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
#import "UIImage+Helper.h"
#import "NSString+Helper.h"
#import "UserModel.h"

@interface APIManager ()

@end

@implementation APIManager

+ (NSOperationQueue *)queue {
    static NSOperationQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [NSOperationQueue new];
    });
    return queue;
}

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
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
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
    [serializer setTimeoutInterval:60];
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


+ (void)requestWithApi:(NSString *)api
            httpMethod:(NSString *)httpMethod
              httpBody:(NSString *)httpBody
       responseHandler:(ResponseHndler )handler {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", kHTTPHomeAddress, api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.timeoutInterval = kHTTPTimeoutInterval;
    request.HTTPMethod = httpMethod;
    if (httpBody.length > 0) {
        request.HTTPBody = [httpBody dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[APIManager queue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(response, data, connectionError);
            });
        }
    }];
}


+ (void)postImageWithApI:(NSString *)apiName
                   image:(UIImage *)image
         responseHandler:(ResponseHndler )handler {
    
    static NSString *boundary=@"AlvinLeonPostRequest";  // 头尾结束符
    
    NSString *userName = @"";   // User Name
    NSData *userModelData = (NSData *)getObjectFromUserDefaults(kLoginedUser);
    if (userModelData) {
        UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:userModelData];
        if (userModel) {
            userName = userModel.userName;
        }
    }
    
    // 压缩并转换成为二进制数据
    NSData *imageData = UIImageJPEGRepresentation([UIImage fixOrientation:image], 0.01);
    MyLog(@" ---- img len: %lu  ---- \n", (unsigned long)imageData.length);
    
    
    // 拼接请求体数据(1-6步)
    NSMutableData *requestMutableData = [NSMutableData data];
    
    // 1.\r\n--Boundary+72D4CD655314C423\r\n   // 分割符，以“--”开头，后面的字随便写，只要不写中文即可
    NSMutableString *myString=[NSMutableString stringWithFormat:@"\r\n--%@\r\n", boundary];
    
    // 2. Content-Disposition: form-data; name="uploadFile"; filename="001.png"\r\n  // 这里注明服务器接收图片的参数（类似于接收用户名的userName）及服务器上保存图片的文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";   // 上传时使用当前的系统时间作为文件名
    NSString *fileName = [NSString stringWithFormat:@"%@.png", [formatter stringFromDate:[NSDate date]]];
    [myString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; user=\"%@\";name=\"uploadFile\"; filename=\"%@\"\r\n", userName, fileName]];
    
    // 3. Content-Type:image/png \r\n  // 图片类型为png
    [myString appendString:[NSString stringWithFormat:@"Content-Type:multipart/form-data\r\n"]];
    [myString appendString:[NSString stringWithFormat:@"key: %@\r\n", [NSString base64EncodedForString:[NSString stringWithFormat:@"icon%@", userName]]]];
    
    // 4. Content-Transfer-Encoding: binary\r\n\r\n  // 编码方式
    [myString appendString:@"Content-Transfer-Encoding: binary\r\n\r\n"];
    MyLog(@"myString = %@", myString);
    
    
    // 请求体转换成为二进制数据
    [requestMutableData appendData:[myString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 5.文件数据部分
    [requestMutableData appendData:imageData];
    
    //6. \r\n--Boundary+72D4CD655314C423--\r\n  // 分隔符后面以"--"结尾，表明结束
    [requestMutableData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kHTTPHomeAddress, apiName]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2.0f];
    request.HTTPMethod = kHTTPMethodPost;       // 设置请求方法是POST
    request.timeoutInterval = kHTTPPostTimeoutInterval;    // 设置请求超时
    request.HTTPBody = requestMutableData;
    [request setValue:[NSString stringWithFormat:@"Content-Type multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];  //设置请求头
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[APIManager queue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(response, data, connectionError);
            });
        }
    }];
}


@end


