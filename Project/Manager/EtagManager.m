//
//  EtagManager.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/8.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "EtagManager.h"
#import "TFHpple.h"

@interface EtagManager ()

@property (nonatomic, strong) EtagBackHndler etagBackHandler;

@end


@implementation EtagManager

static EtagManager *_sharedManager;

+ (EtagManager *)sharedManager {
    @synchronized(self) {
        if (!_sharedManager) {
            _sharedManager = [[EtagManager alloc] init];
        }
    }
    return _sharedManager;
}

- (void)getEtagWithHandler:(EtagBackHndler)handler {
    self.etagBackHandler = handler;
    if (getObjectFromUserDefaults(kSourceEtagCacheTime)) {
        NSDate *cacheDate = (NSDate *)getObjectFromUserDefaults(kSourceEtagCacheTime);
        NSTimeInterval timeIntervalPassed = [[NSDate new] timeIntervalSince1970] - [cacheDate timeIntervalSince1970];
        if (timeIntervalPassed < 15*24*60*60) {
            // Etag 十五天更新一次
            if (getObjectFromUserDefaults(kSourceEtag)) {
                NSString *etag = (NSString *)getObjectFromUserDefaults(kSourceEtag);
                self.etagBackHandler(etag, nil);
                return;
            }
        }
    }
    
    [self analysisCookie];
}

- (void)analysisCookie {
    NSURL *url = [NSURL URLWithString:@"https://log.mmstat.com/eg.js"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
                                                NSString *etag = headers[@"Etag"];
                                                etag = [etag stringByReplacingOccurrencesOfString:@"/" withString:@""];
                                                
                                                if (error == nil && etag.length > 0) {
                                                    saveObjectToUserDefaults(kSourceEtag, etag);
                                                    saveObjectToUserDefaults(kSourceEtagCacheTime, [NSDate date]);
                                                    if (weakSelf.etagBackHandler) {
                                                        weakSelf.etagBackHandler(etag, nil);
                                                    }
                                                } else {
                                                    saveObjectToUserDefaults(kSourceEtag, nil);
                                                    saveObjectToUserDefaults(kSourceEtagCacheTime, nil);
                                                    if (weakSelf.etagBackHandler) {
                                                        weakSelf.etagBackHandler([NSString stringWithFormat:@"%f", [[NSDate new] timeIntervalSince1970]], nil);
                                                    }
                                                }
                                            }];
    //5.执行任务
    [dataTask resume];
}


@end


