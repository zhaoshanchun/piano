//
//  VideoDetailViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/30.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "UIBaseTableViewCell.h"
#import "VideoDetailHeadwCell.h"
#import "VideoDetailMoreVideoCell.h"
#import "VideoDetailHistoryCell.h"
#import "EtagManager.h"
#import "HistoryManager.h"
#import "DownloadManage.h"
#import "LoginViewController.h"
#import "ShareContentViewController.h"
#import "FavoritesManager.h"

#define kDefaultMoreContentNumber 3
#define kSectionHeadHeight 40.f
#define kSections 3
/*
 0: Detail head
 1: More content list
 2: History view
 */


typedef  NS_ENUM(NSInteger, ActionType) {
    ActionForNone,
    ActionForShare,
};

@interface VideoDetailViewController () <UITableViewDelegate, UITableViewDataSource, VideoDetailHeadwCellDelegate, HistoryListViewDelegate, LoginViewControllerDelegate, ShareContentViewControllerDelegate>

@property (strong, nonatomic) ContentModel *contentModel;
@property (strong, nonatomic) SourceModel *sourceModel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) VideoDetailHeadCellModel *detailHeadCellModel;
@property (strong, nonatomic) NSMutableArray *moreArray;
@property (strong, nonatomic) NSArray *historyArray;

@property (strong, nonatomic) DownloadManage *dlManage;

@property (assign, nonatomic) ActionType actonType;
@property (assign, nonatomic) BOOL shouldPausePlay;

@property FavoritesManager *favoritesManager;

@end

@implementation VideoDetailViewController

- (instancetype)initWithContentModel:(ContentModel *)contentModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.contentModel = contentModel;
        self.moreArray = [NSMutableArray new];
        self.hideNavigationBar = YES;
    }
    return self;
}

- (instancetype)initWithSourceModel:(SourceModel *)sourceModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.sourceModel = sourceModel;
        self.moreArray = [NSMutableArray new];
        self.hideNavigationBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.historyArray = [[HistoryManager sharedManager] getAllHistoryList];
    self.dlManage = [DownloadManage sharedInstance];
    
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.tableView];
    
    // 解决table顶部或底部出现一片空白的问题
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    if (self.sourceModel) {
        [self presetMoreContentsForUuid:self.sourceModel.uuid];
        [self handleSourceModel:self.sourceModel];
    } else if (self.contentModel) {
        [self presetMoreContentsForUuid:self.contentModel.uuid];
        [self getSourceForUuid:self.contentModel.uuid];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_playerView && self.shouldPausePlay) {
        self.shouldPausePlay = NO;
        [self.playerView playVideo];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_playerView && self.shouldPausePlay) {
        [self.playerView pausePlay];
    }
}

- (void)onBtnBackTouchUpInside:(UIButton *)btn completion:(void (^ __nullable)(void))completion {
    [super onBtnBackTouchUpInside:btn completion:completion];
    
    // Save History to DB
    if (self.contentModel) {
        [[HistoryManager sharedManager] saveContentToHistory:self.contentModel];
    } else if (self.sourceModel) {
        ContentModel *contentModel = [ContentModel new];
        contentModel.uuid = self.sourceModel.uuid;
        contentModel.title = self.sourceModel.title;
        [[HistoryManager sharedManager] saveContentToHistory:contentModel];
    }
    
    if (_playerView) {
        [self.playerView pausePlay];
    }
}

- (void)dealloc {
    NSLog(@"--- ---- --- VideoDetailViewController  dealloc");
    if (_playerView) {
        [_playerView destroyPlayer];
        _playerView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - More contents
- (void)presetMoreContentsForUuid:(NSString *)uuid {
    if (self.allContentsArray.count > 0) {
        NSInteger currentIndex = [self checkIndexForConten:uuid inArray:self.allContentsArray];
        NSArray *moreContents = [self getMoreContentsForIndex:currentIndex];
        for (int i = 0; i < moreContents.count; i++) {
            ContentModel *contentModel = [moreContents objectAtIndex:i];
            VideoDetailMoreVideoCellModel *moreCellModel = [VideoDetailMoreVideoCellModel new];
            moreCellModel.contentModel = contentModel;
            [self.moreArray addObject:moreCellModel];
        }
        VideoDetailMoreVideoCellModel *moreCellModel = [self.moreArray lastObject];
        moreCellModel.isLastOne = YES;
        [self.tableView reloadData];
    }
}

- (NSInteger)checkIndexForConten:(NSString *)uuid inArray:(NSArray *)allList {
    if (uuid.length == 0 || allList.count == 0 || allList.count == 1) {
        return 0;
    }
    for (NSInteger i = 0; i < allList.count; i++) {
        ContentModel *loopModel = [allList objectAtIndex:i];
        if (loopModel && [loopModel.uuid isEqualToString:uuid]) {
            return i;
        }
    }
    return 0;
}

// 拿相邻的三个给deatil 页面，当做相关视频
- (NSArray *)getMoreContentsForIndex:(NSInteger)index {
    if (self.allContentsArray.count <= 1 || index >= self.allContentsArray.count) {
        return [NSArray new];
    }
    NSMutableArray *contents = [NSMutableArray new];
    
    if (self.allContentsArray.count < (kDefaultMoreContentNumber + 1)) {
        for (NSInteger i = 0; i < self.allContentsArray.count; i++) {
            if (i != index) {
                [contents addObject:[self.allContentsArray objectAtIndex:i]];
            }
        }
        return contents;
    }
    
    NSInteger loopIndex = index;
    while (contents.count < kDefaultMoreContentNumber) {
        loopIndex ++;
        if (loopIndex >= self.allContentsArray.count) {
            loopIndex = 0;
        }
        if (loopIndex != index) {
            [contents addObject:[self.allContentsArray objectAtIndex:loopIndex]];
        }
    };
    
    return contents;
}


- (void)handleSourceModel:(SourceModel *)sourceModel {
    // NSLog(@"Play video url: %@", sourceModel.videoUri);
    // NSLog(@"status = %d", [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus);
    [self.playerView setUrl:[NSURL URLWithString:sourceModel.videoUri]];
    if (AFNetworkReachabilityStatusReachableViaWWAN == [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        if (getObjectFromUserDefaults(kMobileNetworkPlayUsable)) {
            [self.playerView playVideo];
        } else {
            [UIAlertView showWithTitle:nil message:localizeString(@"view_play_notice_viawwan") cancelButtonTitle:localizeString(@"cancel") otherButtonTitles:@[localizeString(@"play")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    saveObjectToUserDefaults(kMobileNetworkPlayUsable, @(YES));
                    [self.playerView playVideo];
                } else {
                    saveObjectToUserDefaults(kMobileNetworkPlayUsable, nil);
                }
            }];
        }
    } else {
        [self.playerView playVideo];
    }
    
    _detailHeadCellModel = [VideoDetailHeadCellModel new];
    self.detailHeadCellModel.sourceModel = sourceModel;
    [self.tableView reloadData];
}


#pragma mark - API Action
- (void)getSourceForUuid:(NSString *)uuid {
    [self.view showLoading];
    [[EtagManager sharedManager] getEtagWithHandler:^(NSString *etag, NSString *msg) {
        // http://www.appshopping.store/app/program_source?uuid=XMTc0MDc2NDIxMg==&cert=12345
        // NSString *apiName = [NSString stringWithFormat:@"%@?uuid=%@&cert=%@", kAPIContentDetail, uuid, @"KRAgEpA\+sWECAduFZDEk\+TbE"];
        NSString *cert = etag;
        cert = [cert stringByReplacingOccurrencesOfString:@"+" withString:@""];
        NSString *postData = [NSString stringWithFormat:@"uuid=%@&cert=%@", uuid, cert];
        // NSLog(@"postData: %@", postData);
        
        __weak typeof(self) weakSelf = self;
        [APIManager requestWithApi:kAPIContentDetail httpMethod:kHTTPMethodPost httpBody:postData responseHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (!weakSelf) {
                return;
            }
            [weakSelf.view hideLoading];
            
            if (!connectionError) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                SourceResponseModel *responseModel = [[SourceResponseModel alloc] initWithString:responseString error:nil];
                if (responseModel.errorCode != 0) {
                    [weakSelf.view makeToast:responseModel.msg duration:kToastDuration position:kToastPositionCenter];
                    return;
                }
                
                weakSelf.sourceModel = responseModel.object;
                [weakSelf handleSourceModel:weakSelf.sourceModel];
            } else {
                [weakSelf.view makeToast:localizeString(@"error_alert_network_fail") duration:kToastDuration position:kToastPositionCenter];
            }
        }];
    }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 && self.moreArray.count > 0) {
        return kSectionHeadHeight;
    } else if (section == 2) {
        return kSectionHeadHeight;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1 && self.moreArray.count > 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self pageWidth], kSectionHeadHeight)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kVideoDetailMoreVideoCellLRPadding, 10, [self pageWidth] - kVideoDetailMoreVideoCellLRPadding*2, 20)];
        NSString *sectionTitle = (section == 1) ? localizeString(@"more_contents") : localizeString(@"view_historys");
        label.attributedText = formatAttributedStringByORFontGuide(@[sectionTitle, @"BR16B"], nil);
        [view addSubview:label];
        return view;
    }  else if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self pageWidth], kSectionHeadHeight)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kVideoDetailMoreVideoCellLRPadding, 10, [self pageWidth] - kVideoDetailMoreVideoCellLRPadding*2, 20)];
        NSString *sectionTitle = (section == 1) ? localizeString(@"more_contents") : localizeString(@"view_historys");
        label.attributedText = formatAttributedStringByORFontGuide(@[sectionTitle, @"BR16B"], nil);
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (self.detailHeadCellModel ? 1 : 0);
    } else if (section == 1) {
        return self.moreArray.count;
    } else if (section == 2 && self.historyArray.count > 0) {
        return 1;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.detailHeadCellModel) {
            return self.detailHeadCellModel.cellHeight;
        }
    } else if (indexPath.section == 1) {
        if ([self.moreArray count] > indexPath.row) {
            VideoDetailMoreVideoCellModel *cellModel = [self.moreArray objectAtIndex:indexPath.row];
            return cellModel.cellHeight;
        }
    } else if (indexPath.section == 2) {
        if (self.historyArray.count > 0) {
            return kHistoryListItemHeight;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.detailHeadCellModel) {
        VideoDetailHeadwCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kVideoDetailHeadwCellIdentifier forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.cellModel = self.detailHeadCellModel;
        return cell;
        
    } else if (indexPath.section == 1 && [self.moreArray count] > indexPath.row) {
        VideoDetailMoreVideoCellModel *cellModel = [self.moreArray objectAtIndex:indexPath.row];
        VideoDetailMoreVideoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kVideoDetailMoreVideoCellIdentifier forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.cellModel = cellModel;
        return cell;
    } else if (indexPath.section == 2 && self.historyArray.count > 0) {
        VideoDetailHistoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kVideoDetailHistoryCellIdentifier forIndexPath:indexPath];
        cell.historyView.delegate = self;
        cell.historyView.historyList = [self.historyArray copy];
        return cell;
    }
    
    UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    } else if (indexPath.section == 1) {
        VideoDetailMoreVideoCellModel *cellModel = [self.moreArray objectAtIndex:indexPath.row];
        [self onBtnBackTouchUpInside:nil completion:^{
            if (_playerView) {
                [_playerView destroyPlayer];
                _playerView = nil;
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(playContent:)]) {
                [self.delegate playContent:cellModel.contentModel];
            }
        }];
    }
}


#pragma mark - HistoryListViewDelegate
- (void)selectedHistory:(ContentModel *)contentModel {
    [self onBtnBackTouchUpInside:nil completion:^{
        if (_playerView) {
            [_playerView destroyPlayer];
            _playerView = nil;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(playContent:)]) {
            [self.delegate playContent:contentModel];
        }
    }];
}


#pragma mark - VideoDetailHeadwCellDelegate
//- (void)commonAction {
//    MyLog(@"commonAction");
//}

- (void)shareAction {
    MyLog(@"shareAction");
    
    // Login check
    if (!self.userModel) {
        [UIAlertView showWithTitle:localizeString(@"profile_alert_login") message:nil cancelButtonTitle:localizeString(@"cancel") otherButtonTitles:@[localizeString(@"login")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                // Go to login page
                self.actonType = ActionForShare;
                self.shouldPausePlay = YES;
                LoginViewController *vc = [LoginViewController new];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        return;
    }
    
    self.shouldPausePlay = YES;
    
    NSString *uuid = @"";
    NSString *preview = @"";
    NSString *title = @"";
    if (self.contentModel) {
        uuid = self.contentModel.uuid;
        preview = self.contentModel.preview;
        title = self.contentModel.title;
    } else if (self.sourceModel) {
        uuid = self.sourceModel.uuid;
        title = self.sourceModel.title;
    }
    
    ShareContentViewController *vc = [[ShareContentViewController alloc] initWithTitle:title];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)downLoadAction {
    [self.dlManage add_download:self.contentModel.uuid url:@"" icon:self.contentModel.preview title:self.contentModel.title];
    [self.dlManage start_download:self.contentModel.uuid];
    [self.view makeToast:localizeString(@"download_notice_to_download") duration:kToastDuration position:kToastPositionCenter];

}

- (void)praiseAction {
    // www.szappstore.com/app/praise?user=kunhuang&uuid=XMTc0MDc2NDIxMg==
    // Login check
    if (!self.userModel) {
        [UIAlertView showWithTitle:localizeString(@"profile_alert_login") message:nil cancelButtonTitle:localizeString(@"cancel") otherButtonTitles:@[localizeString(@"login")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                // Go to login page
                self.actonType = ActionForShare;
                LoginViewController *vc = [LoginViewController new];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSString *praiseApi = [NSString stringWithFormat:@"%@?user=%@&uuid=%@", kAPIPraise, self.userModel.userName, self.contentModel.uuid];
    [APIManager requestWithApi:praiseApi httpMethod:kHTTPMethodGet httpBody:nil responseHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
           [weakSelf.view makeToast:localizeString(@"parise_notice_bookmark_success") duration:kToastDuration position:kToastPositionCenter];
        } else {
            [weakSelf.view makeToast:localizeString(@"error_alert_network_fail") duration:kToastDuration position:kToastPositionCenter];
        }
    }];
    
    //MyLog(@"praiseApi: %@", praiseApi);
    //[self.view makeToast:localizeString(@"parise_notice_bookmark_success") duration:kToastDuration position:kToastPositionCenter];


}

- (void)favoriteAction {
    MyLog(@"favoriteAction");
    self.favoritesManager = [FavoritesManager sharedManager];
    [self.favoritesManager add:self.contentModel.uuid title:self.contentModel.title preview:self.contentModel.preview];
    
    [self.view makeToast:localizeString(@"favority_notice_bookmark_success") duration:kToastDuration position:kToastPositionCenter];
}

#pragma mark - LoginViewControllerDelegate
- (void)loginSuccess {
    if (ActionForShare == self.actonType) {
        self.shouldPausePlay = NO;
        [self shareAction];
    }
    self.actonType = ActionForNone;
}

#pragma mark - ShareContentViewControllerDelegate
- (void)shareWithContent:(NSString *)shareContent {
    NSString *uuid = @"";
    NSString *preview = @"";
    NSString *title = @"";
    if (self.contentModel) {
        uuid = self.contentModel.uuid;
        preview = self.contentModel.preview;
        title = self.contentModel.title;
    } else if (self.sourceModel) {
        uuid = self.sourceModel.uuid;
        title = self.sourceModel.title;
    }
    
    __weak typeof(self) weakSelf = self;
    NSString *shareSubmitApi = [NSString stringWithFormat:@"%@?", kAPIShareSubmit];
    shareSubmitApi = [shareSubmitApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *param = [NSString stringWithFormat:@"user=%@&uuid=%@&content=%@", self.userModel.userName, uuid, shareContent];

    [APIManager requestWithApi:shareSubmitApi httpMethod:kHTTPMethodPost httpBody:param responseHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            [weakSelf.view makeToast:localizeString(@"share_success") duration:kToastDuration position:kToastPositionCenter];
        } else {
            NSLog(@"connectionError: %@", connectionError);
            [weakSelf.view makeToast:localizeString(@"error_alert_network_fail") duration:kToastDuration position:kToastPositionCenter];
        }
    }];
}


#pragma mark - Factory method
- (CLPlayerView *)playerView {
    if (_playerView == nil) {
        _playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, [self pageWidth], [self pageWidth]*9/16)];
        //返回按钮点击事件回调
        __weak typeof(self) weakSelf = self;
        [_playerView backButton:^(UIButton *button) {
            [weakSelf onBtnBackTouchUpInside:nil completion:^{
                if (_playerView) {
                    [_playerView destroyPlayer];
                    _playerView = nil;
                }
            }];
        }];
        //播放完成回调
        [_playerView endPlay:^{
            
        }];
    }
    return _playerView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playerView.frame), [self pageWidth], [self pageHeight] - CGRectGetMaxY(self.playerView.frame))];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor grayColor];
        _tableView.delaysContentTouches = NO;
        
        if (IS_IPHONE_X || IS_IOS_11_OR_ABOVE) {
            // 解决 iphone x 的 section headView 显示不出来的问题
            _tableView.estimatedSectionHeaderHeight=0;
            _tableView.estimatedSectionFooterHeight=0;
        }
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [_tableView setPreservesSuperviewLayoutMargins:NO];;
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setKeyboardDismissMode:)]) {
            [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        }
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self pageWidth], 50)];
        
        [_tableView registerClass:[UIBaseTableViewCell class] forCellReuseIdentifier:kUIBaseTableViewCellIndentifier];
        [_tableView registerClass:[VideoDetailHeadwCell class] forCellReuseIdentifier:kVideoDetailHeadwCellIdentifier];
        [_tableView registerClass:[VideoDetailMoreVideoCell class] forCellReuseIdentifier:kVideoDetailMoreVideoCellIdentifier];
        [_tableView registerClass:[VideoDetailHistoryCell class] forCellReuseIdentifier:kVideoDetailHistoryCellIdentifier];
    }
    return _tableView;
}


@end


