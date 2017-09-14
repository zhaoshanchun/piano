//
//  DownloadFile.h
//  sifakaoshi
//
//  Created by kun on 2017/9/4.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DownloadStateStart = 0,     /** 缓存中 */
    DownloadStateSuspended,     /** 缓存暂停 */
    DownloadStateCompleted,     /** 缓存完成 */
    DownloadStateFailed,        /** 缓存失败 */
    DownloadStateCancled,       /** 缓存取消 */
}DownloadState;

@protocol DownloadFileDelegate <NSObject>

-(void)receive_byte:(NSString *)uuid seg:(int)seg  byte:(long)bytes;
-(void)download_state:(NSString *)uuid seg:(int)seg state:(DownloadState)state;

@end

@interface DownloadFile : NSObject<NSCopying, NSURLSessionDelegate>

@property (nonatomic,weak) id<DownloadFileDelegate> delegate;



- (void)download:(NSString *)uuid seg:(int)seg file:(NSString *)filename url:(NSString *)url;

- (void)pause:(NSString *)uuid file:(NSString *)filename;

@end
