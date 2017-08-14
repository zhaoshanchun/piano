//
//  ShowMoreItemV.h
//  huazhuangjiaocheng
//
//  Created by kun on 2017/6/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface ShowMoreItemH : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate>


+ (instancetype)ShowMoreItemHWithSection:(long)section;


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic , strong) UIPageControl *pageControl;
@property (nonatomic , strong) UITableView *tableView;
@property NSIndexPath *playIndexPath;
@property(nonatomic, strong) IBOutlet GADBannerView *bannerView;

@property (nonatomic,strong) NSTimer   *Adstimer;
@property(nonatomic, copy) NSDictionary *ads;
@property long section;

@end
