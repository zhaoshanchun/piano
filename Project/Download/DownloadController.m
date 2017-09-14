//
//  DownloadController.m
//  sifakaoshi
//
//  Created by kun on 2017/9/7.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "DownloadController.h"
#import "DownloadUnfinishedController.h"
#import "DownloadFinishedController.h"
#import "DownloadSetViewController.h"

@interface DownloadController ()

@property (nonatomic, strong)  DownloadUnfinishedController     *unfinishedController;
@property (nonatomic, strong)  DownloadFinishedController       *finishedController;
@property (nonatomic, strong)  UIViewController       *currentVC;

@end

@implementation DownloadController

- (id)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO; // 当前页面需要 Bottom Bar
        self.hideNavigationBar = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    //CGRect rectNav = self.navigationController.navigationBar.frame;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
   
    self.navigationItem.titleView = [self initTitleView];
    
    self.unfinishedController = [[DownloadUnfinishedController alloc] init];
    [self addChildViewController:_unfinishedController];
    
    self.finishedController = [[DownloadFinishedController alloc] init];
    [self addChildViewController:_finishedController];
    //设置默认控制器为fristVc
    self.currentVC = self.unfinishedController;
    [self.view addSubview:self.unfinishedController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initTitleView
{
    UIView *view = [UIView new];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    view.frame = rectNav;

    NSArray *items = @[@"1", @"2"];
    UISegmentedControl *sgc = [[UISegmentedControl alloc] initWithItems:items];
    sgc.translatesAutoresizingMaskIntoConstraints = NO;
    sgc.selectedSegmentIndex = 0;
    //设置segment的文字
    [sgc setTitle:@"未完成缓存" forSegmentAtIndex:0];
    [sgc setTitle:@"已完成缓存" forSegmentAtIndex:1];
    //监听点击
    [sgc addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    
    [view addSubview:sgc];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:sgc attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    [view addConstraint:[NSLayoutConstraint constraintWithItem:sgc attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    UIButton *setBt = [UIButton new];
    setBt.translatesAutoresizingMaskIntoConstraints = NO;
    [setBt setImage:[UIImage imageNamed:@"set_active.png"] forState:UIControlStateNormal];
    [setBt setImage:[UIImage imageNamed:@"set.png"] forState:UIControlStateSelected];
    [setBt addTarget:self action:@selector(ButtonAciton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:setBt];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:setBt attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:33]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:setBt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:33]];

    [view addConstraint:[NSLayoutConstraint constraintWithItem:setBt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:setBt attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    return view;
}

-(void)ButtonAciton:(UIButton *)bt
{
    [self.navigationController pushViewController:[DownloadSetViewController new] animated:YES];
}

/**
 *  初始化segmentControl
 */
- (UISegmentedControl *)setupSegment{
    NSArray *items = @[@"1", @"2"];
    UISegmentedControl *sgc = [[UISegmentedControl alloc] initWithItems:items];
    //默认选中的位置
    sgc.selectedSegmentIndex = 0;
    //设置segment的文字
    [sgc setTitle:@"未完成缓存" forSegmentAtIndex:0];
    [sgc setTitle:@"已完成缓存" forSegmentAtIndex:1];
    //监听点击
    [sgc addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    return sgc;
}

- (void)segmentChange:(UISegmentedControl *)sgc{
    //NSLog(@"%ld", sgc.selectedSegmentIndex);
    switch (sgc.selectedSegmentIndex) {
        case 0:
            [self replaceFromOldViewController:self.finishedController toNewViewController:self.unfinishedController];
            break;
        case 1:
            [self replaceFromOldViewController:self.unfinishedController toNewViewController:self.finishedController];
            break;
        default:
            break;
    }
}

/**
 *  实现控制器的切换
 *
 *  @param oldVc 当前控制器
 *  @param newVc 要切换到的控制器
 */
- (void)replaceFromOldViewController:(UIViewController *)oldVc toNewViewController:(UIViewController *)newVc{
    /**
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController    当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options              动画效果(渐变,从下往上等等,具体查看API)UIViewAnimationOptionTransitionCrossDissolve
     *  animations            转换过程中得动画
     *  completion            转换完成
     */
    [self addChildViewController:newVc];
    [self transitionFromViewController:oldVc toViewController:newVc duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newVc didMoveToParentViewController:self];
            [oldVc willMoveToParentViewController:nil];
            [oldVc removeFromParentViewController];
            self.currentVC = newVc;
        }else{
            self.currentVC = oldVc;
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
