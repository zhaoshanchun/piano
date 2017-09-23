//
//  ShareContentViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/18.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ShareContentViewController.h"

@interface ShareContentViewController ()

@property (strong, nonatomic) UITextView *textView;

@end

@implementation ShareContentViewController

- (instancetype)initWithTitle:(NSString *)uuid {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBackButtonWithText:localizeString(@"cancel") fontKey:@"BR15N"];
    [self setRightButtonWithText:localizeString(@"done") fontKey:@"BR15N" target:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(shareWithContent:)]) {
            [self.delegate shareWithContent:self.textView.text];
        }
    }];
}

#pragma mark - Factory method
- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [self pageWidth], 150)];
        [_textView showBorder:[UIColor orLineColor]];
    }
    return _textView;
}

@end
