//
//  CollectionReusableView.m
//  huazhuangjiaocheng
//
//  Created by kun on 2017/6/10.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "CollectionReusableView.h"
#import "GlobalValue.h"

@implementation CollectionReusableView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    _video_title = [UILabel new];
    _video_title.text = @"";
    
    _video_title.textColor = LVRandomColor;
    _video_title.translatesAutoresizingMaskIntoConstraints = NO;
    //_video_title.font = [UIFont systemFontOfSize:15];
    [self addSubview:_video_title];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_video_title attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-3]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_video_title attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:5]];
    
    _button = [UIButton new];
    [_button setTitle:@"More>>" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor colorWithRed:57/255.0 green:157/255.0 blue:229/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor colorWithRed:57/255.0 green:157/255.0 blue:229/255.0 alpha:0.5] forState:UIControlStateHighlighted];
    _button.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    _button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    _button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
    _button.backgroundColor = [UIColor clearColor];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_button];
    
   // [self addConstraint:[NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:80]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    return self;
}

@end
