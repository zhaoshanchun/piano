//
//  UIView+Loading.m
//  OpenSnap
//
//  Created by hangyuen on 8/12/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import "UIView+Loading.h"

#import <objc/runtime.h>

@implementation UIView (Loading)

static void * LoadingViewPropertyKey = &LoadingViewPropertyKey;

- (UIView *)loadingView {
    UIView *v = objc_getAssociatedObject(self, LoadingViewPropertyKey);
    if (v == nil) {
        v = [[UIView alloc] initWithFrame:self.bounds];
        v.backgroundColor = [[UIColor orBackgroundColor] colorWithAlphaComponent:0.5];

        UIActivityIndicatorView *iv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [v addSubview:iv];
        [iv setColor:[UIColor colorForKey:@"o"]];
        [iv startAnimating];
        iv.center = v.center;

//        UIResponder *parentResponder = self.nextResponder;
//        if ([parentResponder isKindOfClass:[UIBaseViewController class]]) {
//            if ([(UIBaseViewController *)parentResponder navigationBarTranslucent]) {
//                iv.center = (CGPoint){ iv.center.x, iv.center.y + (NAVIGATION_BAR_HEIGHT+STATUS_BAR_HEIGHT) / 2 };
//            }
//        }
        objc_setAssociatedObject(self, LoadingViewPropertyKey, v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return v;
}
- (void)showLoading {
    if (self.loadingView.superview == nil) {
        [self addSubview:self.loadingView];
    }
}


- (void)hideLoading {
    if (!self.loadingView.superview) return;
    
    UIView *v = self.loadingView;
    objc_setAssociatedObject(self, LoadingViewPropertyKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [v removeFromSuperview];
    v = nil;
}

@end
