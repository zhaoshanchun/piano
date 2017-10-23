//
//  PracticeListCellModel.h
//  apps
//
//  Created by zhaosc on 2017/10/23.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PracticeListCellModel : NSObject

@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSAttributedString *documentNameAttribute;
@property (assign, nonatomic) CGFloat cellHeight;

@end
