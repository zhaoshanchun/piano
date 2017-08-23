//
//  MainCollectionViewController.h
//  huazhuangjiaocheng
//
//  Created by kun on 2017/6/10.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchView.h"
@import GoogleMobileAds;

@interface MainCollectionViewController : UIViewController<GADBannerViewDelegate>

@property (nonatomic, copy) UICollectionView *collectionView;
@property(nonatomic, strong) IBOutlet GADBannerView *bannerView;
@property (nonatomic,strong) NSTimer   *timer;
@property(nonatomic, copy) NSDictionary *ads;
@property (nonatomic,strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic,strong) SearchView *searchView;
@end
