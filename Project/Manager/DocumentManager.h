//
//  DocumentManager.h
//  apps
//
//  Created by zhaosc on 2017/10/23.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DocumentBackHndler)(NSArray *documents);

@interface DocumentManager : NSObject

+ (DocumentManager *)sharedManager;

- (void)getDocumentFrom:(NSInteger)fromIndex count:(NSInteger)count backHandler:(DocumentBackHndler)handler;

@end
