//
//  HistoryView.h
//  sifakaoshi
//
//  Created by kun on 2017/6/28.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalValue.h"

@protocol HistoryViewDelegate <NSObject>
/**返回点击代理*/
- (void)onClickHistoryView:(VideoObject *)object;
@end

@interface HistoryView : UIView
@property (nonatomic,weak) id<HistoryViewDelegate> delegate;
-(void)historyReload;
@end
