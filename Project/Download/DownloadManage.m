//
//  DownloadManage.m
//  sifakaoshi
//
//  Created by kun on 2017/8/31.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "DownloadManage.h"
#import "GCDWebDAVServer.h"
#import "DownloadFile.h"
#import <sqlite3.h>

#define DownloadDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"download"]

@implementation DLTASK
@end

@interface DLRate : NSObject

@property    NSString   *uuid;
@property    long       bytes;
@property    long long       last_tick;

@end
@implementation DLRate
@end


@interface Program : NSObject

@property    NSString *uuid;
@property    int ts_seg_no;
@property    double seconds;
@property    NSString* file;
@property    NSString* src;
@property    BOOL completed;

@end

@implementation Program
@end

@interface ProgramCache : NSObject
@property   NSString *uuid;
@property   NSMutableDictionary *tsDict;
@property   int completed;
@property   int total;
@end

@implementation ProgramCache
@end

@interface TaskSession : NSObject

@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSArray *tsArray;
@property (nonatomic, strong) NSString *uuid;

@end

@implementation TaskSession
@end


@interface DownloadManage()<NSURLSessionDelegate, DownloadFileDelegate>
{
    GCDWebDAVServer* _davServer;
    sqlite3 *database;
    NSString *databasePath;
    BOOL stop;
}
@property (nonatomic, strong) NSMutableDictionary *uuidMap;
@property (nonatomic, strong) NSMutableDictionary *sessions;
@property (nonatomic, strong) NSMutableDictionary *tasks;
@property (nonatomic, strong) NSMutableDictionary *suspend;
@property (nonatomic, strong) NSMutableDictionary *programDict;
@property (nonatomic, strong) NSMutableDictionary *DownloadTask;
@property (nonatomic, strong) NSMutableDictionary *DownloadRate;

@end

@implementation DownloadManage

static DownloadManage *_downloadManage;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloadManage = [[self alloc] init];
        _downloadManage.uuidMap = [NSMutableDictionary dictionary];
        _downloadManage.sessions = [NSMutableDictionary dictionary];
        _downloadManage.tasks = [NSMutableDictionary dictionary];
        _downloadManage.suspend = [NSMutableDictionary dictionary];
        _downloadManage.DownloadTask = [NSMutableDictionary dictionary];
        _downloadManage.DownloadRate = [NSMutableDictionary dictionary];
        [_downloadManage initDb];
    });
    return _downloadManage;
}

-(BOOL)start
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _davServer = [[GCDWebDAVServer alloc] initWithUploadDirectory:documentsPath];
    [_davServer start];
    stop = NO;
    NSLog(@"serverURL：%@", _davServer.serverURL);
    NSLog(@"server documentsPath：%@", documentsPath);
    _programDict = [NSMutableDictionary dictionary];
    
    [self get_download_list];
    return true;
}


-(void)stop
{
    [_davServer stop];
    stop = YES;
    _programDict = nil;
}

- (BOOL)initDb
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    databasePath = [[NSString alloc] initWithString:[dirPaths[0] stringByAppendingPathComponent: @"download_task.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "create table if not exists download (uuid text, title text, icon text, completed integer default 0, total integer default 0, time datetime, primary key(uuid))";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table err %s", errMsg);
            }
            NSLog(@"successful to create table");
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    else
    {
        NSLog(@"FileIsExistsAtPath");
    }
    return true;
}

- (BOOL)open_db
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    databasePath = [[NSString alloc] initWithString:[dirPaths[0] stringByAppendingPathComponent: @"download_task.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            return true;
        }
    }
    else
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            return true;
        }
    }
    return false;
}

- (BOOL)close_db
{
    sqlite3_close(database);
    return true;
}

-(BOOL)add_download:(NSString *)uuid url:(NSString *)url icon:(NSString *)icon title:(NSString *)title
{
    sqlite3_stmt *stmt;
    if(![self open_db])
    {
        NSLog(@"open sqlite db failed");
        return false;
    }
    NSString *sql = @"insert into download(uuid, title, icon, completed, total, time) values(?,?,?,?,?,?)";
    int result;
    //编译SQL语句
    result = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
    if(result == SQLITE_OK)
    {
        sqlite3_reset(stmt);
        //绑定数据
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
        
        sqlite3_bind_text(stmt, 1, [uuid UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [icon UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [title UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 4, 1);
        sqlite3_bind_int(stmt, 5, 0);
        sqlite3_bind_text(stmt, 6, [dateString UTF8String], -1, NULL);
        //执行SQL语句
        result = sqlite3_step(stmt);
        if(result == SQLITE_DONE)
        {
            result = true;
            NSLog(@"SQLITE_DONE");
        }
        else
        {
            NSLog(@"SQLITE_ERROR");
            result = false;
        }
        //NSLog(@"result:%d", result);//打印执行结果，观察其区别
        
    }
    else
    {
        NSLog(@"sqlite3_prepare_v2 error %d", result);
        result = false;
    }
    sqlite3_finalize(stmt);
    [self close_db];
    return YES;
}

- (BOOL)update_dowload_completed:(NSString *)uuid completed:(int) completed
{
    sqlite3_stmt *stmt;
    if(![self open_db])
    {
        NSLog(@"open sqlite db failed");
        return false;
    }
    NSString *quary = [NSString stringWithFormat:@"update download set completed = '%d' where uuid = '%@'", completed, uuid];
    if (sqlite3_prepare_v2(database, [quary UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
        if (sqlite3_step(stmt)==SQLITE_DONE) {
            //NSLog(@"---> DONE：%@", quary);
            //NSLog(@"select %@  %d  %0.02f  %@  %d", uuidString, ts_seg_no, seconds, fileString, completed);
        }
        else
        {
            NSLog(@"sqlite3_step error");
        }
        sqlite3_finalize(stmt);
    }
    else
    {
        NSLog(@"sqlite3_prepare_v2 failed quary：%@", quary);
    }
    //用完了一定记得关闭，释放内存
    sqlite3_close(database);
    return true;
}

- (BOOL)update_dowload_total:(NSString *)uuid total:(int) total
{
    sqlite3_stmt *stmt;
    if(![self open_db])
    {
        NSLog(@"open sqlite db failed");
        return false;
    }
    NSString *quary = [NSString stringWithFormat:@"update download set total = '%d' where uuid = '%@'", total, uuid];
    if (sqlite3_prepare_v2(database, [quary UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
        if (sqlite3_step(stmt)==SQLITE_DONE) {
            //NSLog(@"---> DONE：%@", quary);
            //NSLog(@"select %@  %d  %0.02f  %@  %d", uuidString, ts_seg_no, seconds, fileString, completed);
        }
        else
        {
            NSLog(@"sqlite3_step error");
        }
        sqlite3_finalize(stmt);
    }
    else
    {
        NSLog(@"sqlite3_prepare_v2 failed quary：%@", quary);
    }
    //用完了一定记得关闭，释放内存
    sqlite3_close(database);
    return true;
}

- (BOOL)update_dowload_time:(NSString *)uuid
{
    sqlite3_stmt *stmt;
    if(![self open_db])
    {
        NSLog(@"open sqlite db failed");
        return false;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];

    NSString *quary = [NSString stringWithFormat:@"update download set total = '%@' where uuid = '%@'", dateString, uuid];
    if (sqlite3_prepare_v2(database, [quary UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
        if (sqlite3_step(stmt)==SQLITE_DONE) {
            NSLog(@"---> DONE：%@", quary);
            //NSLog(@"select %@  %d  %0.02f  %@  %d", uuidString, ts_seg_no, seconds, fileString, completed);
        }
        else
        {
            NSLog(@"sqlite3_step error");
        }
        sqlite3_finalize(stmt);
    }
    else
    {
        NSLog(@"sqlite3_prepare_v2 failed quary：%@", quary);
    }
    //用完了一定记得关闭，释放内存
    sqlite3_close(database);
    return true;
}

- (NSMutableArray *)select_download_task:(BOOL)isEqual
{
    NSLog(@"select_download_task");
    sqlite3_stmt *stmt;
    NSMutableArray *array = [NSMutableArray array];
    if(![self open_db])
    {
        NSLog(@"open sqlite db failed");
        return false;
    }
    NSString *quary;
    if(isEqual)
        quary = [NSString stringWithFormat:@"select * from download where completed > 0 and completed == total"];
    else
        quary = [NSString stringWithFormat:@"select * from download where completed > 0 and completed <> total"];
    
    if (sqlite3_prepare_v2(database, [quary UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            
            char *tmp = (char *)sqlite3_column_text(stmt, 0);
            NSString *uuid = [[NSString alloc] initWithUTF8String:tmp];
            
            tmp = (char *)sqlite3_column_text(stmt, 1);
            NSString *icon = [[NSString alloc] initWithUTF8String:tmp];
            
            tmp = (char *)sqlite3_column_text(stmt, 2);
            NSString *title = [[NSString alloc] initWithUTF8String:tmp];
            
            int completed = sqlite3_column_int(stmt, 3);

            int total = sqlite3_column_int(stmt, 4);

            tmp = (char *)sqlite3_column_text(stmt, 5);
            NSString *time = [[NSString alloc] initWithUTF8String:tmp];

            NSLog(@"select uuid %@ %@ %@ %d %d %@", uuid, title, icon, completed, total, time);
            
            DLTASK *task = [DLTASK new];
            task.uuid = uuid;
            task.title = title;
            task.icon = icon;
            task.completed = completed;
            task.total = total;
            [array addObject:task];
            
            //NSLog(@"select %@  %d  %0.02f  %@  %d", uuidString, ts_seg_no, seconds, fileString, completed);
        }
        
        sqlite3_finalize(stmt);
    }
    //用完了一定记得关闭，释放内存
    sqlite3_close(database);
    return array;
}

- (BOOL)delete_dowload_task:(NSString *)uuid
{
    sqlite3_stmt *stmt;
    if(![self open_db])
    {
        NSLog(@"open sqlite db failed");
        return false;
    }
    NSString *quary;
    if(uuid)
        quary = [NSString stringWithFormat:@"delete from download where uuid = '%@'", uuid];
    else
        quary = [NSString stringWithFormat:@"delete from download"];
    if (sqlite3_prepare_v2(database, [quary UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
        if (sqlite3_step(stmt)==SQLITE_DONE) {
            //NSLog(@"---> DONE：%@", quary);
            //NSLog(@"select %@  %d  %0.02f  %@  %d", uuidString, ts_seg_no, seconds, fileString, completed);
        }
        else
        {
            NSLog(@"sqlite3_step error");
        }
        sqlite3_finalize(stmt);
    }
    else
    {
        NSLog(@"sqlite3_prepare_v2 failed quary：%@", quary);
    }
    //用完了一定记得关闭，释放内存
    sqlite3_close(database);
    return true;
}

-(BOOL)remove_download:(NSString *)uuid
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *directryPath = [path stringByAppendingFormat:@"/programs/%@/", uuid];
    NSString *m3u_file = [path stringByAppendingFormat:@"/%@.m3u", uuid];
    
    [self pause_download:uuid];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager removeItemAtPath:directryPath error:NULL]) {
        NSLog(@"Removed successfully: %@", directryPath);
    }
    
    if([fileManager removeItemAtPath:m3u_file error:NULL]) {
        NSLog(@"Removed successfully: %@", m3u_file);
    }
    [self delete_dowload_task:uuid];
    return YES;
}

-(BOOL)remove_all
{
    [self delete_dowload_task:nil];
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *homePath = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:homePath error:nil];
    for(int i = 0; i < files.count; i++)
    {
        NSString *filename = files[i];
        if([filename containsString:@".m3u"])
        {
            [self pause_download:[filename stringByReplacingOccurrencesOfString:@".m3u" withString:@""]];
            NSString *dfile = [homePath stringByAppendingFormat:@"/%@", filename];
            [fileManager removeItemAtPath:dfile error:NULL];
        }
    }
    
    NSString *directryPath = [homePath stringByAppendingFormat:@"/programs"];
    [fileManager removeItemAtPath:directryPath error:NULL];
    return true;
}

-(BOOL)status:(NSString *)uuid
{
    NSString *state = [self.suspend objectForKey:uuid];
    //NSLog(@"state: %@", state);
    if(!state)
        return false;
    else if([state isEqualToString:@"YES"])
        return false;
    else
        return true;
}

-(BOOL)start_download:(NSString *)uuid
{
    [self.suspend setValue:@"NO" forKey:uuid];
    return [self get_m3u8_url:uuid];
}

-(void)pause_download:(NSString *)uuid
{
    NSURLSessionDataTask *task = [self.tasks objectForKey:uuid];
    if(task)
    {
        [task suspend];
    }
    //NSLog(@"suspend set YES");
    [self.suspend setValue:@"YES" forKey:uuid];
}

-(NSURL *)get_play_url:(NSString *)uuid
{
    NSString *file = [uuid stringByAppendingString:@".m3u"];
    NSURL *url;
    url = [_davServer.serverURL URLByAppendingPathComponent:file isDirectory:NO];
    return url;
}

-(BOOL)download_m3u8_file:(NSString *)uuid url:(NSString *)url
{
    TaskSession *taskSession = [self.sessions objectForKey:uuid];
    
    /*
    if(taskSession != nil)
    {
        if(self.delegate)
        {
            [self.delegate event:uuid event:1 error:0];
        }
        return false;
    }
    */
    
    NSURLSessionConfiguration *sessionConfig=[NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 5.0f;//请求超时时间
    sessionConfig.allowsCellularAccess=true;//是否允许蜂窝网络缓存（2G/3G/4G）
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    taskSession = [TaskSession new];
    taskSession.uuid = uuid;
    taskSession.data = [[NSMutableData alloc] init];
    
    
    //[dataTask setValue:uuid forKey:@"uuid"];
    NSUInteger taskIdentifier = arc4random() % ((arc4random() % 10000 + arc4random() % 10000));
    [dataTask setValue:@(taskIdentifier) forKeyPath:@"taskIdentifier"];
    
    [self.uuidMap setValue:uuid forKey:@(taskIdentifier).stringValue];
    [self.sessions setValue:taskSession forKey:uuid];
    //[self.sessions setValue:taskSession forKey:@(taskIdentifier).stringValue];
    [self.tasks setValue:dataTask forKey:uuid];
    
    [dataTask resume];//恢复线程，启动任务,开始请求
    //[self.suspend setValue:@"NO" forKey:uuid];
    
    DLRate *rate = [DLRate new];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long date = (long long)time;
    rate.uuid = uuid;
    rate.bytes = 0;
    rate.last_tick = date;
    [self.DownloadRate setObject:rate forKey:uuid];
    return true;
}

-(BOOL *)get_m3u8_url:(NSString *)uuid
{
    NSURLSession *session = [NSURLSession sharedSession];
    //NSString *format = [NSString stringWithFormat:@"http://www.appshopping.store/app/program_source?uuid=%@&cert=12345", uuid];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.appshopping.store/app/program_source?uuid=%@&cert=12345", uuid]];
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError* error) {
        if(error)
        {
            if(self.delegate)
            {
                [self.delegate event:uuid event:-1 error:0];
            }
        }
        else
        {
            //NSString *dataStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString *dstUrl = dict[@"object"][@"video_uri"];
            dstUrl = [dstUrl stringByReplacingOccurrencesOfString:@"%3D%3D" withString:@""];
            //NSLog(@"dstUrl: %@", dstUrl);
            [self download_m3u8_file:uuid url:dstUrl];
        }
    }];
    
    // 启动任务
    [task resume];
    return true;
}

#pragma mark - 代理
#pragma mark NSURLSessionDataDelegate
/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //NSInteger totalLength = [response.allHeaderFields[@"Content-Length"] integerValue];
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    //TaskSession *taskSession = [self.sessions objectForKey:@(dataTask.taskIdentifier).stringValue];
    NSString *uuid = [self.uuidMap objectForKey:@(dataTask.taskIdentifier).stringValue];
    TaskSession *taskSession = [self.sessions objectForKey:uuid];
    [taskSession.data appendData:data];
   //[sessionModel.stream write:data.bytes maxLength:data.length];
}

/**
 * 请求完毕（成功|失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    //TaskSession *taskSession = [self.sessions objectForKey:@(task.taskIdentifier).stringValue];
    NSString *uuid = [self.uuidMap objectForKey:@(task.taskIdentifier).stringValue];
    TaskSession *taskSession = [self.sessions objectForKey:uuid];

    if(!error)
    {
        NSString *dataStr=[[NSString alloc]initWithData:taskSession.data encoding:NSUTF8StringEncoding];
        //NSLog(@"%s %@", __func__, taskSession.uuid);
        taskSession.tsArray = [self parse_m3u8_file:taskSession.uuid src:dataStr];
        if(self.delegate && taskSession.tsArray.count <= 0)
        {
            [self.delegate event:uuid event:-3 error:0];
        }
        [self update_dowload_total:uuid total:(int)taskSession.tsArray.count - 1];
        for(int i = 0; i < taskSession.tsArray.count; i++)
        {
            Program *pg = taskSession.tsArray[i];
            DownloadFile *df = [[DownloadFile alloc] init];
            df.delegate = self;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *str1 = NSHomeDirectory();
            NSString *filepath = [NSString stringWithFormat:@"%@/Documents/programs/%@/",str1,taskSession.uuid];
            
            if(![fileManager fileExistsAtPath:filepath]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
                NSLog(@"create download directry");
                NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                NSString *directryPath = [path stringByAppendingFormat:@"/programs/%@/", taskSession.uuid];
                [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            filepath = [filepath stringByAppendingFormat:@"%@", pg.file];

            if(![self file_exist:filepath])
            {
                [df download:pg.uuid seg:pg.ts_seg_no file:filepath url:pg.src];
                break;
            }
            
        }
    }
    else
    {
        NSLog(@"didCompleteWithError");
        [self.delegate event:uuid event:-3 error:0];

    }
    [self.tasks removeObjectForKey:taskSession.uuid];
    [self.sessions removeObjectForKey:@(task.taskIdentifier).stringValue];
}

-(void)receive_byte:(NSString *)uuid seg:(int)seg byte:(long)bytes
{
    //NSLog(@"%@ seg %d receive_byte: %lu", uuid, seg, bytes);
    DLRate *rate = [self.DownloadRate objectForKey:uuid];
    //NSLog(@"recevie rate %0x", rate);
    if(self.delegate && rate)
    {
        //NSLog(@"recevie");
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        long long date = (long long)time;
        rate.bytes += bytes;
        if(date - rate.last_tick >= 1)
        {
            double r = (rate.bytes/1024.00)/(date - rate.last_tick);
            [self.delegate rate:rate.uuid rate:r];
            //NSLog(@"recevie %f", r);
            rate.bytes = 0;
            rate.last_tick = date;
        }
    }
}

-(void)download_state:(NSString *)uuid seg:(int)seg state:(DownloadState)state
{
    TaskSession *taskSession = [self.sessions objectForKey:uuid];

    long count =(long) taskSession.tsArray.count;
    NSString *suspend = [self.suspend objectForKey:uuid];
    //NSLog(@"suspend: %@", suspend);
    if([suspend isEqualToString:@"YES"] || stop)
    {
        [self.delegate rate:uuid rate:0];
        return;
    }
    if(state == DownloadStateCompleted)
    {
        [self update_dowload_completed:uuid completed:seg];
        seg++;
        if(seg < count)
        {
            Program *pg = taskSession.tsArray[seg];
            DownloadFile *df = [[DownloadFile alloc] init];
            df.delegate = self;
            NSString *str1 = NSHomeDirectory();
            NSString *filepath = [NSString stringWithFormat:@"%@/Documents/programs/%@/",str1, uuid];
            filepath = [filepath stringByAppendingFormat:@"%@", pg.file];
            if(![self file_exist:filepath])
            {
                [df download:pg.uuid seg:pg.ts_seg_no file:filepath url:pg.src];
            }
            //NSLog(@"Seg %d DownloadCompleted", seg);
        }
        else
        {
            [self.suspend removeObjectForKey:uuid];
            NSLog(@"AllDownloadCompleted");
            if(self.delegate)
            {
                [self.delegate rate:uuid rate:0];
                [self.delegate event:uuid event:2 error:0];
            }
        }
        
        if(self.delegate)
        {
            [self.delegate progress:uuid progress:(float)seg/(float)count];
        }
    }
    else if(state == DownloadStateFailed)
    {
        NSLog(@"download failed");
        Program *pg = taskSession.tsArray[seg];
        DownloadFile *df = [[DownloadFile alloc] init];
        df.delegate = self;
        NSString *str1 = NSHomeDirectory();
        NSString *filepath = [NSString stringWithFormat:@"%@/Documents/programs/%@/",str1, uuid];
        filepath = [filepath stringByAppendingFormat:@"%@", pg.file];
        if(![self file_exist:filepath])
        {
            [df download:pg.uuid seg:pg.ts_seg_no file:filepath url:pg.src];
        }
        NSLog(@"redownload seg %d", pg.ts_seg_no);
    }
}

-(NSMutableArray *)parse_m3u8_file:(NSString *)uuid src:(NSString *)src
{
    NSMutableArray *ts_array = [NSMutableArray array];
    NSArray *lines; /*将文件转化为一行一行的*/
    NSString *ext_x_version;
    NSString *ext_x_targetduration;
    
    lines = [src componentsSeparatedByString:@"\r\n"];
    for(int i = 0; i < lines.count; i++ )
    {
        NSString *str = lines[i];
        if([str containsString:@"#EXTM3U"])
        {
            
        }
        else if([str containsString:@"#EXT-X-TARGETDURATION"])
        {
            NSString* content = [lines[i] stringByReplacingOccurrencesOfString:@"#EXT-X-TARGETDURATION:" withString:@""];
            content = [content stringByReplacingOccurrencesOfString:@"," withString:@""];
            int targetduration = [content intValue];
            NSLog(@"targetduration: %d", targetduration);
            ext_x_targetduration = lines[i];
        }
        else if([str containsString:@"#EXT-X-VERSION"])
        {
            ext_x_version = lines[i];
            NSString* content = [lines[i] stringByReplacingOccurrencesOfString:@"#EXT-X-VERSION:" withString:@""];
            content = [content stringByReplacingOccurrencesOfString:@"," withString:@""];
            int version = [content intValue];
            NSLog(@"version: %d", version);
        }
        else if([str containsString:@"#EXTINF"])
        {
            NSString* content = [lines[i] stringByReplacingOccurrencesOfString:@"#EXTINF:" withString:@""];
            content = [content stringByReplacingOccurrencesOfString:@"," withString:@""];
            double seconds = [content doubleValue];
            int ts_seg_no = -1;
            i++;
            NSString *src = lines[i];
            NSArray *params = [src componentsSeparatedByString:@"&"];
            {
                for(int j = 0; j < params.count; j++)
                {
                    //NSLog(@"params= %@", params[j]);
                    if([params[j] containsString:@"ts_seg_no"])
                    {
                        NSString *src = params[j];
                        NSArray *seg_no = [src componentsSeparatedByString:@"="];
                        ts_seg_no = [seg_no[1] intValue];
                    }
                }
            }
            
            Program *program = [Program new];
            program.uuid = uuid;
            program.seconds = seconds;
            program.ts_seg_no = ts_seg_no;
            program.completed = 0;
            program.src = src;
            program.file = [@"" stringByAppendingFormat:@"program_%d.ts",ts_seg_no]; //]@"ts/xxx_.ts";
            [ts_array addObject:program];
            
            //NSLog(@"file: %@", program.file);
        }
        else if([str containsString:@"#EXT-X-ENDLIST"])
        {
            NSLog(@"m3u8 file end");
        }
    }
    
    if(ts_array.count > 0)
    {
        NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *homePath = [paths objectAtIndex:0];
        
        //NSString *filePath = [homePath stringByAppendingPathComponent:@"text.m3u8"];
        NSString *filePath = [homePath stringByAppendingFormat:@"/%@.m3u", uuid];
        //NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *str = @"#EXTM3U\r\n";
        
        str = [str stringByAppendingFormat:@"%@\r\n", ext_x_targetduration];
        
        str = [str stringByAppendingFormat:@"%@\r\n", ext_x_version];
        
        for(int i = 0; i < ts_array.count; i++)
        {
            Program *program = ts_array[i];
            str = [str stringByAppendingFormat:@"#EXTINF:%0.02f,\r\n",program.seconds]; //#EXTINF:12.0,
            str = [str stringByAppendingFormat:@"programs/%@/%@\r\n",program.uuid,program.file];
        }
        
        str = [str stringByAppendingString:@"#EXT-X-ENDLIST"];
        [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"m3u8 path: %@", filePath);
    }
    
    return ts_array;
}

-(BOOL)file_exist:(NSString *)url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:url]) {
        return false;
    }
    return true;
}

-(NSArray *)search_m3u_file
{
    NSMutableArray *m3uArray = [NSMutableArray array];
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *homePath = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *files = [fileManager contentsOfDirectoryAtPath:homePath error:nil];
    for(int i = 0; i < files.count; i++)
    {
        NSString *filename = files[i];
        if([filename containsString:@".m3u"])
        {
            //NSString *uuid = [filename stringByReplacingOccurrencesOfString:@".m3u" withString:@""];
            [m3uArray addObject:filename];
            //NSString *filepath = [homePath stringByAppendingFormat:@"/%@", filename];
            //NSString* content = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
            
            //int count = [self parse_local_m3u_file:uuid src:content];
            //NSLog(@"count: %d", count);

            //NSLog(@"file: %@", files[i]);
            //count = [self search_ts_file:uuid];
            //NSLog(@"search_ts: %d", count);

            /*
            for (NSString *s in [_programDict allKeys]) {
                NSLog(@"1 key: %@", s);
                ProgramCache *pcache = [_programDict objectForKey:s];
                for (NSString *s in [pcache.tsDict allKeys]) {
                    NSLog(@"2 key: %@", s);
                }
            }
             */
        }
    }
    /*
    NSDirectoryEnumerator *myDirectoryEnumerator;
    myDirectoryEnumerator=[fileManager enumeratorAtPath:homePath];
    NSString *file;
    while((file=[myDirectoryEnumerator nextObject])!=nil)
    {
        BOOL isDir;
        [fileManager fileExistsAtPath:file isDirectory:&isDir];
        NSLog(@"search %d--->: %@",isDir, file);
    }
    */
    return m3uArray;
}

-(int)search_ts_file:(NSString *)uuid
{
    int count = 0;
    ProgramCache *pcache = [[ProgramCache alloc] init];
    pcache.tsDict = [NSMutableDictionary dictionary];
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *homePath = [paths objectAtIndex:0];
    homePath = [homePath stringByAppendingFormat:@"/programs/%@/", uuid];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *files = [fileManager contentsOfDirectoryAtPath:homePath error:nil];
    for(int i = 0; i < files.count; i++)
    {
        NSString *filename = files[i];
        if([filename containsString:@".ts"])
        {
            count++;
            //NSString *ts = [filename stringByReplacingOccurrencesOfString:@".ts" withString:@""];
            //NSLog(@"ts: %@", ts);
            [pcache.tsDict setObject:uuid forKey:filename];
        }
    }
    [_programDict setObject:pcache forKey:uuid];
    return count;
}

-(NSArray *)get_download_list
{
    NSMutableArray *retArray = [NSMutableArray array];
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *homePath = [paths objectAtIndex:0];
    NSArray *m3uArray = [self search_m3u_file];
    for(int i = 0; i < m3uArray.count; i++)
    {
        NSString *filename = m3uArray[i];
        NSString *uuid = [m3uArray[i] stringByReplacingOccurrencesOfString:@".m3u" withString:@""];
        NSString *filepath = [homePath stringByAppendingFormat:@"/%@", filename];
        NSString* content = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
        ProgramCache *proCache = [_programDict objectForKey:uuid];
        if(proCache)
        {
            proCache.total = [self parse_local_m3u_file:uuid src:content];
            proCache.completed = [self search_ts_file:uuid];
            [retArray addObject:proCache];
        }
    }
    return retArray;
}

-(int)parse_local_m3u_file:(NSString *)uuid src:(NSString *)src
{
    int count = 0;
    NSArray *lines; /*将文件转化为一行一行的*/
    NSString *ext_x_version;
    NSString *ext_x_targetduration;
    
    lines = [src componentsSeparatedByString:@"\r\n"];
    for(int i = 0; i < lines.count; i++ )
    {
        NSString *str = lines[i];
        if([str containsString:@"#EXTM3U"])
        {
            
        }
        else if([str containsString:@"#EXT-X-TARGETDURATION"])
        {
            NSString* content = [lines[i] stringByReplacingOccurrencesOfString:@"#EXT-X-TARGETDURATION:" withString:@""];
            content = [content stringByReplacingOccurrencesOfString:@"," withString:@""];
            int targetduration = [content intValue];
            NSLog(@"local targetduration: %d", targetduration);
            ext_x_targetduration = lines[i];
        }
        else if([str containsString:@"#EXT-X-VERSION"])
        {
            ext_x_version = lines[i];
            NSString* content = [lines[i] stringByReplacingOccurrencesOfString:@"#EXT-X-VERSION:" withString:@""];
            content = [content stringByReplacingOccurrencesOfString:@"," withString:@""];
            int version = [content intValue];
            NSLog(@"local version: %d", version);
        }
        else if([str containsString:@"#EXTINF"])
        {
            NSString* content = [lines[i] stringByReplacingOccurrencesOfString:@"#EXTINF:" withString:@""];
            content = [content stringByReplacingOccurrencesOfString:@"," withString:@""];
            //double seconds = [content doubleValue];
            //int ts_seg_no = -1;
            count++;
        }
        else if([str containsString:@"#EXT-X-ENDLIST"])
        {
            NSLog(@"local m3u8 file end");
        }
    }
    
    return count;
}

@end
