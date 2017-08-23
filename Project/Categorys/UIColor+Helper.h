//
//  UIColor+Helper.h
//  OpenRice
//
//  Created by ken on 9/10/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (OpenRice)

+ (UIColor *)colorForKey:(NSString *)key;
+ (UIColor *)colorForKey:(NSString *)key withAlpha:(CGFloat)alpha;

+ (UIColor *)orBackgroundColor;
+ (UIColor *)orThemeColor;
+ (UIColor *)orLineColor;
+ (UIColor *)orBarLineColor;
+ (UIColor *)orDashLineColor;
+ (UIColor *)orDefaultTouchColor;
+ (UIColor *)orOverlayColor;
+ (UIColor *)orProfileOverlayColor;
+ (UIColor *)orButtonDefaultNormalColor;
+ (UIColor *)orButtonDefaultHighlightedColor;
+ (UIColor *)orTableViewCellHighlightedColor;

+ (UIColor *)navigationBarLineColor;

@end

UIColor* rgb(NSString* color, float alpha);
