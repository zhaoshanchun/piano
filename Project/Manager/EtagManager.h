//
//  EtagManager.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/8.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EtagBackHndler)(NSString *etag, NSString *msg);

@interface EtagManager : NSObject

+ (EtagManager *)sharedManager;
- (void)getEtagWithHandler:(EtagBackHndler)handler;

@end
