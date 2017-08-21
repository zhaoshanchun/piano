//
//  APIManager.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#import "SDImageCache.h"



@interface APIManager : NSObject

- (NSURLSessionDataTask *)baiduTest;

- (void)sdImageTest;


@end
