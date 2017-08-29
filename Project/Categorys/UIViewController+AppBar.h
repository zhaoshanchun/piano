//
//  UIViewController+AppBar.h
//  OpenSnap
//
//  Created by hangyuen on 6/10/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kORNavigationBarItemMaxW 44

@interface UIViewController (AppBar) <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIScrollView *scrollViewForTabBar;
@property (weak, nonatomic) UIScrollView *scrollViewForHideNavBar;
@property (assign, nonatomic) CGFloat topInsetForNavBar;

// app bar helper
// return alpha value for the nav bar
// return -1 if the scroll view is not assigned one
- (CGFloat)scrollViewDidScrollForHideNavBar:(UIScrollView *)scrollView;
- (void)updateColorForNavBar:(UIColor *)color withAlpha:(CGFloat)alpha;
- (void)resetHiddenNavBar;
- (void)resetHiddenTabBar;

- (void)showBottomWithAnimated:(BOOL)animated;
- (void)hideBottomWithAnimated:(BOOL)animated;

// nav bar item helper
- (void)setNavigationBarTitle:(NSString *)title;
- (void)setLeftBarItem:(NSArray *)items;
- (void)setLeftBarItem:(NSArray *)items space:(CGFloat)space;
- (void)setRightBarItem:(NSArray *)items;
- (void)setRightBarItem:(NSArray *)items space:(CGFloat)space;
- (void)setLeftBarItem:(NSArray *)items pedding:(CGFloat)pedding space:(CGFloat)space;
- (void)setRightBarItem:(NSArray *)items pedding:(CGFloat)pedding space:(CGFloat)space;

// set Snap logo
- (void)showSnapLogoNavigationBar;
// set back button
- (UIButton *)setLeftBackButton;
// set white color back button
- (UIButton *)setWtLeftBackButton;
// set close button
- (UIButton *)setLeftCloseButton;
// set white color close button
- (UIButton *)setWtLeftCloseButton;
// set text based back button
- (UIButton *)setLeftBackButtonWithText:(NSString *)text fontKey:(NSString *)key;
- (void)removeLeftButton;
// set text button
- (UIButton *)setRightButtonWithText:(NSString *)text fontKey:(NSString *)key target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (UIButton *)setRightButtonWithText:(NSString *)text selectedText:(NSString *)selectedText fontKey:(NSString *)key
                              target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (UIButton *)setRightButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (UIButton *)setLeftButtonWithText:(NSString *)text fontKey:(NSString *)key target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeRightButton;

// button action for sub-class override
- (void)onBtnBackTouchUpInside:(UIButton *)btn;
- (void)onBtnBackTouchUpInside:(UIButton *)btn completion:(void (^ )(void))completion;

@end


