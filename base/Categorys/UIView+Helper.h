//
//  UIView+Helper.h
//  OpenSnap
//
//  Created by hangyuen on 24/10/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Helper)

- (UIView *)addDropShadowCorner:(CGFloat)corner radius:(CGFloat)radius offset:(CGSize)offset;
- (void)updateFrameOriginX:(CGFloat)x;
- (void)updateFrameOriginY:(CGFloat)y;
- (void)updateFrameHeight:(CGFloat)height;
- (void)updateFrameWidth:(CGFloat)width;
- (void)showBorder:(UIColor *)color;
@end

@interface UILabel (Helper)

- (void)sizeToFitFixedWidth;
- (void)sizeToFitFixedHeight;
- (void)sizeToFitWithPaddingLR:(CGFloat)padding;

@end

@interface UIButton (UIButtonExt)

- (void)centerImageAndTitle:(float)space;
- (void)centerImageAndTitle:(float)imageSpace andTitleSpace:(float)titleSpace;
- (void)centerImageAndTitle;
- (void)horizontalAlignImageTitle:(CGFloat)space;
- (void)horizontalAlignImageTitle;
- (void)sizeToFitWithPaddingLR:(CGFloat)padding;

@end

@interface UIButton (ORFacebook)

+ (UIButton *)fbButtonWithTitle:(NSString *)title;

@end

@interface UIScrollView (Helper)

- (void)scrollToBottom:(BOOL)animated;

@end
