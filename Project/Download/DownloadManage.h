//
//  DownloadManage.h
//  sifakaoshi
//
//  Created by kun on 2017/8/31.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  DLTASK : NSObject

@property   NSString*   uuid;
@property   NSString*   title;
@property   NSString*   icon;
@property   int         completed;
@property   int         total;
@property   NSString*   time;
@property   long        section;
@property   double      rate;
@property   float      progress;

@end

@protocol ProgramDownloadDelegate <NSObject>

/*
 缓存事件回调
 */
-(void)event:(NSString *)uuid event:(int)event error:(int)error;

/*
 缓存速率回调
 */
-(void)rate:(NSString *)uuid rate:(double)rate;

/*
 缓存进度回调
 */
-(void)progress:(NSString *)uuid progress:(float)progress;

@end

@interface DownloadManage : NSObject

@property (nonatomic,weak) id<ProgramDownloadDelegate> delegate;


+ (instancetype)sharedInstance;
-(BOOL)start;
-(void)stop;

-(BOOL)add_download:(NSString *)uuid url:(NSString *)url icon:(NSString *)icon title:(NSString *)title;
-(BOOL)remove_download:(NSString *)uuid;
-(BOOL)remove_all;

-(BOOL)status:(NSString *)uuid;

-(BOOL)start_download:(NSString *)uuid;
-(void)pause_download:(NSString *)uuid;

-(NSURL *)get_play_url:(NSString *)uuid;

-(NSArray *)get_download_list;
- (NSMutableArray *)select_download_task:(BOOL)selected;
//-(NSMutableArray *)parse_m3u8_file:(NSString *)uuid src:(NSString *)src;
//-(BOOL)file_exist:(NSString *)url;

@end
