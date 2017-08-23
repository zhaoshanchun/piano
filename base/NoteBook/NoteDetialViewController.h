//
//  NoteDetialViewController.h
//  NoteBook
//
//  Created by zx_06 on 15/5/26.
//  Copyright (c) 2015年 sunshilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteBook.h"
@interface NoteDetialViewController : UIViewController

@property (nonatomic, strong) UILabel    *detialName;    //详情名字
@property (nonatomic, strong) UILabel    *detialType;    //详情类型
@property (nonatomic, strong) UILabel    *detialTime;    //详情时间
@property (nonatomic, strong) UITextView *detialContent; //详情内容
@property (retain, nonatomic) NoteBook          *detialNoteBook;//转存notebook

- (void)initDetialLabels;

@end
