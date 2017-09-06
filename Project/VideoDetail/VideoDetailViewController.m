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

@interface VideoDetailViewController () <UITableViewDelegate, UITableViewDataSource, VideoDetailHeadwCellDelegate>

@property (strong, nonatomic) CLPlayerView *playerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listArray;

@end

@implementation VideoDetailViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _listArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.tableView];
    
    [self getSource];
}

- (void)dealloc {
    [self.playerView pausePlay];
    [self.playerView destroyPlayer];
    _playerView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - API Action
- (void)getSource {
    [self.view showLoading];
    __weak typeof(self) weakSelf = self;
    // http://www.appshopping.store/app/program_source?uuid=XMTc0MDc2NDIxMg==&cert=12345
    NSString *apiName = [NSString stringWithFormat:@"%@?uuid=XMTc0MDc2NDIxMg==&cert=12345", kAPIContentDetail];
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
            
            VideoDetailHeadwCellModel *cellModel = [VideoDetailHeadwCellModel new];
            cellModel.sourceModel = sourceModel;
            [self.listArray addObject:cellModel];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count + 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && [self.listArray count] > indexPath.row) {
        VideoDetailHeadwCellModel *cellModel = [self.listArray objectAtIndex:0];
        return cellModel.cellHeight;
    }
    return kCellDefaultHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && [self.listArray count] > indexPath.row) {
        VideoDetailHeadwCellModel *cellModel = [self.listArray objectAtIndex:0];
        VideoDetailHeadwCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kVideoDetailHeadwCellIdentifier forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.cellModel = cellModel;
        return cell;
    }
    UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.text = @"相关视频";
    return cell;
}


#pragma mark - VideoDetailHeadwCellDelegate
- (void)commonAction {
    MyLog(@"commonAction");
}

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
        _playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, [self pageWidth], [self pageWidth]*9/16)];
    }
    return _playerView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playerView.frame), [self pageWidth], [self pageHeight] - CGRectGetHeight(self.playerView.frame))];
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
    }
    return _tableView;
}


@end


