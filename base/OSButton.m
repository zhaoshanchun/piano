//
//  OSButton.m
//  OpenSnap
//
//  Created by hangyuen on 30/10/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import "OSButton.h"

#import "Common-Header.h"

@interface OSButton () {
    
    UIColor *_normalColor;
    UIColor *_highlightedColor;
    
}

@property (strong, nonatomic) UIColor *normalTextColor;
@property (strong, nonatomic) UIColor *disabledTextColor;

@end

@implementation OSButton

+ (id)buttonWithType:(UIButtonType)buttonType {
    OSButton *btn = [super buttonWithType:buttonType];
    if (btn) {
        [btn setup];
    }
    return btn;
}

- (UIColor *)normalColor {
    if (!_normalColor) {
        _normalColor = [UIColor orButtonDefaultNormalColor];
    }
    return _normalColor;
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    
    if (_btnType == OSButtonTypeRoundedOrange && !self.isHighlighted) {
        self.layer.borderColor = [_normalColor CGColor];
    }
}

- (UIColor *)highlightedColor {
    if (!_highlightedColor) {
        _highlightedColor = [UIColor orButtonDefaultHighlightedColor];
    }
    return _highlightedColor;
}

- (void)setHighlightedColor:(UIColor *)highlightedColor {
    _highlightedColor = highlightedColor;
    
    if (_btnType == OSButtonTypeRoundedOrange && self.isHighlighted) {
        self.layer.borderColor = [_highlightedColor CGColor];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _customEnabled = YES;
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _customEnabled = YES;
        [self setup];
    }
    return self;
}

- (void)setBtnType:(OSButtonType)btnType {
    _btnType = btnType;
    _customEnabled = YES;
    
    switch (btnType) {
        case OSButtonTypeOrange: {
            self.normalColor = [UIColor colorForKey:@"or"];
            self.highlightedColor = rgb(@"cc6633", 1.0);
            
            self.layer.cornerRadius = self.bounds.size.height/2;
            self.layer.masksToBounds = YES;
            
            [self setFontAndTextColorByKey:@"wt34M" forState:UIControlStateNormal];
            break;
        }
        case OSButtonTypeGrey: {
            self.normalColor = rgb(@"c5c5c5", 1.0);
            self.highlightedColor = rgb(@"a3a3a3", 1.0);
            
            self.layer.cornerRadius = self.bounds.size.height/2;
            self.layer.masksToBounds = YES;
            
            [self setFontAndTextColorByKey:@"dgy34M" forState:UIControlStateNormal];
            break;
        }
        case OSButtonTypeRoundedOrange: {
//            self.frame = CGRectMake(self.frame.origin.x + 1, self.frame.origin.y + 1, self.frame.size.width - 2, self.frame.size.height - 2);
            self.backgroundColor = [UIColor clearColor];
            
            self.normalColor = [UIColor colorForKey:@"or"];
            self.highlightedColor = [UIColor colorForKey:@"or" withAlpha:0.5];
            
            self.layer.cornerRadius = self.bounds.size.height/2;
            self.layer.masksToBounds = YES;
            
            self.layer.borderWidth = 1.0;
            self.layer.borderColor = [[UIColor colorForKey:@"or"] CGColor];
            
            [self setFontAndTextColorByKey:@"or34M" forState:UIControlStateNormal];
            break;
        }
        case OSButtonTypeAlpha: {
            self.normalColor = [UIColor clearColor];
            self.highlightedColor = [UIColor clearColor];
            [self setAdjustsImageWhenHighlighted:NO];
            break;
        }
        default:
            break;
    }
    if (self.btnType != OSButtonTypeRoundedOrange) {
        if (self.highlighted) {
            [self setBackgroundColor:self.highlightedColor];
        } else {
            [self setBackgroundColor:self.normalColor];
        }
    }
}

- (void)setup {
    [self addTarget:self action:@selector(onBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(onBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
}

- (void)onBtnTouchDown:(UIButton *)sender {
    if (self.btnType == OSButtonTypeRoundedOrange) {
        sender.layer.borderColor = [self.highlightedColor CGColor];
        [sender setTitleColor:self.highlightedColor forState:UIControlStateNormal];
    } else if (self.btnType == OSButtonTypeAlpha) {
        sender.alpha = 0.5;
    } else {
        [sender setBackgroundColor:self.highlightedColor];
    }
}

- (void)onBtnTouchUp:(UIButton *)sender {
    if (_customEnabled) {
        if (self.btnType == OSButtonTypeRoundedOrange) {
            sender.layer.borderColor = [self.normalColor CGColor];
            [sender setTitleColor:self.normalColor forState:UIControlStateNormal];
        } else if (self.btnType == OSButtonTypeAlpha) {
            sender.alpha = 1.0;
        } else {
            [sender setBackgroundColor:self.normalColor];
        }
    } else {
        [sender setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)setCustomEnabled:(BOOL)customEnabled {
    _customEnabled = customEnabled;
    
    if (self.btnType != OSButtonTypeDefault) {
        if (_customEnabled) {
            self.backgroundColor = self.normalColor;
            self.layer.borderWidth = 0;
            
            switch (self.btnType) {
                case OSButtonTypeOrange:
                    [self setFontAndTextColorByKey:@"wt34M" forState:UIControlStateNormal];
                    break;
                case OSButtonTypeGrey:
                    [self setFontAndTextColorByKey:@"dgy34M" forState:UIControlStateNormal];
                    break;
                case OSButtonTypeRoundedOrange:
                    [self setFontAndTextColorByKey:@"wt34M" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        } else {
            self.backgroundColor = [UIColor clearColor];
            self.layer.borderWidth = 1.0;
            self.layer.borderColor = [rgb(@"cccccc", 1.0) CGColor];
            
            [self setFontAndTextColorByKey:@"lggy34M" forState:UIControlStateNormal];
        }
    }
}

@end
