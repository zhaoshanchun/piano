//
//  PracticeViewController.m
//  apps
//
//  Created by zhaosc on 2017/10/23.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "PracticeViewController.h"

@interface PracticeViewController ()

@property (strong, nonatomic) PracticeListCellModel *exerciseModel;
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation PracticeViewController

- (id)initWithDocument:(PracticeListCellModel *)exerciseModel {
    self = [super init];
    if (self) {
        self.exerciseModel = exerciseModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBackButtonWithImageKey:@"common_back"];
    [self setNavigationBarTitle:self.exerciseModel.documentNameAttribute.string];
    
    [self.view addSubview:self.webView];
    [self loadContent];
}

- (void)loadContent {
    if (!self.exerciseModel) {
        return;
    }
    // NSString *path = [[NSBundle mainBundle] pathForResource:self.documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:self.exerciseModel.path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


#pragma mark - Factory method
- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [self pageWidth], [self pageHeight])];
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

@end
