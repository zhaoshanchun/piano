//
//  HistoryManager.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "HistoryManager.h"
#import "FMDatabase.h"

@interface HistoryManager ()

@property (strong, nonatomic) FMDatabase *db;

@end

@implementation HistoryManager

static HistoryManager *_sharedManager;

+ (HistoryManager *)sharedManager {
    @synchronized(self) {
        if (!_sharedManager) {
            _sharedManager = [[HistoryManager alloc] init];
        }
    }
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *sqlFilePath = [path stringByAppendingPathComponent:@"history.sqlite"];
        _db = [FMDatabase databaseWithPath:sqlFilePath];
    }
    return self;
}

- (BOOL)openHistoryDb {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *sqlFilePath = [path stringByAppendingPathComponent:@"history.sqlite"];
    self.db = [FMDatabase databaseWithPath:sqlFilePath];
    MyLog(@"sqlFilePath = %@", sqlFilePath);
    // Users/zhaosc/Library/Developer/CoreSimulator/Devices/2F851296-E330-4036-869F-A231800ACD7A/data/Containers/Data/Application/E1DF108A-BBEC-4739-B6FD-BCEA0386366A/Documents/history.sqlite
    
    // 2.打开数据库
    if ([self.db open]) {
        // NSLog(@"打开HistoryDb成功");
        BOOL success = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_history (id integer PRIMARY KEY AUTOINCREMENT, uid text NOT NULL, title text, preview text);"];
        if (success) {
            // NSLog(@"创建表成功");
        } else {
            // NSLog(@"创建表失败");
            [self.db close];
            return NO;
        }
    } else {
        // NSLog(@"打开HistoryDb失败");
        return NO;
    }
    return YES;
}

//- (void)saveToHistoryBy:(NSString *)uid {
//    if (![self openHistoryDb]) {
//        return;
//    }
//    
//    NSString *cmd = @"DELETE FROM t_history WHERE uid==";
//    cmd = [cmd stringByAppendingString:@"'"];
//    cmd = [cmd stringByAppendingString:uid];
//    cmd = [cmd stringByAppendingString:@"';"];
//    NSLog(@"%s cmd: %@", __func__, cmd);
//    
//    BOOL success = [self.db executeUpdate:cmd];
//    if (success) {
//        NSLog(@"删除成功: %@", uid);
//    } else {
//        NSLog(@"删除失败: %@", uid);
//    }
//    success = [self.db executeUpdate:@"INSERT INTO t_history (uid) VALUES (?);", uid];
//    if (success) {
//        NSLog(@"插入成功: %@", uid);
//    } else {
//        NSLog(@"插入失败: %@", uid);
//    }
//    [self.db close];
//}

- (void)saveContentToHistory:(ContentModel *)contentModel {
    if (![self openHistoryDb]) {
        return;
    }
    
    NSString *cmd = @"DELETE FROM t_history WHERE uid==";
    cmd = [cmd stringByAppendingString:@"'"];
    cmd = [cmd stringByAppendingString:contentModel.uuid];
    cmd = [cmd stringByAppendingString:@"';"];
    // NSLog(@"%s cmd: %@", __func__, cmd);   // DELETE FROM t_history WHERE uid=='XMTgyMzY0MjQ5Mg==';
    
    BOOL success = [self.db executeUpdate:cmd];
    if (success) {
        // NSLog(@"删除成功: %@", contentModel.uuid);
    } else {
        // NSLog(@"删除失败: %@", contentModel.uuid);
    }
    
    success = [self.db executeUpdate:@"INSERT INTO t_history (uid, title, preview) VALUES (?, ?, ?);" withArgumentsInArray:@[contentModel.uuid, (contentModel.title.length > 0) ? contentModel.title : @"", (contentModel.preview.length > 0) ? contentModel.preview : @""]];
    if (success) {
        // NSLog(@"插入成功: %@", contentModel.uuid);
    } else {
        // NSLog(@"插入失败: %@", contentModel.uuid);
    }
    [self.db close];
}

- (NSMutableArray *)getAllHistoryList {
    NSMutableArray *historyListArray = [NSMutableArray array];
    if(![self openHistoryDb]) {
        return historyListArray;
    }
    
    // 查询数据
    FMResultSet *result = [self.db executeQuery:@"SELECT id, uid, title, preview FROM t_history;"];
    while ([result next]) {
        NSString *uid = [result stringForColumnIndex:1];
        NSString *title = [result stringForColumnIndex:2];
        NSString *preview = [result stringForColumnIndex:3];
        // int ID = [result intForColumnIndex:0];
        // NSLog(@"ID: %zd, uuid: %@, title:%@, preview:%@", ID, uid, title, preview);
        ContentModel *content = [ContentModel new];
        content.uuid = uid;
        content.title = title;
        content.preview = preview;
        [historyListArray addObject:content];
    }
    [self.db close];
    return historyListArray;
}

@end
