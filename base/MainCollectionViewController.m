//
//  MainCollectionViewController.m
//  huazhuangjiaocheng
//
//  Created by kun on 2017/6/10.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "CollectionViewCell.h"
#import "CollectionReusableView.h"
#import "AsyncImage.h"
#include "GlobalValue.h"
#import "AppDelegate.h"
#import "PlayerViewController.h"
#import "LBToAppStore.h"
#import "ShowMoreItemH.h"
#import "ShowMoreItemV.h"
#import "SearchView.h"
#import "SearchViewController.h"
#import "SettingViewController.h"
#import "AdCollectionViewCell.h"

@import GoogleMobileAds;

NSString *SectionTitle[] = {@"钢琴乐理基础知识", @"钢琴入门教学课程", @"钢琴演奏技巧", @"经典钢琴曲演奏系列"};


@interface MainCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SearchViewDelegate,AdCollectionViewCellDelegate>

@end

@implementation MainCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startAdmob];
    [self setupSearchView];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 40);
    //该方法也可以设置itemSize
    //layout.itemSize =CGSizeMake(110, 150);
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
    
   // [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-tabFrame.size.height-50]];
    _bottomConstraint = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-tabFrame.size.height];
    [self.view addConstraint:_bottomConstraint];


    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [_collectionView registerClass:[AdCollectionViewCell class] forCellWithReuseIdentifier:@"cellId2"];

    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [_collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    //4.设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}


-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"----->%s", __func__);
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"----->%s", __func__);

}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"----->%s", __func__);
    if(_searchView)
        _searchView.hidden = NO;


}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"----->%s", __func__);
    if(_searchView)
        _searchView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return SectionMultiple;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GlobalValue *globalValue = appDelegate.globalValue;
    long section = [indexPath section];
    long row = [indexPath row];
    long SectionIndex = 0;
    
    if(section == 0)
    {
        AdCollectionViewCell *cell2 = (AdCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId2" forIndexPath:indexPath];
        cell2.delegate = self;
        return cell2;
    }
    
    switch (section) {
        case 1:
            SectionIndex = Section0Index;
            break;
        case 2:
            SectionIndex = Section1Index;
            break;
        case 3:
            SectionIndex = Section2Index;
            break;
        case 4:
            SectionIndex = Section3Index;
            break;
        default:
            break;
    }
    cell.itemIndex = SectionIndex + row;
    
    VideoObject *object = [globalValue getVideoObjectWithIndex:cell.itemIndex];
    cell.iconImageView.image = [UIImage imageNamed:object.icon];
    
    if(![object.time isEqualToString:@""])
    {
        NSString *t = @"时长:";
        t = [t stringByAppendingString:object.time];
        cell.playTime.text = t;
    }
    else{
        cell.playTime.text = @"";
    }
    cell.nameLabel.text = object.title;
    
    AsyncImage *asyncImage = [AsyncImage new];
    [asyncImage LoadImage2:cell Object:object];
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    long section = [indexPath section];
    if(section == 0)
    {
        return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width*0.5);
    }
    else
    {
        float w = self.view.bounds.size.width;
        w = w/3;
        float h = w*0.65;
        return CGSizeMake(w - 15, h);
    }
}

//footer的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//header的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    NSLog(@"%s--section> %ld", __func__, (long)section);
    if(section == 0)
        return CGSizeMake(0, 0);
    return CGSizeMake(self.view.frame.size.width, 40);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(section == 0)
        return UIEdgeInsetsMake(0, 0, 10, 0);
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


//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
    long section = [indexPath section];
    if(section == 0)
        return headerView;

    headerView.video_title.text = SectionTitle[[indexPath section] - 1];
    headerView.backgroundColor =[UIColor whiteColor];
    headerView.button.tag = [indexPath section];
    [headerView.button addTarget:self action:@selector(buttonClickUp:) forControlEvents:UIControlEventTouchUpInside];

    return headerView;
}

-(void)buttonClickUp:(UIButton *)sender{
    NSLog(@"%s tag %ld",__func__, (long)sender.tag);
    switch (sender.tag) {
        case 1:
            [self.navigationController pushViewController:[ShowMoreItemH ShowMoreItemHWithSection:Section0Index] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[ShowMoreItemH ShowMoreItemHWithSection:Section1Index] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[ShowMoreItemV ShowMoreItemVWithSection:Section2Index] animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:[ShowMoreItemV ShowMoreItemVWithSection:Section3Index] animated:YES];
            break;
        default:
            break;
    }
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GlobalValue *globalValue = appDelegate.globalValue;
    VideoObject *object = [globalValue getVideoObjectWithIndex:cell.itemIndex];
    
    NSString *url = nil;

    if(object.videoPath != nil)
        url = object.videoPath;
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    
    [self.navigationController pushViewController:[PlayerViewController playerViewControllerWithVideoPath:url Title:object.title Index:object.uid Ccode:object.code] animated:YES];

}

-(void)onClick:(VideoObject *)object{
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

- (void)startAdmob {
    // Replace this ad unit ID with your own ad unit ID.
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID = AdUnitID;
    self.bannerView.rootViewController = self;
    [self.view addSubview:self.bannerView];
    
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    CGRect tabFrame = self.tabBarController.tabBar.frame;
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-tabFrame.size.height];
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
    CGRect tabFrame = self.tabBarController.tabBar.frame;

    
    [UIView animateWithDuration:1.0 animations:^{
        _bottomConstraint.constant = -tabFrame.size.height-50;
        [self.view setNeedsLayout]; //更新视图
        [self.view layoutIfNeeded];
        bannerView.alpha = 1;
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
    
    [UIView animateWithDuration:1.0 animations:^{
        CGRect tabFrame = self.tabBarController.tabBar.frame;
        _bottomConstraint.constant = -tabFrame.size.height;
        [self.view setNeedsLayout]; //更新视图
        [self.view layoutIfNeeded];
        self.bannerView.hidden = YES;

    }];
    
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
        _timer = [NSTimer scheduledTimerWithTimeInterval:90
                                                  target:self
                                                selector:@selector(showAds)
                                                userInfo:nil
                                                 repeats:NO];
        return;
    }
    
    self.bannerView.hidden = NO;
    self.bannerView.alpha = 0;
    
    [UIView animateWithDuration:1.0 animations:^{
        CGRect tabFrame = self.tabBarController.tabBar.frame;
        _bottomConstraint.constant = -tabFrame.size.height - 50;
        [self.view setNeedsLayout]; //更新视图
        [self.view layoutIfNeeded];
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

#pragma mark - Private

- (void)setupSearchView {
    _searchView = [SearchView new];
    _searchView.frame = CGRectMake(0, 3, self.view.frame.size.width, 30);
    _searchView.textField.text = @"搜索";
    _searchView.delegate = self;
    [self.navigationController.navigationBar addSubview:_searchView];
}

#pragma mark - SearchViewDelegate

- (void)searchButtonWasPressedForSearchView:(SearchView *)searchView {
    SearchViewController *searchViewController = [SearchViewController new];
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:navigationController animated:NO completion:nil];
}

@end
