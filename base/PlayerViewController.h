//
//  PlayerViewController.h
//  gzwuli
//
//  Created by kun on 2017/5/5.
//  Copyright © 2017年 kun. All rights reserved.
//

@import GoogleMobileAds;
#import <UIKit/UIKit.h>


@interface PlayerViewController : UIViewController<GADBannerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet GADBannerView *bannerView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSDictionary *ads;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) long section;

+ (instancetype)playerViewControllerWithUrlString:(NSString *)title
                                              Uid:(NSString *)uid
                                            Ccode:(NSString *)ccode
                                              URL:(NSString *)htmlUrl;
+ (instancetype)playerViewControllerWithVideoPath:(NSString *)videoPath
                                            Title:(NSString *)video_title
                                            Index:(NSString *)uid
                                            Ccode:(NSString *)ccode;

@end
