//
//  VideoDetailViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/30.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "CLPlayerView.h"
#import "UIBaseTableViewCell.h"
#import "VideoDetailHeadwCell.h"
#import "VideoDetailMoreVideoCell.h"
#import "VideoDetailHistoryCell.h"
#import "EtagManager.h"
#import "HistoryManager.h"

#define kDefaultMoreContentNumber 3
#define kSectionHeadHeight 40.f
#define kSections 3
// First Section: Detail head
// Second section: More content list
// History view

@interface VideoDetailViewController () <UITableViewDelegate, UITableViewDataSource, VideoDetailHeadwCellDelegate, HistoryListViewDelegate>

@property (strong, nonatomic) ContentModel *contentModel;
@property (strong, nonatomic) NSString *uuid;

@property (strong, nonatomic) CLPlayerView *playerView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) VideoDetailHeadwCellModel *detailHeadCellModel;
@property (strong, nonatomic) NSMutableArray *moreArray;
@property (strong, nonatomic) NSArray *historyArray;

@end

@implementation VideoDetailViewController

- (instancetype)initWithUUID:(NSString *)uuid {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.uuid = uuid;
        self.moreArray = [NSMutableArray new];
        
        self.hideNavigationBar = YES;
    }
    return self;
}

- (instancetype)initWithContentModel:(ContentModel *)contentModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.uuid = contentModel.uuid;
        self.contentModel = contentModel;
        self.moreArray = [NSMutableArray new];
        
        self.hideNavigationBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.tableView];
    
    [self presetMoreContents];
    [self getSourceForUuid:self.uuid];
    
    self.historyArray = [[HistoryManager sharedManager] getAllHistoryList];
}

- (void)dealloc {
    if (_playerView) {
        [_playerView pausePlay];
        [_playerView destroyPlayer];
        _playerView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)presetMoreContents {
    if (self.allContentsArray.count > 0) {
        NSInteger currentIndex = [self checkIndexForConten:self.uuid inArray:self.allContentsArray];
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

#pragma mark - API Action
// TODO... 历史记录：传 uuid+videoPath(本地路径)
- (void)getSourceForUuid:(NSString *)uuid {
    
    [self.view showLoading];
    [[EtagManager sharedManager] getEtagWithHandler:^(NSString *etag, NSString *msg) {
        __weak typeof(self) weakSelf = self;
        
        // http://www.appshopping.store/app/program_source?uuid=XMTc0MDc2NDIxMg==&cert=12345
        // NSString *apiName = [NSString stringWithFormat:@"%@?uuid=%@&cert=%@", kAPIContentDetail, uuid, @"KRAgEpA\+sWECAduFZDEk\+TbE"];
        NSString *cert = etag;
        cert = [cert stringByReplacingOccurrencesOfString:@"+" withString:@""];
        NSString *postData = [NSString stringWithFormat:@"uuid=%@&cert=%@", uuid, cert];
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
                
                SourceModel *sourceModel = responseModel.object;
                [weakSelf.playerView setUrl:[NSURL URLWithString:sourceModel.videoUri]];
                
                _detailHeadCellModel = [VideoDetailHeadwCellModel new];
                weakSelf.detailHeadCellModel.sourceModel = sourceModel;
                [weakSelf.tableView reloadData];
                
                // Save History
                if (weakSelf.contentModel) {
                    [[HistoryManager sharedManager] saveContentToHistory:weakSelf.contentModel];
                } else {
                    ContentModel *contentModel = [ContentModel new];
                    contentModel.uuid = sourceModel.uuid;
                    contentModel.title = sourceModel.title;
                    [[HistoryManager sharedManager] saveContentToHistory:contentModel];
                }
            } else {
                [weakSelf.view makeToast:@"网络异常，请稍后再试" duration:kToastDuration position:kToastPositionCenter];
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
    if ((section == 1 && self.moreArray.count > 0)
        || (section == 2 && self.historyArray.count > 0)) {
        return kSectionHeadHeight;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ((section == 1 && self.moreArray.count > 0)
        || (section == 2 && self.historyArray.count > 0)) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self pageWidth], kSectionHeadHeight)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kVideoDetailMoreVideoCellLRPadding, 10, [self pageWidth] - kVideoDetailMoreVideoCellLRPadding*2, 20)];
        NSString *sectionTitle = (section == 1) ? localizeString(@"相关视频") : localizeString(@"历史记录");
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
    } else if (section == 2) {
        return 1;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.detailHeadCellModel) {
            return self.detailHeadCellModel.cellHeight;
        } else {
            return 0;
        }
    } else if (indexPath.section == 1) {
        if ([self.moreArray count] > indexPath.row) {
            VideoDetailMoreVideoCellModel *cellModel = [self.moreArray objectAtIndex:indexPath.row];
            return cellModel.cellHeight;
        }
    } else if (indexPath.section == 2) {
        return kHistoryListItemImageHeight;
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
    } else if (indexPath.section == 2) {
        VideoDetailHistoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kVideoDetailHistoryCellIdentifier forIndexPath:indexPath];
        cell.historyView.delegate = self;
        [cell.historyView reloadHistory];
        return cell;
    }
    
    UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    } else if (indexPath.section == 1) {
        // TODO... 这里应该通过delegate返回上一层，然后再进入另一个视频的播放页
        VideoDetailMoreVideoCellModel *cellModel = [self.moreArray objectAtIndex:indexPath.row];
        VideoDetailViewController *vc = [[VideoDetailViewController alloc] initWithContentModel:cellModel.contentModel];
        vc.allContentsArray = [self.allContentsArray copy];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - VideoDetailHeadwCellDelegate
//- (void)commonAction {
//    MyLog(@"commonAction");
//}

- (void)shareAction {
    MyLog(@"shareAction");
}

- (void)downLoadAction {
    MyLog(@"downLoadAction");
}

- (void)praiseAction {
    MyLog(@"praiseAction");
}


#pragma mark - HistoryListViewDelegate
- (void)selectedHistory:(ContentModel *)contentModel {
    // TODO... 这里应该通过delegate返回上一层，然后再进入另一个视频的播放页
    VideoDetailViewController *vc = [[VideoDetailViewController alloc] initWithContentModel:contentModel];
    vc.allContentsArray = [self.allContentsArray copy];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Factory method
- (CLPlayerView *)playerView {
    if (_playerView == nil) {
        // TODO... 覆盖 status bar
        _playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, [self pageWidth], [self pageWidth]*9/16)];
        [_playerView backButton:^(UIButton *button) {
            [self.navigationController popViewControllerAnimated:YES];
            if (_playerView) {
                [_playerView pausePlay];
                [_playerView destroyPlayer];
                _playerView = nil;
            }
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
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[UIBaseTableViewCell class] forCellReuseIdentifier:kUIBaseTableViewCellIndentifier];
        [_tableView registerClass:[VideoDetailHeadwCell class] forCellReuseIdentifier:kVideoDetailHeadwCellIdentifier];
        [_tableView registerClass:[VideoDetailMoreVideoCell class] forCellReuseIdentifier:kVideoDetailMoreVideoCellIdentifier];
        [_tableView registerClass:[VideoDetailHistoryCell class] forCellReuseIdentifier:kVideoDetailHistoryCellIdentifier];
    }
    return _tableView;
}


@end


