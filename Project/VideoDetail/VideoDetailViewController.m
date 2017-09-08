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

#define kDefaultMoreContentNumber 3

@interface VideoDetailViewController () <UITableViewDelegate, UITableViewDataSource, VideoDetailHeadwCellDelegate>

@property (strong, nonatomic) NSString *uuid;

@property (strong, nonatomic) CLPlayerView *playerView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) VideoDetailHeadwCellModel *detailHeadCellModel;
@property (strong, nonatomic) NSMutableArray *moreArray;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.tableView];
    
    [self presetMoreContents];
    [self getSourceForUuid:self.uuid];
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
- (void)getSourceForUuid:(NSString *)uuid {
    [self.view showLoading];
    __weak typeof(self) weakSelf = self;
    // http://www.appshopping.store/app/program_source?uuid=XMTc0MDc2NDIxMg==&cert=12345
    NSString *apiName = [NSString stringWithFormat:@"%@?uuid=%@==&cert=%@", kAPIContentDetail, uuid, @"12345"];
    [APIManager requestWithApi:apiName httpMethod:kHTTPMethodGet httpBody:nil responseHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!weakSelf) {
            return;
        }
        [weakSelf.view hideLoading];
        
        if (connectionError) {
            MyLog(@"error : %@",[connectionError localizedDescription]);
        } else {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            SourceResponseModel *responseModel = [[SourceResponseModel alloc] initWithString:responseString error:nil];
            if (responseModel.errorCode != 0) {
                [weakSelf.view makeToast:responseModel.msg duration:kToastDuration position:kToastPositionCenter];
                return;
            }
            
            SourceModel *sourceModel = responseModel.object;
//            MyLog(@"sourceModel.title = %@", sourceModel.title);
//            [self setNavigationBarTitle:sourceModel.title];
            
            [self.playerView setUrl:[NSURL URLWithString:sourceModel.videoUri]];
            
            _detailHeadCellModel = [VideoDetailHeadwCellModel new];
            self.detailHeadCellModel.sourceModel = sourceModel;
            [self.tableView reloadData];
        }
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
    // First Section: Detail head
    // Second section: More content list
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (self.detailHeadCellModel ? 1 : 0);
    } else if (section == 1) {
        return self.moreArray.count;
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
    }
    UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    } else if (indexPath.section == 1) {
        // TODO... delegate back to push other video
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



#pragma mark - Factory method
- (CLPlayerView *)playerView {
    if (_playerView == nil) {
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
    }
    return _tableView;
}


@end


