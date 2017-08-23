//
//  UIImageView+Helper.m
//  OpenSnap
//
//  Created by hangyuen on 24/10/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import "UIView+Helper.h"

#define DEFAULT_SPACING 10.0f

@implementation UIView (Helper)

- (UIView *)addDropShadowCorner:(CGFloat)corner radius:(CGFloat)radius offset:(CGSize)offset {
    UIView *sview = self.superview;
    
    UIView *shadow = [[UIView alloc]init];
    shadow.layer.cornerRadius = corner;
    shadow.layer.shadowColor = [[UIColor blackColor] CGColor];
    shadow.layer.shadowOpacity = 1.0;
    shadow.layer.shadowRadius = 5.0;
    shadow.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    shadow.frame = self.frame;
    
    self.frame = self.bounds;
    
    [self removeFromSuperview];
    [shadow addSubview:self];
    
    [sview addSubview:shadow];
    return shadow;
}

- (void)updateFrameOriginX:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)updateFrameOriginY:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)updateFrameHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)updateFrameWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)showBorder:(UIColor *)color {
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = color.CGColor;
}

@end

@implementation UILabel (Helper)

- (void)sizeToFitFixedWidth {
    CGSize size;
    if (self.attributedText) {
        size = getSizeForAttributedString(self.attributedText, CGRectGetWidth(self.frame), MAXFLOAT);
    } else{
        size = getSizeForString(self.text, self.font, CGRectGetWidth(self.frame), MAXFLOAT);
    }
    [self updateFrameHeight:size.height];
}

- (void)sizeToFitFixedHeight {
    CGSize size;
    if (self.attributedText) {
        size = getSizeForAttributedString(self.attributedText, MAXFLOAT, CGRectGetHeight(self.frame));
    } else {
        size = getSizeForString(self.text, self.font, MAXFLOAT, CGRectGetHeight(self.frame));
    }
    [self updateFrameWidth:size.width];
    if (size.height > CGRectGetHeight(self.frame)) {
        [self updateFrameHeight:size.height];
    }
}

- (void)sizeToFitWithPaddingLR:(CGFloat)padding {
    CGSize size;
    self.textAlignment = NSTextAlignmentCenter;
    if (self.attributedText) {
        size = getSizeForAttributedString(self.attributedText, MAXFLOAT, CGRectGetHeight(self.frame));
    } else {
        size = getSizeForString(self.text, self.font, MAXFLOAT, CGRectGetHeight(self.frame));
    }
    [self updateFrameWidth:size.width + padding*2];
}

@end

@implementation UIButton (UIButtonExt)

- (void)centerImageAndTitle:(float)space
{
    [self centerImageAndTitle:space andTitleSpace:DEFAULT_SPACING];
}

- (void)centerImageAndTitle:(float)imageSpace andTitleSpace:(float)titleSpace {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + DEFAULT_SPACING); //space);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(-imageSpace, (CGRectGetWidth(self.frame)-imageSize.width)/2, 0.0, (CGRectGetWidth(self.frame)-imageSize.width)/2);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(imageSpace-titleSpace, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
}

- (void)centerImageAndTitle
{
    [self centerImageAndTitle:DEFAULT_SPACING];
}

- (void)horizontalAlignImageTitle:(CGFloat)space
{
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, space, 0, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, space);
}

- (void)horizontalAlignImageTitle
{
    [self horizontalAlignImageTitle:DEFAULT_SPACING];
}

- (void)sizeToFitWithPaddingLR:(CGFloat)padding {
    CGSize size;
    if (self.titleLabel.attributedText) {
        size = getSizeForAttributedString(self.titleLabel.attributedText, MAXFLOAT, CGRectGetHeight(self.frame));
    } else {
        size = getSizeForString(self.titleLabel.text, self.titleLabel.font, MAXFLOAT, CGRectGetHeight(self.frame));
    }
    [self updateFrameWidth:size.width + padding*2];
}

@end

@implementation UIButton (ORFacebook)

+ (UIButton *)fbButtonWithTitle:(NSString *)title {
    UIImage * fbBtnOffImage = [UIImage imageNamed:@"FacebookButton"];
    UIButton * fbButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, fbBtnOffImage.size.width, fbBtnOffImage.size.height)];
    [fbButton setTitle:title forState:UIControlStateNormal];
    [fbButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [fbButton setFontAndTextColorByKey:@"wt34M" forState:UIControlStateNormal];
    [fbButton setBackgroundImage:fbBtnOffImage forState:UIControlStateNormal];
    return fbButton;
}

@end

@implementation UIScrollView (Helper)

- (void)scrollToBottom:(BOOL)animated {
    if(self.contentSize.height > self.frame.size.height) {
        [self setContentOffset: (CGPoint){ 0, self.contentSize.height-CGRectGetHeight(self.frame)} animated:animated];
    }
}

@end
