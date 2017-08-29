//
//  HomeSubPageViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/29.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "HomeSubPageViewController.h"
#import "UIViewController+ZJScrollPageController.h"

@interface HomeSubPageViewController ()

@end

@implementation HomeSubPageViewController

- (void)testBtnOnClick:(UIButton *)sender {
    [self.view makeToast:@"点击" duration:kToastDuration position:kToastPositionCenter];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    //    NSLog(@"%@",self.view);
    //    NSLog(@"%@", self.zj_scrollViewController);
    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    testBtn.backgroundColor = [UIColor whiteColor];
    [testBtn setTitle:@"点击" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(testBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    
    self.zj_scrollViewController.title  = @"测试过";
    
    if (index%2==0) {
        self.view.backgroundColor = [UIColor blueColor];
    } else {
        self.view.backgroundColor = [UIColor greenColor];
        
    }
}

// 使用系统的生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear------%ld", self.zj_currentIndex);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear-----%ld", self.zj_currentIndex);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear-----%ld", self.zj_currentIndex);
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear--------%ld", self.zj_currentIndex);
    
}

// 使用ZJScrollPageViewChildVcDelegate提供的生命周期方法

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    NSLog(@"viewDidDisappear--------");
//
//}
//- (void)zj_viewWillAppearForIndex:(NSInteger)index {
//    NSLog(@"viewWillAppear------");
//
//}
//
//
//- (void)zj_viewDidAppearForIndex:(NSInteger)index {
//    NSLog(@"viewDidAppear-----");
//
//}
//
//
//- (void)zj_viewWillDisappearForIndex:(NSInteger)index {
//    NSLog(@"viewWillDisappear-----");
//
//}
//
//- (void)zj_viewDidDisappearForIndex:(NSInteger)index {
//    NSLog(@"viewDidDisappear--------");
//
//}


- (void)dealloc {
    //    NSLog(@"%@-----test---销毁", self.description);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
