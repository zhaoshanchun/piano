//
//  HomePageViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/29.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "HomePageViewController.h"
#import "ZJScrollPageView.h"
#import "HomeSubPageViewController.h"


@interface HomePageViewController ()<ZJScrollPageViewDelegate>

@property (strong, nonatomic) NSArray<NSString *> *titles;
@property (strong, nonatomic) NSArray<UIViewController *> *childVcs;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@end

@implementation HomePageViewController

- (id)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO; // 当前页面需要 Bottom Bar
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    
    self.titles = @[@"新闻头条", @"国际要闻", @"体育", @"中国足球",];
    // 初始化
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, [self pageWidth], [self pageHeight]) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    [self.view addSubview:_scrollPageView];
    
    self.view.layer.borderColor = [UIColor redColor].CGColor;
    self.view.layer.borderWidth = 0.5f;
    
    self.scrollPageView.layer.borderColor = [UIColor greenColor].CGColor;
    self.scrollPageView.layer.borderWidth = 0.5f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = [[HomeSubPageViewController alloc] init];
    }
    //    NSLog(@"%ld-----%@",(long)index, childVc);
    return childVc;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}


@end
