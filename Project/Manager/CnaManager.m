//
//  CnaManager.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/8.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "CnaManager.h"
#import "TFHpple.h"

@interface CnaManager ()

@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *Videotitle;
@property (nonatomic, copy) NSString *srcVid;
@property (nonatomic, copy) NSString *htmlUrl;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *clent_id;
@property (nonatomic, strong) NSString *vid;
@property (nonatomic, strong) NSString *ccode;

@end


@implementation CnaManager

static CnaManager *_sharedManager;

+ (CnaManager *)sharedManager {
    @synchronized(self) {
        if (!_sharedManager) {
            _sharedManager = [[CnaManager alloc] init];
        }
    }
    return _sharedManager;
}


//  {@"XODU1MTQ5ODQ0.jpg", @"10分钟学会双手演奏欢乐颂", @"XODU1MTQ5ODQ0", @"11:33", @"0590", @"", @""},
//    object.icon = files[i][0];
//    object.title = files[i][1];
//    object.uid = files[i][2];
//    object.time = files[i][3];
//    object.code = files[i][4];
//    object.clent_id = files[i][5];
//    object.password = files[i][6];
// [self.navigationController pushViewController:[PlayerViewController playerViewControllerWithVideoPath:@"" Title:@"10分钟学会双手演奏欢乐颂" Index:@"XODU1MTQ5ODQ0" Ccode:@"0590"] animated:YES];

//[self.navigationController pushViewController:[PlayerViewController playerViewControllerWithVideoPath:url Title:object.title Index:object.uid Ccode:object.code] animated:YES];
//
//+ (instancetype)playerViewControllerWithVideoPath:(NSString *)videoPath Title:(NSString *)video_title Index:(NSString *)uid Ccode:(NSString *)ccode {
//    PlayerViewController *vc = [PlayerViewController new];
//    vc.title = video_title;
//    vc.Videotitle = video_title;
//    vc.model = 1;
//    vc.vid = uid;
//    vc.ccode = ccode;
//    vc.section = 0;
//    vc.videoPath = videoPath;
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    GlobalValue *globalValue = appDelegate.globalValue;
//    [globalValue historySave:uid];
//    
//    return vc;
//}


- (void)analysisCookie {
    NSURL *url = [NSURL URLWithString:@"https://log.mmstat.com/eg.js"];
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
                                                NSLog(@"%s--->%@ headers %@", __func__, error, headers);
                                                
                                                NSString *cna = headers[@"Etag"];
                                                NSLog(@"%s--->1 %@ cna %@", __func__, error, cna);
                                                cna = [cna stringByReplacingOccurrencesOfString:@"/" withString:@""];
                                                NSLog(@"%s--->2 %@ cna %@", __func__, error, cna);
                                                
                                                if (error == nil) {
                                                    // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                                    // [userDefaults setObject:cna forKey:kEtagCna];
                                                    saveObjectToUserDefaults(kEtagCna, cna);
                                                    
                                                    
                                                    // TODO... 如果获取不到Etag，则用当前时间戳
                                                    
                                                }
                                            }];
    //5.执行任务
    [dataTask resume];
}


@end
