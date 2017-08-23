//
//  UIView+Font.h
//  OpenSnap
//
//  Created by hangyuen on 9/10/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Font)

- (void)showDebugBorderWithColor:(UIColor *)color;

@end

@interface UIButton (Font)

- (void)setFontAndTextColorByKey:(NSString *)fontKey forState:(UIControlState)state;

@end

@interface UILabel (Font)

- (void)setFontAndTextColorByKey:(NSString *)fontKey;

@end

@interface UITextView (Font)

- (void)setFontAndTextColorByKey:(NSString *)fontKey;

@end

@interface UITextField (Font)

- (void)setFontAndTextColorByKey:(NSString *)fontKey;

@end