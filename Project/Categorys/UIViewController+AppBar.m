//
//  UIViewController+AppBar.m
//  OpenSnap
//
//  Created by hangyuen on 6/10/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import "UIViewController+AppBar.h"

#import "Common-Header.h"

#import <objc/runtime.h>

// #import "UIBaseViewController.h"

#import "OSButton.h"

#define TABBAR_ANIMATION_DURATION 0.3

static void * ScrollViewForTabBarPropertyKey = &ScrollViewForTabBarPropertyKey;
static void * ScrollViewForHideNavBarPropertyKey = &ScrollViewForHideNavBarPropertyKey;

static void * ScrollViewDelegatePropertyKey = &ScrollViewDelegatePropertyKey;

@implementation UIViewController (AppBar)

static CGRect _originalFrameForTabBar;
static CGRect _hiddenFrameForTabBar;
static BOOL _showTabBar;
static CGFloat _topInsetForTabBar;

- (UIScrollView *)scrollViewForTabBar {
    return objc_getAssociatedObject(self, ScrollViewForTabBarPropertyKey);
}

- (void)setScrollViewForTabBar:(UIScrollView *)sview {
    objc_setAssociatedObject(self, ScrollViewForTabBarPropertyKey, sview, OBJC_ASSOCIATION_ASSIGN);
    
    if (sview) {
        _showTabBar = YES;
        if (CGRectEqualToRect(_originalFrameForTabBar, CGRectZero)) {
            _originalFrameForTabBar = self.tabBarController.tabBar.frame;
            _originalFrameForTabBar.origin.x = 0;
            
            _hiddenFrameForTabBar = _originalFrameForTabBar;
            _hiddenFrameForTabBar.origin.y = [UIScreen mainScreen].bounds.size.height;
        }
        
        BOOL hasPanRecognizer = NO;
        for (UIGestureRecognizer *recognizer in sview.gestureRecognizers) {
            if (recognizer.delegate == self && [recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                hasPanRecognizer = YES;
                break;
            }
        }
        
        if (!hasPanRecognizer) {
            UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerShouldBegin:)];
            panGestureRecognizer.maximumNumberOfTouches = 1;
            panGestureRecognizer.delegate = self;
            panGestureRecognizer.minimumNumberOfTouches = 1;
            panGestureRecognizer.cancelsTouchesInView = NO;
            [sview addGestureRecognizer:panGestureRecognizer];
        }
        
        if (IS_IOS_6_OR_BELOW) {
            // iOS 6
            [[self.tabBarController.view.subviews objectAtIndex:0] setFrame:[[UIScreen mainScreen] bounds]];
        }
    }
}

- (UIScrollView *)scrollViewForHideNavBar {
    return objc_getAssociatedObject(self, ScrollViewForHideNavBarPropertyKey);
}

- (void)setScrollViewForHideNavBar:(UIScrollView *)sview {
    objc_setAssociatedObject(self, ScrollViewForHideNavBarPropertyKey, sview, OBJC_ASSOCIATION_ASSIGN);
    
    if (sview) {
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
}

- (id<NSObject,UIScrollViewDelegate>)scrollViewDelegate {
    return objc_getAssociatedObject(self, ScrollViewDelegatePropertyKey);
}

- (void)setScrollViewDelegate:(id<NSObject,UIScrollViewDelegate>)delegate {
    objc_setAssociatedObject(self, ScrollViewDelegatePropertyKey, delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)topInsetForNavBar {
    return _topInsetForTabBar;
}

- (void)setTopInsetForNavBar:(CGFloat)height {
    _topInsetForTabBar = height;
}

- (void)resetHiddenNavBar {
    self.scrollViewForHideNavBar = nil;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1.0;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    if ([UINavigationBar instancesRespondToSelector:@selector(setBarTintColor:)]) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    }
}

- (void)resetHiddenTabBar {
    self.scrollViewForTabBar = nil;
    UITabBar *tb = self.tabBarController.tabBar;
    tb.frame = _originalFrameForTabBar;
    _showTabBar = YES;
    
    [tb.layer removeAllAnimations];
}

#pragma mark - UIGestureRecognizerDelegates

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    UIView *cell = [gestureRecognizer view];
    if ([gestureRecognizer respondsToSelector:@selector(velocityInView:)]) {
        CGPoint velocity = [gestureRecognizer velocityInView:gestureRecognizer.view];
        if (ABS(velocity.x) < ABS(velocity.y)) {
            CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
            if (translation.y > 0.f) {
                [self showBottomWithAnimated:YES];
            } else {
                [self hideBottomWithAnimated:YES];
            }
        }
    }
    return YES;
}

- (void)showBottomWithAnimated:(BOOL)animated {
    if (!_showTabBar) {
        _showTabBar = !_showTabBar;
        
        if (!CGRectEqualToRect(_originalFrameForTabBar, CGRectZero)) {
            UITabBar *tb = self.tabBarController.tabBar;
            if (animated) {
                [UIView animateWithDuration:TABBAR_ANIMATION_DURATION animations:^(){
                    tb.frame = _originalFrameForTabBar;
                }];
            } else {
                tb.frame = _originalFrameForTabBar;
            }
        }
    }
}

- (void)hideBottomWithAnimated:(BOOL)animated {
    if (_showTabBar) {
        _showTabBar = !_showTabBar;
        
        if (!CGRectEqualToRect(_originalFrameForTabBar, CGRectZero)) {
            UITabBar *tb = self.tabBarController.tabBar;
            if (animated) {
                [UIView animateWithDuration:TABBAR_ANIMATION_DURATION animations:^(){
                    tb.frame = _hiddenFrameForTabBar;
                }];
            } else {
                tb.frame = _hiddenFrameForTabBar;
            }
        }
    }
}

#pragma mark - UINavigationBar helper

- (void)setNavigationBarTitle:(NSString *)title {
    UIFont *font = nil;
    UIColor *color = nil;
    
    setFontAndTextColorForFontKey(@"br17N", &font, &color);
    CGSize size = getSizeForString(title, font, self.view.bounds.size.width, self.navigationController.navigationBar.frame.size.height);

//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-size.width)/2, (self.navigationController.navigationBar.frame.size.height-size.height)/2, size.width, size.height)];
    lbl.font = font;
    lbl.textColor = color;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = title;
    self.navigationItem.titleView = lbl;
}

- (void)setLeftBarItem:(NSArray *)items {
    [self setLeftBarItem:items space:-12];
}

- (void)setLeftBarItem:(NSArray *)items space:(CGFloat)space {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = nil;
    
    if (IS_IOS_7_OR_ABOVE) {
        // Create a negative spacer to go to the left of our custom back button,
        // and pull it right to the edge:
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = space;
        
        NSMutableArray *arr = [NSMutableArray arrayWithObject:negativeSpacer];
        [arr addObjectsFromArray:items];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithArray:arr];
    } else {
        if ([items count] == 1) {
            self.navigationItem.leftBarButtonItem = [items objectAtIndex:0];
        } else {
            self.navigationItem.leftBarButtonItems = items;
        }
    }
}

- (void)removeLeftButton {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = nil;
}

- (void)removeRightButton {
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
}

- (void)setRightBarItem:(NSArray *)items {
    [self setRightBarItem:items space:-6];
}

- (void)setRightBarItem:(NSArray *)items space:(CGFloat)space {
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
    
    if (IS_IOS_7_OR_ABOVE) {
        // Create a negative spacer to go to the left of our custom back button,
        // and pull it right to the edge:
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = space;
        
        NSMutableArray *arr = [NSMutableArray arrayWithObject:negativeSpacer];
        [arr addObjectsFromArray:items];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithArray:arr];
    } else {
        if ([items count] == 1) {
            self.navigationItem.rightBarButtonItem = [items objectAtIndex:0];
        } else {
            self.navigationItem.rightBarButtonItems = items;
        }
    }
}

- (void)setLeftBarItem:(NSArray *)items pedding:(CGFloat)pedding space:(CGFloat)space {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = nil;
    
    if (items.count > 1 && space > 0) {
        NSMutableArray *mitems = [items mutableCopy];
        for (int i=0;i<(items.count - 1);i++) {
            UIBarButtonItem *fixed =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                  target:nil action:nil];
            fixed.width = space;
            [mitems insertObject:fixed atIndex:(i*2)+1];
        }
        items = [NSArray arrayWithArray:mitems];
    }
    if (IS_IOS_7_OR_ABOVE) {
        // Create a negative spacer to go to the left of our custom back button,
        // and pull it right to the edge:
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = pedding;
        
        NSMutableArray *arr = [NSMutableArray arrayWithObject:negativeSpacer];
        [arr addObjectsFromArray:items];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithArray:arr];
    } else {
        if ([items count] == 1) {
            self.navigationItem.leftBarButtonItem = [items objectAtIndex:0];
        } else {
            self.navigationItem.leftBarButtonItems = items;
        }
    }
}

- (void)setRightBarItem:(NSArray *)items pedding:(CGFloat)pedding space:(CGFloat)space {
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
    
    if (items.count > 1 && space > 0) {
        NSMutableArray *mitems = [items mutableCopy];
        for (int i=0;i<(items.count - 1);i++) {
            UIBarButtonItem *fixed =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                  target:nil action:nil];
            fixed.width = space;
            [mitems insertObject:fixed atIndex:(i*2)+1];
        }
        items = [NSArray arrayWithArray:mitems];
    }
    if (IS_IOS_7_OR_ABOVE) {
        // Create a negative spacer to go to the left of our custom back button,
        // and pull it right to the edge:
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = pedding;
        
        NSMutableArray *arr = [NSMutableArray arrayWithObject:negativeSpacer];
        [arr addObjectsFromArray:items];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithArray:arr] animated:YES];
    } else {
        if ([items count] == 1) {
            [self.navigationItem setRightBarButtonItem:items[0] animated:YES];
        } else {
            [self.navigationItem setRightBarButtonItems:items animated:YES];
        }
    }
}


#pragma mark - UI helper

- (void)showSnapLogoNavigationBar {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a_common_header_ORlogo"]];
}

- (UIButton *)setLeftBackButtonWithImageKey:(NSString *)key tintColor:(UIColor *)tintColor {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage;
    if (tintColor) {
        backBtnImage = [[UIImage imageNamed:key] tintImageWithColor:tintColor];
    } else {
        backBtnImage = [UIImage imageNamed:key];
    }
    [backBtn setImage:backBtnImage forState:UIControlStateNormal];
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn addTarget:self action:@selector(onBtnBackTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setFrame:CGRectMake(0, 0, 44, 44)];
//#if (DEBUG)
//    backBtn.layer.borderWidth = 1.0;
//    backBtn.layer.borderColor = [[UIColor redColor] CGColor];
//#endif
    [self setLeftBarItem:@[[[UIBarButtonItem alloc] initWithCustomView:backBtn]] space:-6];
    return backBtn;
}

- (UIButton *)setLeftBackButtonWithImageKey:(NSString *)key {
    return [self setLeftBackButtonWithImageKey:key tintColor:nil];
}

- (UIButton *)setLeftBackButton {
    return [self setLeftBackButtonWithImageKey:@"common_back_arrow"];
}

- (UIButton *)setWtLeftBackButton {
    return [self setLeftBackButtonWithImageKey:@"common_back_arrow" tintColor:[UIColor whiteColor]];
}

- (UIButton *)setLeftCloseButton {
    return [self setLeftBackButtonWithImageKey:@"CommonIconClose"];
}
- (UIButton *)setWtLeftCloseButton{
    return [self setLeftBackButtonWithImageKey:@"CommonIconClose"];
}

- (UIButton *)setLeftBackButtonWithText:(NSString *)text fontKey:(NSString *)key {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:text forState:UIControlStateNormal];
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [backBtn setFontAndTextColorByKey:key forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onBtnBackTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize _s = getSizeForString(text, backBtn.titleLabel.font, CGFLOAT_MAX, CGFLOAT_MAX);
    [backBtn setFrame:CGRectMake(0, 0, MAX(_s.width + 6, 32), 44)];
    
    [self setLeftBarItem:@[[[UIBarButtonItem alloc] initWithCustomView:backBtn]]];
    
    return backBtn;
}

- (UIButton *)setRightButtonWithText:(NSString *)text fontKey:(NSString *)key
                              target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    
    return [self setRightButtonWithText:text selectedText:nil fontKey:key target:self action:action forControlEvents:controlEvents];
}

- (UIButton *)setRightButtonWithText:(NSString *)text selectedText:(NSString *)selectedText fontKey:(NSString *)key
                              target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btn setFontAndTextColorByKey:key forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    
    if ([selectedText length] > 0) {
        CGSize s1 = getSizeForString(text, btn.titleLabel.font, CGFLOAT_MAX, CGFLOAT_MAX);
        CGSize s2 = getSizeForString(selectedText, btn.titleLabel.font, CGFLOAT_MAX, CGFLOAT_MAX);
        [btn setFrame:(CGRect){{0, 0}, { MAX(32, MAX(s1.width, s2.width) + 6) , 44}}];
        [btn setTitle:selectedText forState:UIControlStateSelected];
    } else {
        CGSize _s = getSizeForString(text, btn.titleLabel.font, CGFLOAT_MAX, CGFLOAT_MAX);
        [btn setFrame:CGRectMake(0, 0, MAX(_s.width + 6, 32), 44)];
    }
    [self setRightBarItem:@[[[UIBarButtonItem alloc] initWithCustomView:btn]] space:-4];
    return btn;
}

- (UIButton *)setRightButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action
                     forControlEvents:(UIControlEvents)controlEvents {
    OSButton *settingBtn = [OSButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setBtnType:OSButtonTypeAlpha];
    [settingBtn setImage:image forState:UIControlStateNormal];
    [settingBtn sizeToFit];
    if (CGRectGetWidth(settingBtn.frame) < 44) {
        [settingBtn updateFrameWidth:44];
    }
    if (CGRectGetHeight(settingBtn.frame) < 44) {
        [settingBtn updateFrameHeight:44];
    }
    [settingBtn setImageEdgeInsets:(UIEdgeInsets){ 0, 44-image.size.width, 0, 0 }];
    [settingBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self setRightBarItem:@[[[UIBarButtonItem alloc] initWithCustomView:settingBtn]]];
    
    return settingBtn;
}

- (UIButton *)setLeftButtonWithText:(NSString *)text fontKey:(NSString *)key target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btn setFontAndTextColorByKey:key forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    
    CGSize _s = getSizeForString(text, btn.titleLabel.font, CGFLOAT_MAX, CGFLOAT_MAX);
    [btn setFrame:CGRectMake(0, 0, MAX(_s.width + 6, 32), 44)];
    
    [self setLeftBarItem:@[[[UIBarButtonItem alloc] initWithCustomView:btn]]];
    return btn;
}

#pragma mark -

- (void)onBtnBackTouchUpInside:(UIButton *)btn {
    [self onBtnBackTouchUpInside:btn completion:nil];
}

- (void)onBtnBackTouchUpInside:(UIButton *)btn completion:(void (^ __nullable)(void))completion {
//    if ([self respondsToSelector:@selector(apiOperation)]) {
//        [((UIBaseViewController *)self).apiOperation cancel];
//    }    
    if (isPresentViewController(self)){
        if ([self.navigationController.viewControllers firstObject] == self) {
            [self dismissViewControllerAnimated:YES completion:completion];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)updateColorForNavBar:(UIColor *)color withAlpha:(CGFloat)alpha {
    // iOS 7
    if ([UINavigationBar instancesRespondToSelector:@selector(setBarTintColor:)]) {
        [self.navigationController.navigationBar setBarTintColor:color];
        [self.navigationController.navigationBar setBackgroundColor:color];
    } else {
        self.navigationController.navigationBarHidden = (alpha != 1);
    }
    if (alpha == 1) {
        self.navigationController.navigationBar.shadowImage = nil;
    } else {
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    }
    
}

- (CGFloat)scrollViewDidScrollForHideNavBar:(UIScrollView *)scrollView {
    CGFloat f = 0.0f;
    CGPoint offset = scrollView.contentOffset;
    offset.y += scrollView.contentInset.top;
    
    if (scrollView == self.scrollViewForHideNavBar) {
        if (offset.y >= _topInsetForTabBar) {
            f = 1.0f;
            
            [self updateColorForNavBar:[UIColor whiteColor] withAlpha:f];
        } else {
            f = (offset.y/_topInsetForTabBar)*10/10;
            
            UIColor *colorWithAlpha = [self.navigationController.navigationBar.backgroundColor colorWithAlphaComponent:f];
            [self updateColorForNavBar:colorWithAlpha withAlpha:f];
        }
        return MAX(0, f);
    }
    return -1;
}

@end
