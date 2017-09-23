//
//  ContentListModel.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/2.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <JSONModel/JSONModel.h>



@interface ContentModel : JSONModel

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *preview;

@end
@protocol ContentModel <NSObject>
@end


@interface ClassifyModel : JSONModel

@property (strong, nonatomic) NSString *classifyName;
@property (assign, nonatomic) NSInteger classifyId;

@end
@protocol ClassifyModel <NSObject>
@end


@interface ContentListModel : JSONModel

@property (strong, nonatomic) NSArray <ContentModel>*programs;
@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) NSArray <ClassifyModel>*classify;
@property (assign, nonatomic) NSInteger errorCode;

@end
@protocol ContentListModel <NSObject>
@end


@interface SourceModel : JSONModel

/*
video_uri	String	http://pl-ali.youku.com/playlist/m3u8?vid=XMTc0MDc2NDIxMg%3D%3D&type=mp4&ups_client_netip=183.39.228.130&ups_ts=1504339488&utid=12345&ccode=0590&psid=d01311edae1b23c82b5bfc0196c481c8&duration=5754&expire=18000&ups_key=be81075278d624eb3d2556dab7b0a479
score	String	8.8         评分
seconds	Integer	5755        时长：秒
plays	Integer	137         播放次数
size	Integer	216715414   大小：字节
comment_id	String          id
title	String	2016中药师强化提升课程-中药学专业知识一《一》   标题
uuid	String	XMTc0MDc2NDIxMg==   uuid
bad_review	Integer	0       评论
praise	Integer	58          点赞
*/

@property (strong, nonatomic) NSString *videoUri;
@property (strong, nonatomic) NSString *score;
@property (assign, nonatomic) NSInteger seconds;
@property (assign, nonatomic) NSInteger plays;
@property (assign, nonatomic) NSInteger size;
@property (strong, nonatomic) NSString *commentId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *uuid;
@property (assign, nonatomic) NSInteger badReview;
@property (assign, nonatomic) NSInteger praise;

@property (strong, nonatomic) NSString *preview;

@end
@protocol SourceModel <NSObject>
@end


@interface SourceResponseModel : JSONModel

@property (strong, nonatomic) SourceModel *object;
@property (strong, nonatomic) NSString *msg;
@property (assign, nonatomic) NSInteger errorCode;

@end
@protocol SourceResponseModel <NSObject>
@end


