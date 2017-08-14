//
//  GlobalValue.h
//  huazhuangjiaocheng
//
//  Created by kun on 2017/6/10.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

#define SectionMultiple 5

#define Section0Index 0
#define Section1Index 50
#define Section2Index 100
#define Section3Index 150



// 随机色
//#define LVRandomColor LVColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define LVRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];

@interface VideoObject : NSObject
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *videoPath;
@property (strong, nonatomic) NSString *previewPath;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *subUrl;
@property (strong, nonatomic) NSString *clent_id;
@property (strong, nonatomic) NSString *password;
@property (assign, nonatomic) long index;

@end

@interface GlobalObject : NSObject

@property (strong, nonatomic) NSString *videoPath;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *url;

@end

@interface GlobalValue : NSObject
@property (strong, nonatomic) FMDatabase *db;

- (id)init;
- (void)historySave:(NSString *)uid;
- (NSMutableArray *)historyView;
- (void)setImageUrl:(NSString *)key Obj:(GlobalObject *)object;
- (GlobalObject *)getImageUrl:(NSString *)uid;
- (NSMutableArray *)getVideoObjects:(long )start End:(long)end;
- (VideoObject *)getVideoObject:(NSString *)uid;
- (VideoObject *)getVideoObjectWithIndex:(long )index;
- (NSMutableArray *)keySearchForObjects:(NSString *)key;
- (long)getVideoObjectIndex:(NSString *)uid;
- (void)updateVideoObject:(NSString *)uid Object:(VideoObject *)obj;
- (int)VideoObjectsCount;

@end
