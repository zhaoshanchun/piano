//
//  PublicShareViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/10/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "PublicShareViewController.h"
#import "CLPlayerView.h"
#import "CLTableViewCell.h"
#import "CLModel.h"
#import "UIView+CLSetRect.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

#import "ShareModel.h"

static NSString *CLTableViewCellIdentifier = @"CLTableViewCellIdentifier";


@interface PublicShareViewController () <CLTableViewCellDelegate, UIScrollViewDelegate>

/**数据源*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/**CLplayer*/
@property (nonatomic, weak) CLPlayerView *playerView;
/**记录Cell*/
@property (nonatomic, assign) UITableViewCell *cell;

@end

@implementation PublicShareViewController

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
    [self setNavigationBarTitle:localizeString(@"tab_share")];
    
    _dataArray = [NSMutableArray new];
}

- (void)setTableView {
    [self.tableView showBorder:[UIColor redColor]];
    [self.tableView registerClass:[CLTableViewCell class] forCellReuseIdentifier:CLTableViewCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.dataArray.count == 0) {
        [self getShareList];
    }
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CLTableViewCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}

//在willDisplayCell里面处理数据能优化tableview的滑动流畅性，cell将要出现的时候调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CLTableViewCell * myCell = (CLTableViewCell *)cell;
    myCell.model = self.dataArray[indexPath.row];
    //Cell开始出现的时候修正偏移量，让图片可以全部显示
    [myCell cellOffset];
    //第一次加载动画
    [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:myCell.model.pictureUrl] completion:^(BOOL isInCache) {
        if (!isInCache) {
            //主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                CATransform3D rotation;//3D旋转
                rotation = CATransform3DMakeTranslation(0 ,50 ,20);
                //逆时针旋转
                rotation = CATransform3DScale(rotation, 0.8, 0.9, 1);
                rotation.m34 = 1.0/ -600;
                myCell.layer.shadowColor = [[UIColor blackColor]CGColor];
                myCell.layer.shadowOffset = CGSizeMake(10, 10);
                myCell.alpha = 0;
                myCell.layer.transform = rotation;
                [UIView beginAnimations:@"rotation" context:NULL];
                //旋转时间
                [UIView setAnimationDuration:0.6];
                myCell.layer.transform = CATransform3DIdentity;
                myCell.alpha = 1;
                myCell.layer.shadowOffset = CGSizeMake(0, 0);
                [UIView commitAnimations];
            });
        }
    }];
}

//cell离开tableView时调用
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //因为复用，同一个cell可能会走多次
    if ([_cell isEqual:cell]) {
        //区分是否是播放器所在cell,销毁时将指针置空
        [_playerView destroyPlayer];
        _cell = nil;
    }
}

#pragma mark - 点击播放代理
- (void)cl_tableViewCellPlayVideoWithCell:(CLTableViewCell *)cell{
    _cell = cell;
    [_playerView destroyPlayer];
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, cell.CLwidth, cell.CLheight)];
    _playerView = playerView;
    [cell.contentView addSubview:_playerView];
    _playerView.url = [NSURL URLWithString:cell.model.videoUrl];
    [_playerView playVideo];
    [_playerView backButton:^(UIButton *button) {
        // TODO... 修改源代码，把返回按钮做成可在外部隐藏
    }];
    [_playerView endPlay:^{
        [_playerView destroyPlayer];
        _playerView = nil;
        _cell = nil;
    }];
}

#pragma mark - 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSArray<CLTableViewCell *> *array = [self.tableView visibleCells];
    [array enumerateObjectsUsingBlock:^(CLTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cellOffset];
    }];
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
                && shareListModel.objects.count == kHTTPShareListLoadCount
                && (weakSelf.dataArray.count - shareListModel.objects.count) == 0) {
                // Set the callback（Once you enter the refresh status，then call the action of target，that is call [self loadMoreData]）
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(getShareList)];
            }
            if (weakSelf.tableView.mj_footer) {
                // End load. No more data
                
                // TODO... 在底部显示 : 没有更多数据了  .
                
                if (shareListModel.objects.count < kHTTPShareListLoadCount){
                    weakSelf.tableView.mj_footer.hidden = YES;
                }
            }
            
            if (self.dataArray.count == 0) {
                [weakSelf handleError:0 errorMsg:@"暂时没有小伙伴分享，请稍后再试！"];
                return;
            }
        } else {
            [weakSelf.view makeToast:@"网络异常，请稍后再试" duration:kToastDuration position:kToastPositionCenter];
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
    if (contentList.count == 0) {
        return;
    }
    
    for (ShareModel *contentModel in contentList) {
        CLModel *model = [CLModel new];
        model.pictureUrl = [NSString stringWithFormat:@"%@/%@%@", kHTTPHomeAddress, kAPIGetImage, contentModel.icon];
        model.videoUrl = contentModel.video_url;
        [self.dataArray addObject:model];
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
        error = localizeString(@"error_alert_network_fail_recall");
    }
    
    if (self.dataArray.count == 0) {
        [self showEmptyTitle:error];
    } else {
        [self.view makeToast:error duration:kToastDuration position:kToastPositionCenter];
    }
}

@end
