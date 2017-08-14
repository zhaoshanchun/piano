//
//  ShowMoreItemV.m
//  huazhuangjiaocheng
//
//  Created by kun on 2017/6/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ShowMoreItemH.h"
#import "GLCoverFlowLayout.h"
#import "CollectionViewCell.h"
#import "CollectionReusableView.h"
#import "AsyncImage.h"
#include "GlobalValue.h"
#import "AppDelegate.h"
#import "PlayerViewController.h"
#import "LBToAppStore.h"
#import "GLCell.h"

#define MAX_ROW 6
#define MAX_Sections 100
#define ShowMoreItemHCollectionViewCell     @"ShowMoreItemHCollectionViewCell"
#define ShowMoreItemHTableViewCell  @"ShowMoreItemHTableViewCell"

@implementation ShowMoreItemH
{
    NSMutableArray *videoArray;
}
#pragma mark - 数据源方法
/*
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float w = collectionView.bounds.size.width;
    return CGSizeMake(w, w);
}
*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MAX_Sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MAX_ROW;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ShowMoreItemHCollectionViewCell forIndexPath:indexPath];
    
    cell.itemIndex = [indexPath row]*10;
    cell.playImageView.hidden = NO;
    VideoObject *object = [videoArray objectAtIndex:cell.itemIndex];
    
    cell.iconImageView.image = [UIImage imageNamed:object.icon];
    cell.nameLabel.text = object.title;
    if(![object.time isEqualToString:@""])
    {
        NSString *t = @"时长:";
        t = [t stringByAppendingString:object.time];
        cell.playTime.text = t;
    }
    else{
        cell.playTime.text = @"";
    }
    AsyncImage *asyncImage = [AsyncImage new];
    [asyncImage LoadImage2:cell Object:object];
    return cell;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    VideoObject *object = [videoArray objectAtIndex:cell.itemIndex];
    
    [self.navigationController pushViewController:[PlayerViewController playerViewControllerWithVideoPath:object.videoPath Title:object.title Index:object.uid Ccode:object.code] animated:YES];
    
}

+ (instancetype)ShowMoreItemHWithSection:(long)section{
    ShowMoreItemH *vc = [ShowMoreItemH new];
    vc.section = section;
    [vc initData];
    [vc.collectionView reloadData];
    [vc.tableView reloadData];
    return vc;
}

-(void)initData{
    videoArray = [NSMutableArray array];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GlobalValue *globalValue = appDelegate.globalValue;
    long maxSize= [globalValue VideoObjectsCount];
    
    videoArray = [globalValue getVideoObjects:self.section End:maxSize];
    /*
    if([videoArray count] < 60 ){
        NSMutableArray *tmpArray = [NSMutableArray array];
        tmpArray = [globalValue getVideoObjects:0 End:maxSize - [videoArray count]];
        [videoArray addObjectsFromArray:tmpArray];
    }
     */
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startAdmob];

    self.title = @"更多";
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.sectionInset = (UIEdgeInsets){0,0,0,0};
    CGSize size = self.view.bounds.size;
    layout.itemSize = CGSizeMake(size.width, size.width*0.5);

    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.alwaysBounceVertical = YES;
    
    _collectionView.showsVerticalScrollIndicator = FALSE;
    _collectionView.showsHorizontalScrollIndicator = FALSE;
    _collectionView.pagingEnabled = YES;

    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_collectionView];
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:rectStatus.size.height + rectNav.size.height]];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:ShowMoreItemHCollectionViewCell];

    //4.设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;

    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.center = CGPointMake(self.view.bounds.size.width*0.5, self.view.bounds.size.width/2 +rectStatus.size.height + rectNav.size.height);
    pageControl.bounds = CGRectMake(0, 0, 150, 40);
    pageControl.pageIndicatorTintColor = [UIColor blueColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.enabled = NO;
    pageControl.numberOfPages = MAX_ROW;
    
    [self.view addSubview:pageControl];
    
    _pageControl=pageControl;
   
    [self addTimer];
    
    
    _tableView = [UITableView new];
    _tableView.rowHeight = 60;
    _tableView.delegate = self;
    _tableView.dataSource=self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];

    [self.tableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:ShowMoreItemHTableViewCell];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    CGRect tabFrame = self.tabBarController.tabBar.frame;

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-tabFrame.size.height]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.pageControl attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
}

#pragma mark 添加定时器
-(void) addTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer ;
    
}

#pragma mark 删除定时器
-(void) removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

-(void) nextpage{
    
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:MAX_Sections/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = currentIndexPathReset.item +1;
    NSInteger nextSection = currentIndexPathReset.section;

    if (nextItem==MAX_ROW) {
        nextItem=0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
   // NSIndexPath *idxPath = [NSIndexPath indexPathForItem:1 inSection:0];
   // [self.collectionView scrollToItemAtIndexPath:idxPath atScrollPosition:0 animated:NO];

    //[self scrollViewDidScroll:self.collectionView];
    if(self.bannerView.hidden == NO){
        self.tabBarController.tabBar.hidden=YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - didScorll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //NSLog(@"--->%s", __func__);

    // 坐标系转换获得collectionView上面的位于中心的cell
    CGPoint pointInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pointInView];
    //NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];

    CollectionViewCell *cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPathNow];
    //NSLog(@"scrollViewDidScroll--->w: %f, h: %f", scrollView.bounds.size.width, scrollView.bounds.size.width);
    
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%MAX_ROW;
    self.pageControl.currentPage =page;
    [self.collectionView bringSubviewToFront:cell];
    
    
    
    
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

#pragma mark 当用户停止的时候调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [videoArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = [indexPath row];
    VideoObject *object = [videoArray objectAtIndex:row];
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShowMoreItemHTableViewCell];
    cell.uid = object.uid;
    cell.iconImageView.image = [UIImage imageNamed:object.icon];
    cell.nameLabel.text = object.title;
    cell.timeLabel.text = object.time;
    if(![object.time isEqualToString:@""])
    {
        NSString *t = @"时长:";
        t = [t stringByAppendingString:object.time];
        cell.playTime.text = t;
    }
    else{
        cell.playTime.text = @"";
    }
    AsyncImage *asyncImage = [AsyncImage new];
    [asyncImage LoadImage:cell Object:object];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = [indexPath row];
    //BaseTableViewCell *cell = (BaseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    VideoObject *object = [videoArray objectAtIndex:row];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    
    [self.navigationController pushViewController:[PlayerViewController playerViewControllerWithVideoPath:object.videoPath Title:object.title Index:object.uid Ccode:object.code] animated:YES];
    
}



-(void)startAdmob{
    // Replace this ad unit ID with your own ad unit ID.
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID = AdUnitID;
    self.bannerView.rootViewController = self;
    [self.view addSubview:self.bannerView];
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    constraint.active = YES;
    self.bannerView.alpha = 0;
    self.bannerView.hidden = YES;

    GADRequest *request = [GADRequest request];
    request.testDevices = @[TestDevice];
    [self.bannerView loadRequest:request];
    
    NSLog(@"----->%s", __func__);
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    bannerView.hidden = NO;
    bannerView.alpha = 0;
    [self.view bringSubviewToFront:self.bannerView];
    [UIView animateWithDuration:0.5 animations:^{
        bannerView.alpha = 1;
        self.tabBarController.tabBar.hidden=YES;
    }];
    NSLog(@"----->%s", __func__);
}

- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"----->adView:didFailToReceiveAdWithError: %@", error.localizedDescription);
    [self adViewWillLeaveApplication:adView];
}

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"----->adViewWillPresentScreen");
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"----->adViewWillDismissScreen");
}

/// Tells the delegate that the full screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"----->adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"----->adViewWillLeaveApplication");
    self.bannerView.hidden = YES;
    self.tabBarController.tabBar.hidden=NO;

    _Adstimer = [NSTimer scheduledTimerWithTimeInterval:90
                                              target:self
                                            selector:@selector(showAds)
                                            userInfo:nil
                                             repeats:NO];
}

- (void)showAds{
    if([self getCurrentVC] != self)
    {
        NSLog(@"---UIViewController is not on the top");
        return;
    }
    self.bannerView.hidden = NO;
    self.bannerView.alpha = 0;
    [self.view bringSubviewToFront:self.bannerView];
    [UIView animateWithDuration:1.0 animations:^{
        self.tabBarController.tabBar.hidden=YES;
        self.bannerView.alpha = 1;
    }];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

@end
