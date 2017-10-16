//
//  PublicShareViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/10/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "PublicShareViewController.h"
#import "CLPlayerView.h"
#import "PublicShareTableViewCell.h"
#import "PublicShareCellModel.h"
#import "UIView+CLSetRect.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

#import "ShareModel.h"

static NSString *PublicShareTableViewCellIdentifier = @"PublicShareTableViewCellIdentifier";


@interface PublicShareViewController () <PublicShareTableViewCellDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CLPlayerView *playerView;
@property (nonatomic, assign) PublicShareTableViewCell *playingCell;

@end

@implementation PublicShareViewController

- (id)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
        self.hideNavigationBar = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:localizeString(@"tab_share")];
    
    _dataArray = [NSMutableArray new];
}

- (void)setTableView {
    [self.tableView registerClass:[PublicShareTableViewCell class] forCellReuseIdentifier:PublicShareTableViewCellIdentifier];
    // self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.dataArray.count == 0) {
        [self getShareList];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopPlaying];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count > indexPath.row) {
        PublicShareCellModel *cellModel = [self.dataArray objectAtIndex:indexPath.row];
        return cellModel.cellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PublicShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PublicShareTableViewCellIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    if (self.dataArray.count > indexPath.row) {
        PublicShareCellModel *cellModel = [self.dataArray objectAtIndex:indexPath.row];
        cell.cellModel = cellModel;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.playingCell isEqual:cell]) {
        // 正在播放的cell离开屏幕，销毁播放
        [self stopPlaying];
    }
}

#pragma mark - 点击播放代理
- (void)shouldPlayVideoForCell:(PublicShareTableViewCell *)cell {
    [self stopPlaying];
    self.playingCell = cell;
    self.playerView = [[CLPlayerView alloc] initWithFrame:cell.cellModel.playViewFrame];
    [self.playerView backButton:^(UIButton *button) {
        // TODO... 修改源代码，把返回按钮做成可在外部隐藏
    }];
    [self.playerView endPlay:^{
        [self.playerView destroyPlayer];
        self.playerView = nil;
        self.playingCell = nil;
    }];
    [cell addPlayView:self.playerView];
}

- (void)stopPlaying {
    if (_playerView) {
        [_playerView destroyPlayer];
    }
    if (_playingCell) {
        [self.playingCell stopedPlay];
        _playingCell = nil;
    }
}


#pragma mark - API Action
- (void)getShareList {
    [self.view showLoading];
    __weak typeof(self) weakSelf = self;
    // http://www.appshopping.store/app/share_list?from=0&to=100
    NSString *apiName = [NSString stringWithFormat:@"%@?from=%ld&to=%d", kAPIShareList, self.dataArray.count, kHTTPShareListLoadCount];
    [APIManager requestWithApi:apiName httpMethod:kHTTPMethodGet httpBody:nil responseHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!weakSelf) {
            return;
        }
        [weakSelf.view hideLoading];
        if (weakSelf.tableView.mj_header) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        if (weakSelf.tableView.mj_footer) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
        if (!connectionError) {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            ShareListModel *shareListModel = [[ShareListModel alloc] initWithString:responseString error:nil];
            if (shareListModel.errorCode != 0) {
                [weakSelf handleError:shareListModel.errorCode errorMsg:@""];   // TODO...
                return;
            }
            
            if (shareListModel.objects.count > 0) {
                [weakSelf addContentList:shareListModel.objects];
                weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [weakSelf.dataArray removeAllObjects];
                    [weakSelf.tableView reloadData];
                    [weakSelf getShareList];
                }];
            }
            
            // Add Refreshing: when 1.do not have add Refreshing yet 2. load data == 20, means have more data can be loaded 2. first time load
            if (!weakSelf.tableView.mj_footer
                && shareListModel.objects.count == kHTTPShareListLoadCount
                && (weakSelf.dataArray.count - shareListModel.objects.count) == 0) {
                // Set the callback（Once you enter the refresh status，then call the action of target，that is call [self loadMoreData]）
                weakSelf.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(getShareList)];
            }
            
            if (shareListModel.objects.count < kHTTPShareListLoadCount && weakSelf.tableView.mj_footer) {
                // End load. No more data  在底部显示 : 没有更多数据了  .
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (weakSelf.dataArray.count == 0) {
                [weakSelf handleError:0 errorMsg:localizeString(@"share_notice_empty")];
                return;
            }
        } else {
            [weakSelf handleError:0 errorMsg:localizeString(@"error_alert_network_fail")];
        }
    }];
}


#pragma mark - Empty page and Action
- (void)emptyAction {
    [self hideEmptyParam];
    [self getShareList];
}

#pragma mark - Helper
- (void)addContentList:(NSArray *)contentList {
    for (ShareModel *contentModel in contentList) {
        PublicShareCellModel *cellModel = [PublicShareCellModel new];
        cellModel.shareModel = contentModel;
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

@end
