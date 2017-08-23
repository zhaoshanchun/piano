//
//  UIView+Font.m
//  OpenSnap
//
//  Created by hangyuen on 9/10/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import "UIView+Font.h"

@implementation UIView (Font)

- (void)showDebugBorderWithColor:(UIColor *)color {
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = 1.0;
}

@end

@implementation UIButton (Font)

- (void)setFontAndTextColorByKey:(NSString *)fontKey forState:(UIControlState)state {
    UIFont *font = nil;
    UIColor *color = nil;

    setFontAndTextColorForFontKey(fontKey, &font, &color);

    [self.titleLabel setFont:font];
    [self setTitleColor:color forState:state];
}

@end

@implementation UILabel (Font)

- (void)setFontAndTextColorByKey:(NSString *)fontKey {
    UIFont *font = nil;
    UIColor *color = nil;
    
    setFontAndTextColorForFontKey(fontKey, &font, &color);
    
    self.font = font;
    self.textColor = color;
}

@end

@implementation UITextView (Font)

- (void)setFontAndTextColorByKey:(NSString *)fontKey {
    UIFont *font = nil;
    UIColor *color = nil;
    
    setFontAndTextColorForFontKey(fontKey, &font, &color);
    
    self.font = font;
    self.textColor = color;
}

@end

@implementation UITextField (Font)

- (void)setFontAndTextColorByKey:(NSString *)fontKey {
    UIFont *font = nil;
    UIColor *color = nil;
    
    setFontAndTextColorForFontKey(fontKey, &font, &color);
    
    self.font = font;
    self.textColor = color;
}

@end