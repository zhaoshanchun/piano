//
//  SearchDetailView.m
//  SearchControllerDemo
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import "SearchDetailView.h"

@interface SearchDetailView () <UITextFieldDelegate>
@end

@implementation SearchDetailView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

-(id)init{
    self = [super init];
    if(self){
        [self setupViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Private

- (void)setupViews {
    NSLog(@"----->%s", __func__);
    self.cancleButton = [UIButton new];
    self.cancleButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.cancleButton.backgroundColor = [UIColor clearColor];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(dismissButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: self.cancleButton];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cancleButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cancleButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cancleButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:60]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cancleButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10]];
    
    
    self.textField = [UITextField new];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.layer.cornerRadius = 5.0f;
    self.textField.layer.masksToBounds = YES;
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeySearch;
    [self.textField addTarget:self action:@selector(textFieldEditingChanged) forControlEvents:
     UIControlEventEditingChanged];
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
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.cancleButton attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
}

- (void)setupTextFieldLeftView {
    NSLog(@"----->%s", __func__);
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    searchImageView.image = [UIImage imageNamed:@"search"];
    searchImageView.contentMode = UIViewContentModeCenter;
    self.textField.leftView = searchImageView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(searchButtonWasPressedForSearchDetailView:)]) {
        [self.delegate searchButtonWasPressedForSearchDetailView:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    NSLog(@"----->%s", __func__);
}

- (void)textFieldEditingChanged{
    if ([self.delegate respondsToSelector:@selector(textFieldEditingChangedForSearchDetailView:)]) {
        [self.delegate textFieldEditingChangedForSearchDetailView:self];
    }
}


#pragma mark - Handlers

- (IBAction)dismissButtonWasPressed:(UIButton *)sender {
    [self.textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(dismissButtonWasPressedForSearchDetailView:)]) {
        [self.delegate dismissButtonWasPressedForSearchDetailView:self];
    }
}

@end
