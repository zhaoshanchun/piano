//
//  CnaManager.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/8.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CnaManager : NSObject

+ (CnaManager *)sharedManager;

- (void)analysisCookie;
- (void)analysisUrl:(NSString *)cna vid:(NSString *)vid;

@end
