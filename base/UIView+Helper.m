//
//  UIView+Helper.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/13.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

- (void)showBorder:(UIColor *)color {
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = color.CGColor;
}

@end
