//
//  UIView+Loading.h
//  OpenSnap
//
//  Created by hangyuen on 8/12/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Loading)

@property (nonatomic, readonly) UIView *loadingView;    // for customize the

- (void)showLoading;
- (void)hideLoading;

@end
