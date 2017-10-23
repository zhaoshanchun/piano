//
//  InputContentViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/18.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "InputContentViewController.h"

@interface InputContentViewController () <UITextViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *doneButton;


@end

@implementation InputContentViewController

- (instancetype)initWithTitle:(NSString *)uuid {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBackButtonWithText:localizeString(@"cancel") fontKey:@"BR15N"];
    self.doneButton = [self setRightButtonWithText:localizeString(@"done") fontKey:@"BR15N" target:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.doneButton setFontAndTextColorByKey:@"BR15N" forState:UIControlStateNormal];
    [self.doneButton setFontAndTextColorByKey:@"LGY15N" forState:UIControlStateDisabled];
    self.doneButton.enabled = NO;
    
    [self.view addSubview:self.textView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}

- (void)doneAction {
    [self onBtnBackTouchUpInside:nil completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(backWithContent:)]) {
            [self.delegate backWithContent:self.textView.text];
        }
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.doneButton.enabled = textView.text.length > 0;
}

#pragma mark - Factory method
- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [self pageWidth], 150)];
        _textView.delegate = self;
        [_textView setFontAndTextColorByKey:@"BR15N"];
        [_textView showBorder:[UIColor orLineColor]];
    }
    return _textView;
}

@end
