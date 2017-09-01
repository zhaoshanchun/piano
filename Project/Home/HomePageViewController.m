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
        self.hideNavigationBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // ZJ-SDK 必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.showLine = YES;   //显示滚动条
    style.gradualChangeTitleColor = YES;    // 颜色渐变
    
    self.titles = @[@"精选", @"聚集", @"电影", @"综艺",];
    
    // 初始化
    // MyLog(@"SCREEN_HEIGHT = %f", SCREEN_HEIGHT);    // 568.000000   667.000000
    // MyLog(@"pageHeight = %f", [self pageHeight]);   // 518.000000   617.000000
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, [self pageWidth], [self pageHeight] - STATUS_BAR_HEIGHT) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    [self.view addSubview:_scrollPageView];
    // MyLog(@"scrollPageView.frame.size.height = %f", _scrollPageView.frame.size.height); // 597.000000
    
//    self.view.layer.borderColor = [UIColor redColor].CGColor;
//    self.view.layer.borderWidth = 1.5f;
//
//    self.scrollPageView.layer.borderColor = [UIColor greenColor].CGColor;
//    self.scrollPageView.layer.borderWidth = 1.5f;
}

- (void)viewWillAppear:(BOOL)animated {
    // MyLog(@"pageHeight = %f", [self pageHeight]);
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
    MyLog(@"%ld-----%@",(long)index, childVc);
    return childVc;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}


@end
