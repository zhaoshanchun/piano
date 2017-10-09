//
//  FavoritesManager.m
//  gangqinjiaocheng
//
//  Created by kun on 2017/9/26.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "FavoritesManager.h"
#import "FMDatabase.h"

@implementation FavoriteObject
@end

@interface FavoritesManager()

@property (strong, nonatomic) FMDatabase *db;

@end

@implementation FavoritesManager

static FavoritesManager *_sharedManager;

+ (FavoritesManager *)sharedManager {
    @synchronized(self) {
        if (!_sharedManager) {
            _sharedManager = [[FavoritesManager alloc] init];
        }
    }
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *sqlFilePath = [path stringByAppendingPathComponent:@"favorite.sqlite"];
        _db = [FMDatabase databaseWithPath:sqlFilePath];
    }
    return self;
}


- (BOOL)openHistoryDb {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *sqlFilePath = [path stringByAppendingPathComponent:@"favorite.sqlite"];
    self.db = [FMDatabase databaseWithPath:sqlFilePath];
    MyLog(@"sqlFilePath = %@", sqlFilePath);

    // 2.打开数据库
    if ([self.db open]) {
        // NSLog(@"打开HistoryDb成功");
        BOOL success = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_favorite (id integer PRIMARY KEY AUTOINCREMENT, uuid text NOT NULL, title text, preview text);"];
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

- (void)add:(NSString *)uuid title:(NSString *)title preview:(NSString *)preview {
    if (![self openHistoryDb]) {
        return;
    }
    
    NSString *cmd = @"DELETE FROM tb_favorite WHERE uuid==";
    cmd = [cmd stringByAppendingString:@"'"];
    cmd = [cmd stringByAppendingString:uuid];
    cmd = [cmd stringByAppendingString:@"';"];
    
    BOOL success = [self.db executeUpdate:cmd];
    if (success) {
        // NSLog(@"删除成功: %@", contentModel.uuid);
    } else {
        // NSLog(@"删除失败: %@", contentModel.uuid);
    }
    
    success = [self.db executeUpdate:@"INSERT INTO tb_favorite (uuid, title, preview) VALUES (?, ?, ?);",uuid, title, preview];
    if (success) {
        // NSLog(@"插入成功: %@", contentModel.uuid);
    } else {
        // NSLog(@"插入失败: %@", contentModel.uuid);
    }
    [self.db close];
}

- (void)remove:(NSString *)uuid
{
    if (![self openHistoryDb]) {
        return;
    }
    NSString *cmd = @"DELETE FROM tb_favorite WHERE uuid==";
    cmd = [cmd stringByAppendingString:@"'"];
    cmd = [cmd stringByAppendingString:uuid];
    cmd = [cmd stringByAppendingString:@"';"];
    // NSLog(@"%s cmd: %@", __func__, cmd);   // DELETE FROM t_history WHERE uid=='XMTgyMzY0MjQ5Mg==';
    
    BOOL success = [self.db executeUpdate:cmd];
    if (success) {
        // NSLog(@"删除成功: %@", contentModel.uuid);
    } else {
        // NSLog(@"删除失败: %@", contentModel.uuid);
    }
    [self.db close];
}

- (NSMutableArray *)getFavoriteArray
{
    NSMutableArray *array = [NSMutableArray array];
    if(![self openHistoryDb]) {
        return array;
    }

    // 查询数据
    FMResultSet *result = [self.db executeQuery:@"SELECT * FROM tb_favorite;"];
    while ([result next]) {
        int ID = [result intForColumnIndex:0];
        NSString *uuid = [result stringForColumnIndex:1];
        NSString *title = [result stringForColumnIndex:2];
        NSString *preview = [result stringForColumnIndex:3];
        //NSLog(@"ID: %zd, name: %@", ID, uid);
        FavoriteObject *obj = [FavoriteObject new];
        obj.uuid = uuid;
        obj.title = title;
        obj.preview = preview;
        [array addObject:obj];
        
        //NSLog(@"count: %d, uuid: %@, title: %@, preview: %@", [result columnCount], uuid, title, preview);
        //NSLog(@"ID: %zd, name: %@", ID, uid);
        //NSLog(@"ID: %zd, name: %@", ID, uid);

    }
    //NSLog(@"NSMutableArray: %@", ret);
    [self.db close];
    return array;
}

@end
