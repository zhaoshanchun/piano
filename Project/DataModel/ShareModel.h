//
//  ShareModel.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/15.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/*
{"objects":[
 
 {"plays":"172",
 "size":"172108199",
 "content":"方尽快答复",
 "bad_review":"0",
 "icon":"01a1aaa5514546c0ed7d9bdad8374487",
 "time":"2017-09-17 23:36:37",
 "title":null,
 "uuid":"XMTgyMzY0NDQ0NA",
 "alias":"kk",
 "praise":"51",
 "score":"8.3",
 "seconds":"3284"},
 
 {"plays":"172","size":"172108199","content":"一大堆分享","bad_review":"0","icon":"01a1aaa5514546c0ed7d9bdad8374487","time":"2017-09-17 23:31:02","title":null,"uuid":"XMTgyMzY0NDQ0NA","alias":"kk","praise":"51","score":"8.3","seconds":"3284"},{"plays":137,"size":301644427,"content":"123456","bad_review":0,"comment_id":"","icon":"01a1aaa5514546c0ed7d9bdad8374487","time":"2017-08-24 10:21:14","title":"2016中药师强化提升课程-中药学专业知识一《一》","uuid":"XMTc0MDc2NDIxMg==","alias":"kk","praise":58,"score":"8.8","seconds":5755,"preview":"https:\/\/vthumb.ykimg.com\/0541040857EB80CC6A0A4D04819AC78B"},{"plays":137,"size":301644427,"content":"123456","bad_review":0,"comment_id":"","icon":"01a1aaa5514546c0ed7d9bdad8374487","time":"2017-08-24 10:21:12","title":"2016中药师强化提升课程-中药学专业知识一《一》","uuid":"XMTc0MDc2NDIxMg==","alias":"kk","praise":58,"score":"8.8","seconds":5755,"preview":"https:\/\/vthumb.ykimg.com\/0541040857EB80CC6A0A4D04819AC78B"},{"plays":137,"size":301644427,"content":"123456","bad_review":0,"comment_id":"","icon":"01a1aaa5514546c0ed7d9bdad8374487","time":"2017-08-24 09:04:16","title":"2016中药师强化提升课程-中药学专业知识一《一》","uuid":"XMTc0MDc2NDIxMg==","alias":"kk","praise":58,"score":"8.8","seconds":5755,"preview":"https:\/\/vthumb.ykimg.com\/0541040857EB80CC6A0A4D04819AC78B"}],"msg":"successful","error":0}
*/

@interface ShareModel : JSONModel

@property (strong, nonatomic) NSString *video_url;
@property (assign, nonatomic) NSInteger plays;
@property (assign, nonatomic) NSInteger size;
@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) NSInteger bad_review;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *uuid;
@property (assign, nonatomic) NSInteger praise;
@property (strong, nonatomic) NSString *score;
@property (assign, nonatomic) NSInteger seconds;
@property (strong, nonatomic) NSString *alias;
@property (strong, nonatomic) NSString *preview;

@end
@protocol ShareModel <NSObject>
@end


@interface ShareListModel : JSONModel

@property (strong, nonatomic) NSArray <ShareModel>*objects;
@property (strong, nonatomic) NSString *msg;
@property (assign, nonatomic) NSInteger errorCode;

@end
@protocol ContentListModel <NSObject>
@end
