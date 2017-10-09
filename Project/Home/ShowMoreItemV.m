//
//  MainCollectionViewController.m
//  huazhuangjiaocheng
//
//  Created by kun on 2017/6/10.
//  Copyright © 2017年 kun. All rights reserved.
//

// #import "MainCollectionViewController.h"
#import "CollectionViewCell.h"
#import "CollectionReusableView.h"
#import "AsyncImage.h"
#include "GlobalValue.h"
#import "AppDelegate.h"
#import "PlayerViewController.h"
#import "LBToAppStore.h"
#import "ShowMoreItemH.h"
#import "ShowMoreItemV.h"


#define ShowMoreItemVCell @"ShowMoreItemVCell"


@import GoogleMobileAds;


@interface ShowMoreItemV ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *videoArray;
}
@end

@implementation ShowMoreItemV


+ (instancetype)ShowMoreItemVWithSection:(long)section{
    ShowMoreItemV *vc = [ShowMoreItemV new];
    vc.section = section;
    [vc initData];
    [vc.collectionView reloadData];
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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_collectionView];
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:rectStatus.size.height+rectNav.size.height]];
    
    CGRect tabFrame = self.tabBarController.tabBar.frame;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-tabFrame.size.height]];
    
    
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:ShowMoreItemVCell];
    
    //4.设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if(self.bannerView.hidden == NO){
        self.tabBarController.tabBar.hidden=YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [videoArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ShowMoreItemVCell forIndexPath:indexPath];
    
    //long section = [indexPath section];
    //section = section*10;
    //long row = [indexPath row];
    cell.itemIndex = [indexPath row];
    
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

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float w = self.view.bounds.size.width;
    w = w/3;
    float h = w*0.65;
    return CGSizeMake(w - 15, h);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

-(void)buttonClickUp:(UIButton *)sender{
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    VideoObject *object = [videoArray objectAtIndex:cell.itemIndex];
    
        
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
        
    [self.navigationController pushViewController:[PlayerViewController playerViewControllerWithVideoPath:object.videoPath Title:object.title Index:object.uid Ccode:object.code] animated:YES];
    
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
    /*
     CGRect tabFrame = self.tabBarController.tabBar.frame;
     NSLayoutConstraint *old =[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-tabFrame.size.height];
     [self.view removeConstraint:old];
     
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-tabFrame.size.height]];
     [self.view setNeedsLayout]; //更新视图
     [self.view layoutIfNeeded];
     */
    self.bannerView.hidden = YES;
    self.tabBarController.tabBar.hidden=NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:90
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
