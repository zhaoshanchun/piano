//
//  HomeViewController.h
//  gzwuli
//
//  Created by kun on 2017/5/8.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface HomeViewController : UIViewController<GADBannerViewDelegate>
@property(nonatomic, strong) IBOutlet GADBannerView *bannerView;
@property (nonatomic,strong) NSTimer   *timer;
@property(nonatomic, copy) NSDictionary *ads;
@property (nonatomic,strong) NSLayoutConstraint *bottomConstraint;
@end
