//
//  HistoryManager.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentListModel.h"

@interface HistoryManager : NSObject

+ (HistoryManager *)sharedManager;

//- (void)saveToHistoryBy:(NSString *)uid;
- (void)saveContentToHistory:(ContentModel *)contentModel;
- (NSMutableArray *)getAllHistoryList;

@end
