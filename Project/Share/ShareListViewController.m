//
//  ShareListViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/15.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ShareListViewController.h"
#import "ShareListTableViewCell.h"
#import "ShareModel.h"
#import "MJRefresh.h"

@interface ShareListViewController () <ShareListTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;

@end


@implementation ShareListViewController

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
    
    [self setNavigationBarTitle:localizeString(@"热门推荐")];
    
    _dataArray = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.dataArray.count == 0) {
        [self getShareList];
    }
}

- (void)setTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor grayColor];
    [self.tableView registerClass:[ShareListTableViewCell class] forCellReuseIdentifier:kShareListTableViewCellIndentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count > indexPath.row) {
        ShareListTableViewCellModel *cellModel = [self.dataArray objectAtIndex:indexPath.row];
        return cellModel.cellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShareListTableViewCellIndentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    if (self.dataArray.count > indexPath.row) {
        ShareListTableViewCellModel *cellModel = [self.dataArray objectAtIndex:indexPath.row];
        cell.cellModel = cellModel;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // [_playerView destroyPlayer];

}


#pragma mark - ShareListTableViewCellDelegate
- (void)playVideoForCell:(ShareListTableViewCell *)cell {
    
}


#pragma mark - API Action
- (void)getShareList {
    [self.view showLoading];
    __weak typeof(self) weakSelf = self;
    // http://www.appshopping.store/app/share_list?from=0&to=100  // kHTTPLoadCount
    NSString *apiName = [NSString stringWithFormat:@"%@?from=%ld&to=%d", kAPIShareList, self.dataArray.count, 100];
    [APIManager requestWithApi:apiName httpMethod:kHTTPMethodGet httpBody:nil responseHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!weakSelf) {
            return;
        }
        [weakSelf.view hideLoading];
        if (weakSelf.tableView.mj_footer) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
        if (!connectionError) {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            ShareListModel *shareListModel = [[ShareListModel alloc] initWithString:responseString error:nil];
            if (shareListModel.errorCode != 0) {
                [weakSelf handleError:shareListModel.errorCode errorMsg:@""];
                return;
            }
            
            if (shareListModel.objects.count > 0) {
                [weakSelf addContentList:shareListModel.objects];
            }
            
            // Add Refreshing: when 1.do not have add Refreshing yet 2. load data == 20, means have more data can be loaded 2. first time load
            if (!weakSelf.tableView.mj_footer
                && shareListModel.objects.count == kHTTPLoadCount
                && (weakSelf.dataArray.count - shareListModel.objects.count) == 0) {
                // Set the callback（Once you enter the refresh status，then call the action of target，that is call [self loadMoreData]）
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(getShareList)];
            }
            if (weakSelf.tableView.mj_footer) {
                // End load. No more data
                
                // TODO... 在底部显示 : 没有更多数据了  .
                
                if (shareListModel.objects.count < kHTTPLoadCount){
                    weakSelf.tableView.mj_footer.hidden = YES;
                }
            }
        } else {
            [weakSelf.view makeToast:@"网络异常，请稍后再试" duration:kToastDuration position:kToastPositionCenter];
        }
    }];
}

- (void)addContentList:(NSArray *)contentList {
    if (contentList.count == 0) {
        return;
    }
    
    for (ShareModel *contentModel in contentList) {
        ShareListTableViewCellModel *cellModel = [ShareListTableViewCellModel new];
        cellModel.shareModel = contentModel;
        [self.dataArray addObject:cellModel];
    }
    
    if (contentList.count > 0) {
        [self.tableView reloadData];
    }
}

- (void)handleError:(NSInteger )errorCode errorMsg:(NSString *)errorMsg {
    NSString *error = @"";
    if (errorMsg.length > 0) {
        error = errorMsg;
    } else if (errorCode > 0) {
        // TODO...  根据 error code 提示错误信息
        error = localizeString(@"获取数据失败，请重试！");
    }
    
    if (self.dataArray.count == 0) {
        [self showEmptyTitle:error];
    } else {
        [self.view makeToast:error duration:kToastDuration position:kToastPositionCenter];
    }
}




@end
