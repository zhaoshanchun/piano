//
//  PracticeListViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/16.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "PracticeListViewController.h"
#import "PracticeViewController.h"
#import "DocumentManager.h"
#import "PracticeListCellModel.h"


@interface PracticeListViewController ()

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation PracticeListViewController

- (id)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO; // 当前页面需要 Bottom Bar
        self.hideNavigationBar = NO;
        
        _dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:localizeString(@"exerise_title")];
    [self getDocuments];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[UIBaseTableViewCell class] forCellReuseIdentifier:kUIBaseTableViewCellIndentifier];
}

- (void)getDocuments {
    [self.view showLoading];
    __weak typeof(self) weakSelf = self;
    [[DocumentManager sharedManager] getDocumentFrom:self.dataArray.count count:kDocumentLoadCount backHandler:^(NSArray *documents) {
        [weakSelf.view hideLoading];
        
        if (weakSelf.tableView.mj_footer) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
        if (documents.count > 0) {
            [self hideEmptyView];
            [weakSelf addContentList:documents];
        }
        
        // Add Refreshing: when 1.do not have add Refreshing yet 2. load data == 20, means have more data can be loaded 2. first time load
        if (!weakSelf.tableView.mj_footer
            && documents.count == kDocumentLoadCount
            && (weakSelf.dataArray.count - documents.count) == 0) {
            // Set the callback（Once you enter the refresh status，then call the action of target，that is call [self loadMoreData]）
            weakSelf.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(getDocuments)];
        }
        
        if (documents.count < kDocumentLoadCount && weakSelf.tableView.mj_footer) {
            // End load. No more data  在底部显示 : 没有更多数据了  .
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (weakSelf.dataArray.count == 0) {
            [weakSelf handleError:0 errorMsg:localizeString(@"share_notice_empty")];
            return;
        }
    }];
}

#pragma mark - Helper
- (void)addContentList:(NSArray *)contentList {
    for (NSString *path in contentList) {
        PracticeListCellModel *cellModel = [PracticeListCellModel new];
        cellModel.path = path;
        [self.dataArray addObject:cellModel];
    }
    [self.tableView reloadData];
}

- (void)handleError:(NSInteger )errorCode errorMsg:(NSString *)errorMsg {
    NSString *error = @"";
    if (errorMsg.length > 0) {
        error = errorMsg;
    } else if (errorCode > 0) {
        error = localizeString(@"error_alert_network_fail_recall");
    }
    
    if (self.dataArray.count == 0) {
        [self showEmptyTitle:error buttonTitle:localizeString(@"retry")];
    } else {
        [self.view makeToast:error duration:kToastDuration position:kToastPositionCenter];
    }
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArray.count) {
        PracticeListCellModel *cellModel = [self.dataArray objectAtIndex:indexPath.row];
        return cellModel.cellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    if (indexPath.row < self.dataArray.count) {
        PracticeListCellModel *cellModel = [self.dataArray objectAtIndex:indexPath.row];
        cell.textLabel.attributedText = cellModel.documentNameAttribute;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataArray.count) {
        return;
    }
    PracticeListCellModel *cellModel = [self.dataArray objectAtIndex:indexPath.row];
    PracticeViewController *vc = [[PracticeViewController alloc] initWithDocument:cellModel];
    [self.navigationController pushViewController:vc animated:YES];
}


@end






