//
//  ImageLoad.m
//  huazhuangjiaocheng
//
//  Created by kun on 2017/6/9.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "AsyncImage.h"
#import "CollectionViewCell.h"
#import "AppDelegate.h"

@interface AsyncImage ()

@property (nonatomic, copy) NSString *Videotitle;
@property (nonatomic, copy) NSString *srcVid;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *clent_id;
@property (nonatomic, strong) BaseTableViewCell *cell;
@property (nonatomic, strong) CollectionViewCell *cell2;
@property (nonatomic, strong) VideoObject *videoObject;

@end


@implementation AsyncImage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)LoadImage:(BaseTableViewCell *)cell Object:(VideoObject *)obj {
    if(obj == nil) {
        return;
    }
    if([obj.password isEqual:@"password"] || [obj.password isEqual:@""]) {
        self.password = nil;
    } else {
        self.password = obj.password;
    }
    self.clent_id = obj.clent_id;
    self.videoObject = obj;
    self.cell2 = nil;
    self.cell = cell;
    
    if(obj == nil || obj.previewPath == nil){
        //[cell.loading startAnimating];
        // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        // NSString *cna = [userDefaults objectForKey:kEtagCna];
        NSString *cna = getStringFromUserDefaults(kEtagCna);
        if(cna == nil)
        {
            [self analysisCookie];
        }else{
            [self analysisUrl:cna id:self.videoObject.uid];
        }
    }
    else{
       // NSURL *url = [NSURL URLWithString:self.videoObject.previewPath];
        cell.nameLabel.text = self.videoObject.title;
        cell.timeLabel.text = self.videoObject.time;
        NSString *t = @"时长:";
        t = [t stringByAppendingString:self.videoObject.time];
        cell.playTime.text = t;

        //[cell.iconImageView sd_setImageWithURL:url];
    }

}


-(void)LoadImage2:(CollectionViewCell *)cell Object:(VideoObject *)obj{
    
    if(obj == nil)
        return;
    if([obj.password isEqual:@"password"] || [obj.password isEqual:@""])
        self.password = nil;
    else
        self.password = obj.password;
    self.clent_id = obj.clent_id;
    self.videoObject = obj;
    self.cell2 = cell;
    self.cell = nil;
    
    if(obj == nil || obj.previewPath == nil){
        //[cell.loading startAnimating];
        // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        // NSString *cna = [userDefaults objectForKey:kEtagCna];
        NSString *cna = getStringFromUserDefaults(kEtagCna);
        if(cna == nil)
        {
            [self analysisCookie];
        }else{
            [self analysisUrl:cna id:self.videoObject.uid];
        }
    }
    else{
        NSURL *url = [NSURL URLWithString:self.videoObject.previewPath];
        cell.nameLabel.text = self.videoObject.title;
        NSString *t = @"时长:";
        t = [t stringByAppendingString:self.videoObject.time];

        cell.playTime.text = t;
        //[cell.iconImageView sd_setImageWithURL:url];
    }
}

- (void)analysisCookie {
    NSURL *url = [NSURL URLWithString:@"https://log.mmstat.com/eg.js"];
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                      NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
                                      NSString *cna = headers[@"Etag"];// key
                                      cna = [cna stringByReplacingOccurrencesOfString:@"/" withString:@""];
                                      
                                      if (error == nil) {
                                          // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                          // [userDefaults setObject:cna forKey:kEtagCna];
                                          saveObjectToUserDefaults(kEtagCna, cna);
                                          [self analysisUrl:cna id:self.videoObject.uid];
                                      }
                                  }];
    //5.执行任务
    [dataTask resume];
}

- (void)analysisUrl:(NSString *)cna id:(NSString *)vid
{
    cna = [cna stringByReplacingOccurrencesOfString:@"/" withString:@""];
    cna = [cna stringByReplacingOccurrencesOfString:@"\"" withString:@""];

    NSString *urlStr;
    if(self.clent_id == nil || self.password == nil)
    {
        urlStr=[NSString stringWithFormat:@"https://ups.youku.com/ups/get.json?&ccode=%@&client_ip=192.168.2.1&vid=%@&utid=%@&client_ts=%ld", self.videoObject.code, vid, cna, time(nil)];
    }
    else
    {
        urlStr=[NSString stringWithFormat:@"https://ups.youku.com/ups/get.json?&ccode=%@&client_ip=192.168.2.1&vid=%@&utid=%@&client_ts=%ld&client_id=%@&password=%@", self.videoObject.code, vid, cna, time(nil), self.clent_id, self.password];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
   // NSLog(@"urlStr--->%@", urlStr);
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      if (error == nil)
                                      {
                                          //6.解析服务器返回的数据
                                          //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
                                          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                          
                                          NSString *dstUrl = dict[@"data"][@"stream"][0][@"m3u8_url"];

                                          NSString *preview = dict[@"data"][@"video"][@"logo"];
                                          //NSLog(@"--->preview = %@", preview);
                                          
                                          NSString *seconds = dict[@"data"][@"video"][@"seconds"];
                                         // NSLog(@"--->seconds = %d", [seconds intValue]);
                                          NSString *time = [NSString stringWithFormat:@"%02d:%02d", [seconds intValue]/60, [seconds intValue]%60];
                                          
                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                NSURL *url = [NSURL URLWithString:preview];
                                                //NSLog(@"url--->%@", url);
                                              
                                              NSString *t = @"时长:";
                                              t = [t stringByAppendingString:time];
                                              
                                              self.videoObject.videoPath = dstUrl;
                                              self.videoObject.previewPath = preview;
                                              self.videoObject.time = time;
                                                                                    
                                              if(self.cell)
                                              {
                                                [self.cell.loading stopAnimating];
                                                self.cell.timeLabel.text = time;
                                                self.cell.playTime.text = t;

                                                //[self.cell.iconImageView sd_setImageWithURL:url];
                                              }
                                              if(self.cell2)
                                              {
                                                  [self.cell2.loading stopAnimating];
                                                  self.cell2.playTime.text = t;
                                                  
                                                  //[self.cell2.iconImageView sd_setImageWithURL:url];
                                              }
                                              
                                              });
                                      }
                                      else{
                                          NSLog(@"%s- error: %@", __func__, error);
                                      }
                                  }];
    
    //5.执行任务
    [dataTask resume];
}

@end
