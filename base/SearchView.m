//
//  SearchView.m
//  SearchControllerDemo
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Private

- (void)setupViews {
    self.textField = [UITextField new];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.layer.cornerRadius = 5.0f;
    self.textField.layer.masksToBounds = YES;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.font = [UIFont systemFontOfSize:14];
    [self.textField setValue:[UIColor colorWithRed:176 / 255.0f green:176 / 255.0f blue: 176 / 255.0f alpha:1.0f]
                  forKeyPath:@"_placeholderLabel.textColor"];
    self.textField.tintColor = [UIColor colorWithRed:98 / 255.0f green:97 / 255.0f blue: 101 / 255.0f alpha:1.0f];
    [self setupTextFieldLeftView];
    [self addSubview:self.textField];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10]];
    
    
    // Search button
    self.searchButton = [UIButton new];
    self.searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchButton.backgroundColor = [UIColor clearColor];
    [self.searchButton addTarget:self action:@selector(searchButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: self.searchButton];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.searchButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.searchButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.searchButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.searchButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10]];
    [self bringSubviewToFront:self.searchButton];
}

- (void)setupTextFieldLeftView {
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    searchImageView.image = [UIImage imageNamed:@"search"];
    searchImageView.contentMode = UIViewContentModeCenter;
    self.textField.userInteractionEnabled = NO;
    self.textField.leftView = searchImageView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)searchButtonWasPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(searchButtonWasPressedForSearchView:)]) {
        [self.delegate searchButtonWasPressedForSearchView:self];
    }
}


@end
