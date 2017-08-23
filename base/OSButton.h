//
//  OSButton.h
//  OpenSnap
//
//  Created by hangyuen on 30/10/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    OSButtonTypeDefault = 0,        // normal uibutton just handle highlight case
    OSButtonTypeOrange,
    OSButtonTypeGrey,
    OSButtonTypeRoundedOrange,
    OSButtonTypeAlpha
} OSButtonType;

@interface OSButton : UIButton

@property (strong, nonatomic) UIColor *normalColor;
@property (strong, nonatomic) UIColor *highlightedColor;

@property (assign, nonatomic) OSButtonType btnType;
@property (assign, nonatomic) BOOL customEnabled;

- (void)setup;

@end
