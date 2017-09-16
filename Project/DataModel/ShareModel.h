//
//  ShareModel.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/15.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface ShareModel : JSONModel
     
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *icon;

@property (strong, nonatomic) NSString *videoUrl;

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
