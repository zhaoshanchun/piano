//
//  UIColor+Helper.m
//  OpenRice
//
//  Created by hangyuen on 9/10/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (OpenRice)

static NSDictionary *dictionaryForColor;

+ (UIColor *)colorForKey:(NSString *)key {
    return [UIColor colorForKey:key withAlpha:1.0];
}

+ (UIColor *)colorForKey:(NSString *)key withAlpha:(CGFloat)alpha {
    if (dictionaryForColor == nil) {
        dictionaryForColor = @{
                               @"lgy":@"f2f2f2",
                               @"gy":@"e2e2e2",
                               @"dgy":@"8e8e8e",
                               @"bgy":@"3e3e3e",
                               @"lbr":@"85796e",
                               @"br":@"4e3c2d",
                               @"o":@"e54e26",
                               @"r":@"e60000",
                               @"y":@"ffcb05",
                               @"ly":@"fffcdf",
                               @"w":@"ffffff",
                               @"dgn":@"00a67d",
                               @"na":@"a0978f",
                               @"ybr" : @"b3865a",
                               @"gr":@"009342"
                               };
    }
    return rgb([dictionaryForColor objectForKey:[key lowercaseString]], alpha);
}

#pragma mark - UI

+ (UIColor *)orBackgroundColor {
    return [self colorForKey:@"lgy"];
}

+ (UIColor *)orThemeColor {
    return [self colorForKey:@"y"];
}

+ (UIColor *)orLineColor {
    return rgb(@"e5e5e5", 1.0);
}

+ (UIColor *)orBarLineColor {
    return rgb(@"e5e5e5", 1.0);
}

+ (UIColor *)orDashLineColor {
    return rgb(@"d4d4d4", 1.0);
}

+ (UIColor *)orDefaultTouchColor {
    return rgb(@"000000", 0.2);
}

+ (UIColor *)orOverlayColor {
    return rgb(@"000000", 0.5);
}

+ (UIColor *)orProfileOverlayColor {
    return rgb(@"000000", 0.3);
}

+ (UIColor *)orButtonDefaultNormalColor {
    return rgb(@"ffffff", 1.0);
}

+ (UIColor *)orButtonDefaultHighlightedColor {
    return [UIColor colorWithWhite:0 alpha:0.46];
}

+ (UIColor *)orTableViewCellHighlightedColor {
    return rgb(@"cfcfcf", 0.7);
}

+ (UIColor *)navigationBarLineColor {
    return rgb(@"aaaaaa", 1.0);
}

// Return UIColor, based on the RGB value.
UIColor* rgb(NSString* color, float alpha){
    long value = 0;
    if (color) {
        sscanf([color cStringUsingEncoding:NSUTF8StringEncoding], "%lx", &value);
    }
    return [UIColor colorWithRed:((value >> 16) & 0xFF) / 255.0f
                           green:((value >> 8) & 0xFF) / 255.0f
                            blue:((value) & 0xFF) / 255.0f
                           alpha:alpha];    
}

@end

