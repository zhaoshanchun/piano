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
                                                    
                                                    //6.解析服务器返回的数据
                                                    //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
                                                    //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                    //NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                    //NSLog(@"--->%@",str);
                                                    if (self.vid == nil) {
                                                        [self parseHtml:self.htmlUrl];
                                                    }
                                                    [self analysisUrl:[cna stringByReplacingOccurrencesOfString:@"\"" withString:@""] vid:_vid];
                                                }
                                            }];
    //5.执行任务
    [dataTask resume];
}

// TODO... self.ccode 是个什么东西啊
- (void)analysisUrl:(NSString *)cna vid:(NSString *)vid {
    cna = [cna stringByReplacingOccurrencesOfString:@"/" withString:@""];
    cna = [cna stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSString *urlStr;
    if (self.clent_id == nil || self.password == nil) {
        urlStr = [NSString stringWithFormat:@"https://ups.youku.com/ups/get.json?&ccode=%@&client_ip=192.168.2.1&vid=%@&utid=%@&client_ts=%ld", self.ccode, self.vid, cna, time(nil)];
    } else {
        urlStr = [NSString stringWithFormat:@"https://ups.youku.com/ups/get.json?&ccode=%@&client_ip=192.168.2.1&vid=%@&utid=%@&client_ts=%ld&client_id=%@&password=%@", self.ccode, self.vid, cna, time(nil), self.clent_id, self.password];
    }
    NSLog(@"urlStr--->%@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                if (error == nil) {
                                                    //6.解析服务器返回的数据
                                                    //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
                                                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                    NSString *dstUrl = dict[@"data"][@"stream"][0][@"m3u8_url"];
                                                    NSLog(@"--->dstUrl = %@", dstUrl);
                                                    
                                                    if(dstUrl == nil) {
                                                        NSLog(@"--->dict %@", dict);
                                                        // TODO... @"网络异常，无法正常播放！"
                                                    } else {
                                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                            // TODO... 传 dstUrl 出去播放
                                                            // _playerView.url = [NSURL URLWithString:dstUrl];
                                                            // [_playerView playVideo];
                                                            
                                                        });
                                                    }
                                                }
                                            }];
    //5.执行任务
    [dataTask resume];
}

- (BOOL)parseHtml:(NSString *)htmlString {
    //NSString *htmlString = @"http://e.youku.com/cp/ECONDU4NDQ=/ECHNjE4MDQ0?";
    NSLog(@"---parseHtml: > %@", htmlString);
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:htmlString]];
    // NSLog(@"---htmlData: > %@", htmlData);
    
    if(htmlData == nil) {
        return NO;
    }
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    if (xpathParser == nil) {
        return NO;
    }
    
    NSArray *itemArray = [xpathParser searchWithXPathQuery:@"//script[@type = 'text/javascript']"];
    if(itemArray == nil) {
        return NO;
    }
    //NSLog(@"---itemArray: > %@", itemArray);
    
    for(TFHppleElement *element in itemArray) {
        NSString *string = [element content];
        if(![string containsString:@"window.playData"]) {
            continue;
        }
        
        if([string containsString:@"password"]) {
            NSArray *array = [string componentsSeparatedByString:@"password\":\""];
            if(array && [array count] >= 2) {
                array = [array[1] componentsSeparatedByString:@"\"}"];
                if(array && [array count] >= 2) {
                    NSString *password = array[0];
                    self.password = password;
                    NSLog(@"---password: > %@", password);
                }
            }
        }
        if([string containsString:@"clent_id"]) {
            NSArray *array = [string componentsSeparatedByString:@"clent_id\":\""];
            if(array && [array count] >= 2) {
                array = [array[1] componentsSeparatedByString:@"\","];
                if(array && [array count] >= 2) {
                    NSString *clent_id = array[0];
                    self.clent_id = clent_id;
                    NSLog(@"---clent_id> %@", clent_id);
                }
            }
        }
        if([string containsString:@"res"]) {
            NSArray *array = [string componentsSeparatedByString:@"res\":\""];
            if(array && [array count] >= 2) {
                array = [array[1] componentsSeparatedByString:@"\","];
                if(array && [array count] >= 2) {
                    NSString *vid = array[0];
                    self.vid = vid;
                    NSLog(@"---vid> %@", vid);
                }
            }
        }
    }
    return YES;
}



@end
