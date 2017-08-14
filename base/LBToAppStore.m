//
//  LBToAppStore.m
//  LBToAppStore
//
//  Created by gold on 16/5/3.
//  Copyright © 2016年 Bison. All rights reserved.
//

#import "LBToAppStore.h"

@interface LBToAppStore() {
    UIViewController *parentVC;
}
@end

@implementation LBToAppStore

- (void)showGotoAppStore:(UIViewController *)VC Rep:(BOOL)rep_ {
    //当前版本号
    parentVC = VC;
    _myAppID = AppID;
    _rep = rep_;
    srand((unsigned int)time(NULL));
    int r = rand()%2;
    if(r == 0) {
        [self tryGotoAppStore];
    } else {
    }
}

- (void)startGotoAppStore {
    NSLog(@"--->%s", __func__);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    float appVersion = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] floatValue];
    //userDefaults里的天数
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int udtheDays = [[userDefaults objectForKey:@"theDays"] intValue];
    //userDefaults里的版本号
    float udAppVersion = [[userDefaults objectForKey:@"appVersion"] intValue];
    //userDefaults里用户上次的选项
    int udUserChoose = [[userDefaults objectForKey:@"userOptChoose"] intValue];
    //时间戳的天数
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    int daySeconds = 24 * 60 * 60;
    NSInteger theDays = interval / daySeconds;
    
    //[self alertUserCommentView:parentVC];
    //udUserChoose = 0;
    int sure = [[userDefaults objectForKey:@"sure"] intValue];

    if(_rep) {
        [self alertUserCommentView:parentVC];
        return;
    }
    //版本升级之后的处理,全部规则清空,开始弹窗
    if (udAppVersion && appVersion>udAppVersion) {
        [userDefaults removeObjectForKey:@"theDays"];
        [userDefaults removeObjectForKey:@"appVersion"];
        [userDefaults removeObjectForKey:@"userOptChoose"];
        [self alertUserCommentView:parentVC];
    } else if (!udUserChoose || sure < 2 ||  theDays-udtheDays >= 1) {
        double lastTime = [[userDefaults objectForKey:@"lastTime"] doubleValue];
        if((interval - lastTime) < 10*60) { ////:10分钟弹出一次框
            return;
        }
        if(sure >= 2) {
            [userDefaults setObject:[NSString stringWithFormat:@"%d",(int)1] forKey:@"sure"];
        }
        [self alertUserCommentView:parentVC];
    }
    
    //1,从来没弹出过的
    //2,用户选择😓我要吐槽，7天之后再弹出
    //3,用户选择😭残忍拒绝后，7天内，每过1天会弹一次
    //4,用户选择😭残忍拒绝的30天后，才会弹出
    /*
    else if (!udUserChoose ||
             (udUserChoose==2 && theDays-udtheDays>7) ||
             (udUserChoose>=3 && theDays-udtheDays<=7 && theDays-udtheDays>udUserChoose-3) ||
             (udUserChoose>=3 && theDays-udtheDays>30)) {
        [self alertUserCommentView:parentVC];
    }
     */
}

- (void)alertUserCommentView:(UIViewController *)VC {
    NSLog(@"--->%s", __func__);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //当前时间戳的天数
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        int daySeconds = 24 * 60 * 60;
        NSInteger theDays = interval / daySeconds;
        //当前版本号
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        float appVersion = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] floatValue];
        //userDefaults里版本号
        float udAppVersion = [[userDefaults objectForKey:@"appVersion"] intValue];
        //userDefaults里用户选择项目
        int udUserChoose = [[userDefaults objectForKey:@"userOptChoose"] intValue];
        //userDefaults里用户天数
        int udtheDays = [[userDefaults objectForKey:@"theDays"] intValue];
        
        //当前版本比userDefaults里版本号高
        if (appVersion>udAppVersion) {
            [userDefaults setObject:[NSString stringWithFormat:@"%f",appVersion] forKey:@"appVersion"];
        }
        
        alertController = [UIAlertController alertControllerWithTitle:@"温馨提示!" message:@"亲爱的, 五星好评可解锁更多免费视频课程哦！" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *refuseAction = [UIAlertAction actionWithTitle:@"😭残忍拒绝" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [userDefaults setObject:@"1" forKey:@"userOptChoose"];
            [userDefaults setObject:[NSString stringWithFormat:@"%d",(int)theDays] forKey:@"theDays"];
            
            if (_delegate) {
                [_delegate CancelButtonAction];
            } else {
                NSLog(@"没有实现代理或者没有设置代理人");
            }
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"😄好评赞赏" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [userDefaults setObject:@"2" forKey:@"userOptChoose"];
            [userDefaults setObject:[NSString stringWithFormat:@"%d",(int)theDays] forKey:@"theDays"];
            
            NSString *str = [NSString stringWithFormat:
                             @"https://itunes.apple.com/cn/app/id%@?mt=8",
                             self.myAppID ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
            if (_delegate) {
                [_delegate SureButtonAction];
            } else {
                NSLog(@"没有实现代理或者没有设置代理人");
            }
            
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
            [userDefaults setObject:[NSString stringWithFormat:@"%f",interval] forKey:@"lastTime"];

            int sure = [[userDefaults objectForKey:@"sure"] intValue];
            ++sure;
            [userDefaults setObject:[NSString stringWithFormat:@"%d",(int)sure] forKey:@"sure"];
        }];
        
        /*
        UIAlertAction *showAction = [UIAlertAction actionWithTitle:@"😓我要吐槽" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            
            if (udUserChoose<=3 || theDays-[[userDefaults objectForKey:@"theDays"] intValue]>30) {
                [userDefaults setObject:@"3" forKey:@"userOptChoose"];
                [userDefaults setObject:[NSString stringWithFormat:@"%d",(int)theDays] forKey:@"theDays"];
            }else{
                [userDefaults setObject:[NSString stringWithFormat:@"%d",(int)(theDays-udtheDays+3)] forKey:@"userOptChoose"];
            }
            NSString *str = [NSString stringWithFormat:
                             @"https://itunes.apple.com/cn/app/id%@?mt=8",
                             self.myAppID ];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        */
        
        [alertController addAction:refuseAction];
        [alertController addAction:okAction];
      //  [alertController addAction:showAction];
        
//        NSLog(@"%@",[userDefaults objectForKey:@"appVersion"]);
//        NSLog(@"%@",[userDefaults objectForKey:@"userOptChoose"]);
//        NSLog(@"%@",[userDefaults objectForKey:@"theDays"]);
        
        [VC presentViewController:alertController animated:YES completion:nil];
        
    } else {
        #if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        alertViewTest = [[UIAlertView alloc] initWithTitle:@"温馨提示!" message:@"亲爱的, 五星好评可解锁更多免费视频课程哦！" delegate:self cancelButtonTitle:@"😭残忍拒绝" otherButtonTitles:@"😄好评赞赏", nil];
        [alertViewTest show];
        #endif
    }
    
    if (_delegate) {
        [_delegate ShowButtonAction];
    } else {
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //当前时间戳的天数
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    int daySeconds = 24 * 60 * 60;
    NSInteger theDays = interval / daySeconds;
    //当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    float appVersion = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] floatValue];
    //userDefaults里版本号
    float udAppVersion = [[userDefaults objectForKey:@"appVersion"] intValue];
    //userDefaults里用户选择项目
    int udUserChoose = [[userDefaults objectForKey:@"userOptChoose"] intValue];
    //userDefaults里用户天数
    int udtheDays = [[userDefaults objectForKey:@"theDays"] intValue];
    
    //当前版本比userDefaults里版本号高
    if (appVersion > udAppVersion) {
        [userDefaults setObject:[NSString stringWithFormat:@"%f",appVersion] forKey:@"appVersion"];
    }
    
    switch (buttonIndex) {
        case 0: {
            //残忍的拒绝
            if (udUserChoose<=3 || theDays-[[userDefaults objectForKey:@"theDays"] intValue]>30) {
                [userDefaults setObject:@"3" forKey:@"userOptChoose"];
                [userDefaults setObject:[NSString stringWithFormat:@"%d",(int)theDays] forKey:@"theDays"];
            } else {
                [userDefaults setObject:[NSString stringWithFormat:@"%d",(int)(theDays-udtheDays+3)] forKey:@"userOptChoose"];
            }
            break;
        }
        case 1: { //好评
            [userDefaults setObject:@"1" forKey:@"userOptChoose"];
            [userDefaults setObject:[NSString stringWithFormat:@"%d",(int)theDays] forKey:@"theDays"];
            NSString *str = [NSString stringWithFormat:
                             @"https://itunes.apple.com/cn/app/id%@?mt=8",
                             self.myAppID ];

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            break;
        }
        case 2:{ //不好用，我要提意见
            [userDefaults setObject:@"2" forKey:@"userOptChoose"];
            [userDefaults setObject:[NSString stringWithFormat:@"%d",(int)theDays] forKey:@"theDays"];
            NSString *str = [NSString stringWithFormat:
                             @"https://itunes.apple.com/cn/app/id%@?mt=8",
                             self.myAppID ];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            break;
        }
        default:
            break;
    }
//    NSLog(@"%@",[userDefaults objectForKey:@"appVersion"]);
//    NSLog(@"%@",[userDefaults objectForKey:@"userOptChoose"]);
//    NSLog(@"%@",[userDefaults objectForKey:@"theDays"]);
    
}
#endif

- (void)tryGotoAppStore {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:
                                       @"https://itunes.apple.com//lookup?id=%@",
                                       self.myAppID ]];
    NSLog(@"%s %@", __func__, url);

    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                      if (error == nil) {
                                          //6.解析服务器返回的数据
                                          //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
                                          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                          NSNumber *resultCount =  [dict objectForKey:@"resultCount"];
                                          
                                          if([resultCount intValue] == 0) {
                                              NSLog(@"--->online resultCount : %@",resultCount);
                                              //[self startGotoAppStore];
                                              return ;
                                          }
                                          
                                          NSArray *infoContent = [dict objectForKey:@"results"];
                                          //最新版本号
                                          NSString *version = [[infoContent objectAtIndex:0] objectForKey:@"version"];
                                          NSLog(@"--->online version : %@",version);
                                          
                                          NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                                          NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                                          NSLog(@"当前应用版本号码：%@",appCurVersionNum);
                                          if([version isEqualToString:appCurVersionNum]){
                                              [self startGotoAppStore];
                                          }
                                      }
                                      else {
                                      }
                                  }];
    //5.执行任务
    [dataTask resume];
}


@end
