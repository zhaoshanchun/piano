//
//  HomeSubPageViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/29.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "HomeSubPageViewController.h"
#import "UIViewController+ZJScrollPageController.h"
#import "VideoDetailViewController.h"
#import "ContentListCollectionViewCell.h"
#import "ContentListCollectionReusableView.h"

@interface HomeSubPageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ContentListCollectionReusableViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation HomeSubPageViewController

- (id)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
        self.hideNavigationBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    // 在这里加content view, 不要在 viewDidLoad 中加
    [self.view addSubview:self.collectionView];
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 使用系统的生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear------%ld", self.zj_currentIndex);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear-----%ld", self.zj_currentIndex);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear-----%ld", self.zj_currentIndex);
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear--------%ld", self.zj_currentIndex);
    
}


- (void)setClassModel:(ClassifyModel *)classModel {
    _classModel = classModel;
    if (classModel == nil) {
        return;
    }
    
    [self getContentList];
}


#pragma mark - Action


#pragma mark - API Action
- (void)getContentList {
    [self.view showLoading];
    __weak typeof(self) weakSelf = self;
    // http://www.appshopping.store/app/program_list?appid=yixuekaoshi&classifyid=1&from=0&to=20
    NSString *apiName = [NSString stringWithFormat:@"%@?appid=yixuekaoshi&classifyid=%ld&from=0&to=20", kAPIContentList, (long)self.classModel.classifyId];
    [APIManager requestWithApi:apiName httpMethod:kHTTPMethodGet httpBody:nil responseHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!weakSelf) {
            return;
        }
        [weakSelf.view hideLoading];
        
        if (connectionError) {
            MyLog(@"error : %@",[connectionError localizedDescription]);
        } else {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            ContentListModel *contentListModel = [[ContentListModel alloc] initWithString:responseString error:nil];
            if (contentListModel.errorCode != 0) {
                [weakSelf.view makeToast:contentListModel.msg duration:kToastDuration position:kToastPositionCenter];
                return;
            }
            
            if (contentListModel.programs.count > 0) {
                // TODO... Show data
                MyLog(@"count = %ld", contentListModel.programs.count);
            }
            
        }
    }];
}


#pragma mark - collectionViewDelegate and collectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 12;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ContentListCollectionReusableView* reusableView;
    if (UICollectionElementKindSectionHeader == kind) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kContentListCollectionReusableViewIdentifier forIndexPath:indexPath];
    }
    reusableView.indexPath = indexPath;
    reusableView.delegate = self;
    reusableView.title = [NSString stringWithFormat:@"今日精选 %ld", indexPath.section];
    return reusableView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kContentListItemNumber;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ContentListCollectionViewCell *cell = (ContentListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kContentListCollectionViewCellIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoDetailViewController *vc = [[VideoDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//
//}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kContentListItemWidth, kContentListItemHeight);
}


#pragma mark - ContentListCollectionReusableViewDelegate
- (void)moreButtonAction:(NSIndexPath *)indexPath {
    // TODO...
    MyLog(@"section = %ld", (long)indexPath.section);
}


#pragma mark - Factory method
- (UICollectionViewFlowLayout *)layout {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
     layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = kContentListItemMargin;
    // layout.sectionInset = (UIEdgeInsets){0, 0, 0, 0};
    layout.itemSize = (CGSize){kContentListItemWidth, kContentListItemHeight};
    layout.headerReferenceSize=CGSizeMake(kContentListCollectionReusableViewWidth, kContentListCollectionReusableViewHeight);
    return layout;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [self pageWidth], CGRectGetHeight(self.view.frame)) collectionViewLayout:[self layout]];
        _collectionView.backgroundView = nil;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setContentInset:UIEdgeInsetsMake(0, kContentListItemMargin, kContentListItemBottomPadding, kContentListItemMargin)];
        [_collectionView registerClass:[ContentListCollectionViewCell class] forCellWithReuseIdentifier:kContentListCollectionViewCellIdentifier];
        [_collectionView registerClass:[ContentListCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kContentListCollectionReusableViewIdentifier];
        
//        _collectionView.layer.borderColor = [UIColor blackColor].CGColor;
//        _collectionView.layer.borderWidth = 4.5f;
    }
    return _collectionView;
}



@end
