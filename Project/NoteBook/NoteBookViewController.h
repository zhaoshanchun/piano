//
//  NoteBookViewController.h
//  riyusuxue
//
//  Created by kun on 2017/5/19.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteBook.h"
#import "BaseViewController.h"

@interface NoteBookViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>
{
    NSMutableArray *dataArray; //数据数组，可变，方便增删
}

@property (weak, nonatomic) UILabel         *detialName;    //详情名字
@property (weak, nonatomic) UILabel         *detialType;    //详情类型
@property (weak, nonatomic) UILabel         *detialTime;    //详情时间
@property (weak, nonatomic) UITextView      *detialContent; //详情内容
@property (retain, nonatomic) NoteBook      *detialNoteBook;//转存notebook

@end
