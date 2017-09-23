//
//  BaseViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/15.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (strong, nonatomic) UIView *emptyView;
@property (strong, nonatomic) UILabel *emptyLabel;
@property (strong, nonatomic) UIButton *emptyButton;

@end

@implementation BaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nil bundle:nil]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.hideNavigationBar = NO;            // 默认当前页面需要 Navigation Bar
    self.hidesBottomBarWhenPushed = YES;    // 默认当前页面不需要 Bottom Bar
    self.navigationController.navigationBar.barTintColor = [UIColor orThemeColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorForKey:@"lgy"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.animating = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.animating = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)interactivePopGestureShouldBegin {
    return YES;
}

// TODO...  status bar


- (CGFloat)pageWidth {
    return SCREEN_WIDTH;
}

- (CGFloat)pageHeight {
    // translunt,hidenavigationBar,tabbar等情况
    CGFloat pageHeight = SCREEN_HEIGHT;
    
    if (!self.hidesBottomBarWhenPushed) {
        pageHeight -= TAB_BAR_HEIGHT;
    }
    
    if (!self.navigationController.isNavigationBarHidden || !self.hideNavigationBar) {
        pageHeight -= (STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT);
    }
    
    return pageHeight;
}


#pragma mark - Empty page and Action
- (void)showEmptyTitle:(NSString *)emptyTitle {
    if (_emptyView == nil) {
        [self.view addSubview:self.emptyView];
        [self.view bringSubviewToFront:self.emptyView];
        [self.emptyView addSubview:self.emptyLabel];
        [self.emptyView addSubview:self.emptyButton];
    }
    
    self.emptyView.hidden = NO;
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentCenter;
    self.emptyLabel.attributedText = formatAttributedStringByORFontGuide(@[emptyTitle, @"BR16N"], @[style]);
    
    [self.emptyButton addTarget:self action:@selector(emptyAction) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize size = getSizeForAttributedString(self.emptyLabel.attributedText, CGRectGetWidth(self.emptyView.frame), MAXFLOAT);
    self.emptyLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.emptyView.frame), size.height);
    self.emptyButton.frame = CGRectMake(30, CGRectGetMaxY(self.emptyLabel.frame) + 20, CGRectGetWidth(self.emptyView.frame) - 30*2, 45);
    self.emptyView.frame = CGRectMake(20, ([self pageHeight] - CGRectGetMaxY(self.emptyButton.frame))/2, [self pageWidth] - 20*2, CGRectGetMaxY(self.emptyButton.frame));
}

- (void)hideEmptyParam {
    self.emptyView.hidden = YES;
}

// Should be override in sub class
- (void)emptyAction {
    
}



#pragma mark - Empty page and Action - Factory method
- (UIView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, [self pageWidth] - 20*2, 0)];
        _emptyView.backgroundColor = rgb(@"FFFFFF", 0.9f);
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (UILabel *)emptyLabel {
    if (_emptyLabel == nil) {
        _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.emptyView.frame), 0)];
        _emptyLabel.numberOfLines = 0;
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyLabel;
}

- (UIButton *)emptyButton {
    if (_emptyButton == nil) {
        _emptyButton = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.emptyLabel.frame) + 20, CGRectGetWidth(self.emptyView.frame) - 30*2, 45)];
        _emptyButton.layer.cornerRadius = 5.0f;
        _emptyButton.layer.masksToBounds = YES;
        [_emptyButton setTitle:@"重试" forState:UIControlStateNormal];
        [_emptyButton setFontAndTextColorByKey:@"BR16B" forState:UIControlStateNormal];
        
        _emptyButton.layer.borderWidth = 1.0f;
        _emptyButton.layer.borderColor = [UIColor orLineColor].CGColor;
    }
    return _emptyButton;
}

- (UserModel *)userModel {
    if (_userModel == nil) {
        NSData *userModelData = (NSData *)getObjectFromUserDefaults(kLoginedUser);
        if (userModelData) {
            _userModel = [NSKeyedUnarchiver unarchiveObjectWithData:userModelData];
        }
    }
    return _userModel;
}


@end

