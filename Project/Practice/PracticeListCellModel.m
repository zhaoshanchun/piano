//
//  PracticeListCellModel.m
//  apps
//
//  Created by zhaosc on 2017/10/23.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "PracticeListCellModel.h"

@implementation PracticeListCellModel

- (void)setPath:(NSString *)path {
    if (path.length == 0) {
        return;
    }
    _path = path;
    // var/containers/Bundle/Application/15D57C48-336A-4ED8-86C6-3E59BD356557/apps.app/2018年护士执业考试外科护理考试测试题1.docx
    
    // NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    // /var/containers/Bundle/Application/FE7B06B7-8085-4144-BE71-364A5C2C3B38/apps.app/2018护士资格证考试第八套全真模拟题单选题.docx
    NSString *targetName = [NSString stringWithFormat:@"%@%@", kAPPTarget, @".app"];
    NSRange range = [path rangeOfString:targetName options:NSLiteralSearch];
    NSInteger location = range.location + range.length + 1;
    NSString *documentName = [path substringFromIndex:location];
    NSLog(@"documentName = %@", documentName);
    documentName = [documentName stringByReplacingOccurrencesOfString:kDocumentType withString:@""];
    NSLog(@"documentName = %@", documentName);
    
    self.documentNameAttribute = formatAttributedStringByORFontGuide(@[documentName, @"BR15N"], nil);
    CGSize size = getSizeForAttributedString(self.documentNameAttribute, SCREEN_WIDTH - 10*2, MAXFLOAT);
    self.cellHeight = size.height + 15*2;
}

@end
