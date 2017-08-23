//
//  LBToAppStore.h
//  LBToAppStore
//
//  Created by gold on 16/5/3.
//  Copyright © 2016年 Bison. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@protocol LBToAppStoreDelegate <NSObject>
/**弹出对话框代理*/
- (void)ShowButtonAction;
/**确定按钮代理*/
- (void)SureButtonAction;
/**取消按钮代理*/
- (void)CancelButtonAction;
@end


@interface LBToAppStore : NSObject<UIAlertViewDelegate> {
    #if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    UIAlertView *alertViewTest;
    #else
    UIAlertController *alertController;
    #endif
}

@property (nonatomic,assign) BOOL rep;
@property (nonatomic,strong) NSString * myAppID;//appID
/**代理人*/
@property (nonatomic,weak) id<LBToAppStoreDelegate> delegate;

- (void)showGotoAppStore:(UIViewController *)VC Rep:(BOOL)rep_;

@end
