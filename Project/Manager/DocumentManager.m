//
//  DocumentManager.m
//  apps
//
//  Created by zhaosc on 2017/10/23.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "DocumentManager.h"


@interface DocumentManager ()

@property (strong, nonatomic) NSArray *documentPathArray;
@property (strong, nonatomic) NSMutableArray *cacheDocuments;
@property (nonatomic, strong) DocumentBackHndler backHandler;

@end

@implementation DocumentManager

static DocumentManager *_sharedManager;

+ (DocumentManager *)sharedManager {
    @synchronized(self) {
        if (!_sharedManager) {
            _sharedManager = [[DocumentManager alloc] init];
        }
    }
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        /*
        self.documentPathArray = @[@"2018护士资格证考试第八套全真模拟题单选题.docx",
                               @"2018护士资格证考试第八套全真模拟题多选题.docx",
                               @"2018护士资格证考试第二套全真模拟题单选题.docx",
                               @"2018护士资格证考试第二套全真模拟题多选题.docx",
                               @"2018护士资格证考试第六套全真模拟题单选题.docx",
                               @"2018护士资格证考试第六套全真模拟题多选题.docx",
                               @"2018护士资格证考试第七套全真模拟题单选题.docx",
                               @"2018护士资格证考试第七套全真模拟题多选题.docx",
                               @"2018护士资格证考试第三套全真模拟题单选题.docx",
                               @"2018护士资格证考试第三套全真模拟题多选题.docx",
                               @"2018护士资格证考试第四套全真模拟题单选题.docx",
                               @"2018护士资格证考试第四套全真模拟题多选题.docx",
                               @"2018护士资格证考试第五套全真模拟题单选题.docx",
                               @"2018护士资格证考试第五套全真模拟题多选题.docx",
                               @"2018护士资格证考试第一套全真模拟题单选题.docx",
                               @"2018护士资格证考试第一套全真模拟题多选题.docx",
                               @"2018护士资格证考试试题：心律失常答案（1）.docx",
                               @"2018护士资格证考试试题：心律失常答案（2）.docx",
                               @"2018护士资格证考试试题：心律失常答案（3）.docx",
                               @"2018护士资格证考试试题：心律失常答案（4）.docx",
                               @"2018护士资格证考试试题心脏骤停试题3A1型题1.docx",
                               @"2018护士资格证考试试题心脏骤停试题3A1型题2.docx",
                               @"2018护士资格证考试试题心脏骤停试题3A2型题.docx",
                               @"2018护士资格证考试试题心脏骤停试题3A3/4型题.docx",
                               @"2018护士资格证考试试题心脏骤停试题4.docx",
                               @"2018年护士执业考试外科护理考试测试题1.docx",
                               @"2018年护士执业考试外科护理考试测试题2.docx",
                               @"2018年护士执业考试外科护理考试测试题3.docx",
                               @"2018年护士执业考试外科护理考试测试题4.docx",
                               @"2018年护士执业考试外科护理考试测试题5.docx",
                               @"2018年护士执业考试外科护理考试测试题6.docx",
                               @"2018年护士执业考试外科护理考试测试题7.docx",
                               @"2018年护士执业考试外科护理考试测试题8.docx",
                               @"2018年护士执业考试外科护理考试测试题9.docx",
                               @"2018年护士执业考试外科护理考试测试题10.docx",
                               @"2018年护士执业资格考试《基础知识》测试题1.docx",
                               @"2018年护士执业资格考试《基础知识》测试题2.docx",
                               @"2018年护士执业资格考试《基础知识》测试题3.docx",
                               @"2018年护士执业资格考试《基础知识》测试题4.docx",
                               @"2018年护士执业资格考试《基础知识》测试题5.docx",
                               @"2018年护士执业资格考试《基础知识》测试题6.docx",
                               @"2018年护士资格考试妇产科护理学模拟试题二.docx",
                               @"2018年护士资格考试妇产科护理学模拟试题三.docx",
                               @"2018年护士资格考试妇产科护理学模拟试题四.docx",
                               @"2018年护士资格考试妇产科护理学模拟试题五.docx",
                               @"2018年护士资格考试妇产科护理学模拟试题一.docx",
                               @"2018年护士资格考试试题A3／A4型题2.docx",
                               @"2018年护士资格考试试题A3／A4型题3.docx",
                               @"2018年护士资格考试试题A3／A4型题4.docx",
                               @"2018年护士资格考试试题A3／A4型题5.docx",
                               @"2018年护士资格考试试题A3A4型题1.docx",
                               @"2018年护士资格证《实践能力》试题及答案第十套3.docx",
                               @"2018年护士资格证《实践能力》试题及答案第十一套2.docx",
                               @"2018年护士资格证考试《儿科护理学》精选试题(1).docx",
                               @"2018年护士资格证考试《儿科护理学》精选试题(2).docx",
                               @"2018年护士资格证考试《儿科护理学》精选题(3).docx",
                               @"2018年护士资格证考试《儿科护理学》精选题(4).docx",
                               @"2018年护士资格证考试《儿科护理学》精选题(5).docx",
                               @"护士执业考试专业实务备考指导试题2.docx",
                               @"护士执业资格考试专业实务备考指导试题1.docx"];
        */
        
        
        self.cacheDocuments = [NSMutableArray array];
        self.documentPathArray = [[NSBundle mainBundle] pathsForResourcesOfType:kDocumentType inDirectory:nil];
        
        // NSString *path = [[NSBundle mainBundle] pathForResource:@"2018护士资格证考试第八套全真模拟题单选题.docx" ofType:nil];
        // path = /var/containers/Bundle/Application/FE7B06B7-8085-4144-BE71-364A5C2C3B38/apps.app/2018护士资格证考试第八套全真模拟题单选题.docx
    }
    return self;
}

- (void)getDocumentFrom:(NSInteger)fromIndex count:(NSInteger)count backHandler:(DocumentBackHndler)handler {
    self.backHandler = handler;
    [self.cacheDocuments removeAllObjects];
    
    if (self.documentPathArray.count == 0 || fromIndex >= self.documentPathArray.count) {
        [self performSelector:@selector(response) withObject:nil afterDelay:1.f];
        return;
    } else {
        for (NSInteger i = fromIndex; i < self.documentPathArray.count && i < (fromIndex + count); i++) {
            [self.cacheDocuments addObject:[self.documentPathArray objectAtIndex:i]];
        }
    }
    [self performSelector:@selector(response) withObject:nil afterDelay:1.f];
}

- (void)response {
    if (self.backHandler) {
        self.backHandler(self.cacheDocuments);
    }
    [self.cacheDocuments removeAllObjects];
}

@end
