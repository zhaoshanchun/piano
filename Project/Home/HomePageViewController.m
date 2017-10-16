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
#import "ContentListModel.h"
#import "UIImage+Helper.h"


@interface HomePageViewController ()<ZJScrollPageViewDelegate>

// @property (strong, nonatomic) NSArray<NSString *> *titles;
@property (strong, nonatomic) NSArray<UIViewController *> *childVcs;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@property (strong, nonatomic) ContentListModel *homePageModel;

//@property (strong, nonatomic) NSMutableArray *listArray;

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
    style.segmentHeight = 64.0f;
    
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, [self pageWidth], [self pageHeight]) segmentStyle:style titles:@[localizeString(@"tab_home")] parentViewController:self delegate:self];
    [self.view addSubview:_scrollPageView];
    
    _scrollPageView.segmentView.backgroundColor = [UIColor orThemeColor];
    
    
    // 获取主要分类
    [self getClassList];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfChildViewControllers {
    if (self.homePageModel.classify.count > 0) {
        return self.homePageModel.classify.count;
    } else {
        return 1;   // @[@"首页"]
    }
}

- (HomeSubPageViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(HomeSubPageViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    HomeSubPageViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        childVc = [[HomeSubPageViewController alloc] init];
        if (self.homePageModel.classify.count > index) {
            childVc.classModel = [self.homePageModel.classify objectAtIndex:index];
        }
    }
    MyLog(@"%ld-----%@",(long)index, childVc);
    return childVc;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}


#pragma mark - Empty page and Action
- (void)emptyAction {
    [self hideEmptyView];
    [self getClassList];
}



#pragma mark - API Action
- (void)getClassList {
    [self.view showLoading];
    __weak typeof(self) weakSelf = self;
    // http://www.appshopping.store/app/home_page?appid=yixuekaoshi
    NSString *apiName = [NSString stringWithFormat:@"%@?appid=%@", kAPIHome, kAPPID];
    [APIManager requestWithApi:apiName httpMethod:kHTTPMethodGet httpBody:nil responseHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!weakSelf) {
            return;
        }
        [weakSelf.view hideLoading];
        
        if (connectionError) {
            MyLog(@"error : %@", [connectionError localizedDescription]);
            [weakSelf handleError:0 errorMsg:[connectionError localizedDescription]];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            weakSelf.homePageModel = [[ContentListModel alloc] initWithString:responseString error:nil];
            if (weakSelf.homePageModel.errorCode != 0) {
                [weakSelf handleError:weakSelf.homePageModel.errorCode errorMsg:@""];
                return;
            }
            
            if (self.homePageModel.classify.count > 0) {
                // 刷新 顶部 segment 列表
                NSMutableArray *listArray = [NSMutableArray new];
                for (ClassifyModel *classModel in weakSelf.homePageModel.classify) {
                    [listArray addObject:classModel.classifyName];
                }
                if (listArray.count > 0) {
                    [weakSelf.scrollPageView reloadWithNewTitles:listArray];
                }
            }
        }
    }];
}

- (void)handleError:(NSInteger )errorCode errorMsg:(NSString *)errorMsg {
    NSString *error = @"";
    if (errorMsg.length > 0) {
        error = errorMsg;
    } else if (errorCode > 0) {
        // TODO...  local string
        error = localizeString(@"error_alert_network_fail_recall");
    }
    [self showEmptyTitle:error buttonTitle:localizeString(@"retry")];
}


@end
