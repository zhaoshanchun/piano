//
//  DownloadFile.m
//  sifakaoshi
//
//  Created by kun on 2017/9/4.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "DownloadFile.h"

@interface DownloadObject : NSObject

@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, copy) NSString *filename;
@property int seg;
@property NSString *uuid;

@end


@implementation DownloadObject

@end

@interface DownloadFile()

@property (nonatomic, strong) NSMutableDictionary *sessions;
@property (nonatomic, strong) NSMutableDictionary *tasks;
//@property dispatch_semaphore_t semaphore;
@end

@implementation DownloadFile

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.sessions = [NSMutableDictionary dictionary];
        self.tasks = [NSMutableDictionary dictionary];
        //self.semaphore = dispatch_semaphore_create(0);
    }
    return self;
}

-(void)dealloc
{
    
}

- (void)download:(NSString *)uuid seg:(int)seg file:(NSString *)filename url:(NSString *)url
{
    NSURLSessionDataTask *task = [self.tasks objectForKey:filename];
    if(task)
        return;
    
    NSURLSessionConfiguration *sessionConfig=[NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 5.0f;//请求超时时间
    sessionConfig.allowsCellularAccess=true;//是否允许蜂窝网络缓存（2G/3G/4G）
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    // 创建流
    //NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:filename append:YES];
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    task = [session dataTaskWithRequest:request];
    NSUInteger taskIdentifier = arc4random() % ((arc4random() % 10000 + arc4random() % 10000));
    [task setValue:@(taskIdentifier) forKeyPath:@"taskIdentifier"];
    
    DownloadObject *object = [[DownloadObject alloc] init];
    object.data = [[NSMutableData alloc] init];
    object.filename = filename;
    object.seg = seg;
    object.uuid = uuid;
    [self.sessions setObject:object forKey:@(taskIdentifier).stringValue];
    [self.tasks setObject:task forKey:filename];
    [task resume];
    //NSLog(@"start dowload %@", uuid);
    //dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);  //等待
}

- (void)pause:(NSString *)filename
{
    NSURLSessionDataTask *task = [self.tasks objectForKey:filename];
    if(task)
    {
        [task suspend];
    }
}

#pragma mark - 代理
#pragma mark NSURLSessionDataDelegate
/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 获得服务器这次请求 返回数据的总长度
    NSInteger totalLength = [response.allHeaderFields[@"Content-Length"] integerValue];
    // 接收这个请求，允许接收服务器的数据
    //NSLog(@"total size %lu", (long)totalLength);

    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    DownloadObject *object = [self.sessions objectForKey:@(dataTask.taskIdentifier).stringValue];
    // 写入数据
    //NSLog(@"--------->uuid: %@", object.uuid);
    [object.data appendData:data];
    if(self.delegate)
    {
        [self.delegate receive_byte:object.uuid seg:object.seg byte:data.length];
    }
}

/**
 * 请求完毕（成功|失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    DownloadObject *object = [self.sessions objectForKey:@(task.taskIdentifier).stringValue];
    
    if(!error)
    {
        [object.data writeToFile:object.filename atomically:YES];
        if(self.delegate)
        {
            [self.delegate download_state:object.uuid seg:object.seg state:DownloadStateCompleted];
        }
    }
    else
    {
        NSLog(@"didCompleteWithError: %@", error);
        [self.delegate download_state:object.uuid seg:object.seg state:DownloadStateFailed];
    }
    // 清除任务
    //dispatch_semaphore_signal(self.semaphore);   //发送信号
    [self.tasks removeObjectForKey:object.filename];
    [self.sessions removeObjectForKey:@(task.taskIdentifier).stringValue];
    
}

@end
