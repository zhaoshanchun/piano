//
//  ShowMoreItemV.h
//  huazhuangjiaocheng
//
//  Created by kun on 2017/6/12.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface ShowMoreItemV : UIViewController<GADBannerViewDelegate>

+ (instancetype)ShowMoreItemVWithSection:(long)section;


@property (nonatomic, copy) UICollectionView *collectionView;
@property(nonatomic, strong) IBOutlet GADBannerView *bannerView;
@property (nonatomic,strong) NSTimer   *timer;
@property(nonatomic, copy) NSDictionary *ads;
@property long section;

@end
