//
//  PlayerViewController.m
//  gzwuli
//
//  Created by kun on 2017/5/5.
//  Copyright © 2017年 kun. All rights reserved.
//

@import GoogleMobileAds;

#import "PlayerViewController.h"
#import "CLPlayerView.h"
#import "TFHpple.h"
#import "LBToAppStore.h"
#import "BaseTableViewCell.h"
#import "AppDelegate.h"
#import "GlobalValue.h"
#import "AsyncImage.h"

#define CellIdentifier @"PlayerViewController"
@interface PlayerViewController ()<LBToAppStoreDelegate> {
    NSMutableArray *videoArray;
}
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *Videotitle;
@property (nonatomic, copy) NSString *srcVid;
@property (nonatomic, copy) NSString *htmlUrl;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *clent_id;
@property (nonatomic, strong) NSString *vid;
@property (nonatomic, strong) NSString *ccode;
@property CLPlayerView *playerView;
@property (nonatomic, strong) UILabel *nameLabel;
@property int model;

@end

@implementation PlayerViewController

+ (instancetype)playerViewControllerWithUrlString:(NSString *)title Uid:(NSString *)uid Ccode:(NSString *)ccode URL:(NSString *)htmlUrl {
    PlayerViewController *vc = [PlayerViewController new];
    vc.Videotitle = title;
    vc.vid = uid;
    vc.htmlUrl = htmlUrl;
    vc.ccode = ccode;
    vc.password = nil;
    vc.clent_id = nil;
    vc.model = 0;
    return vc;
}
+ (instancetype)playerViewControllerWithVideoPath:(NSString *)videoPath Title:(NSString *)video_title Index:(NSString *)uid Ccode:(NSString *)ccode {
    PlayerViewController *vc = [PlayerViewController new];
    vc.title = video_title;
    vc.Videotitle = video_title;
    vc.model = 1;
    vc.vid = uid;
    vc.ccode = ccode;
    vc.section = 0;
    vc.videoPath = videoPath;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GlobalValue *globalValue = appDelegate.globalValue;
    [globalValue historySave:uid];

    return vc;
}

- (void)initData {
    videoArray = [NSMutableArray array];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GlobalValue *globalValue = appDelegate.globalValue;
    long maxSize= [globalValue VideoObjectsCount];
    videoArray = [globalValue getVideoObjects:self.section*10 End:maxSize];
    
    NSLog(@"-%s-->maxSize: %ld, size: %ld", __func__, maxSize, (unsigned long)[videoArray count]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    self.bannerView = nil;
    //UIColor* color = [UIColor redColor];
    //NSDictionary* dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    //self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [self setupView];

    if(self.model == 0 || self.videoPath == nil) {
        NSString *cna = getStringFromUserDefaults(kSourceEtag);
        if(cna == nil) {
            [self analysisCookie];
        } else {
            [self analysisUrl:cna id:self.vid];
        }
    } else {
        self.playerView.url = [NSURL URLWithString:self.videoPath];
        [self.playerView playVideo];
    }
    
    //用户好评系统
    LBToAppStore *toAppStore = [[LBToAppStore alloc]init];
    toAppStore.delegate = self;
    [toAppStore showGotoAppStore:self Rep:NO];
    [self startAdmob];
    
    [self UpdateTableView];
}


- (void)viewDidAppear:(BOOL)animated {
    if(self.bannerView == nil || self.bannerView.hidden == YES) {
        self.tabBarController.tabBar.hidden = NO;
    } else if (self.bannerView.hidden == NO) {
        self.tabBarController.tabBar.hidden = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.navigationController popViewControllerAnimated:YES];
    if(_playerView == nil) {
        return;
    }
    [_playerView pausePlay];
    [_playerView destroyPlayer];
    _playerView = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden=NO;
    if(_playerView == nil) {
        return;
    }
    [_playerView pausePlay];
    [_playerView destroyPlayer];
    _playerView = nil;
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)UpdateTableView {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GlobalValue *globalValue = appDelegate.globalValue;
    long row = [globalValue getVideoObjectIndex:self.vid];
    if(row < 0) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}






- (void)setupView {
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = [UIColor redColor];
    _nameLabel.numberOfLines = 2;
    _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _nameLabel.text = self.Videotitle;
    _nameLabel.hidden = YES;
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _nameLabel.contentMode = UIViewContentModeScaleAspectFit;
    [_nameLabel sizeToFit];
    [self.view addSubview:_nameLabel];
    
    //topToolBar高度为父视图高度40
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameLabel.superview attribute:NSLayoutAttributeTop multiplier:1.0f constant:80];
    
    //NSLayoutConstraint* centerYConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.nameLabel.superview attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];

    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.nameLabel.superview attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
    
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.nameLabel.superview attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
    
    topConstraint.active = YES;
   // centerYConstraint.active = YES;
    rightConstraint.active = YES;
    leftConstraint.active = YES;
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    
    _playerView = [CLPlayerView new];
    _playerView.frame = CGRectMake(0, rectStatus.size.height + rectNav.size.height, self.view.bounds.size.width, self.view.bounds.size.width * 9/16);
    
    [self.view addSubview:_playerView];
    
    _tableView = [UITableView new];
    _tableView.rowHeight = 60;
    _tableView.delegate = self;
    _tableView.dataSource=self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_tableView];
    
    [self.tableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    CGRect tabFrame = self.tabBarController.tabBar.frame;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-tabFrame.size.height]];
    
    CGFloat top = rectStatus.size.height + rectNav.size.height + self.view.bounds.size.width * 9/16;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:top]];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"videoArray count: %lu", (unsigned long)[videoArray count]);
    return [videoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    long row = [indexPath row];
    VideoObject *object = [videoArray objectAtIndex:row];
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.uid = object.uid;
    cell.iconImageView.image = [UIImage imageNamed:object.icon];
    cell.nameLabel.text = object.title;
    cell.timeLabel.text = object.time;
    if(![object.time isEqualToString:@""]) {
        NSString *t = @"时长:";
        t = [t stringByAppendingString:object.time];
        cell.playTime.text = t;
    } else{
        cell.playTime.text = @"";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.selectedBackgroundView = [UIView new];//
    cell.selectedBackgroundView.frame = cell.frame;
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:57/255.0 green:157/255.0 blue:229/255.0 alpha:0.5];
    AsyncImage *asyncImage = [AsyncImage new];
    [asyncImage LoadImage:cell Object:object];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    long row = [indexPath row];
    VideoObject *object = [videoArray objectAtIndex:row];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];

    LBToAppStore *toAppStore = [[LBToAppStore alloc]init];
    toAppStore.delegate = self;
    [toAppStore showGotoAppStore:self Rep:NO];
        
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    [_playerView pausePlay];
    [_playerView destroyPlayer];
    [_playerView removeFromSuperview];
    _playerView = nil;

    self.title = object.title;
    _playerView = [CLPlayerView new];
    _playerView.frame = CGRectMake(0, rectStatus.size.height + rectNav.size.height, self.view.bounds.size.width, self.view.bounds.size.width * 9/16);
    [self.view addSubview:_playerView];
    
    [self reloadVideo:object];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GlobalValue *globalValue = appDelegate.globalValue;
    [globalValue historySave:object.uid];
}


#pragma mark - LBToAppStoreDelegate
- (void)ShowButtonAction {
    if(_playerView == nil) {
        return;
    }
    [_playerView pausePlay];
}

- (void)SureButtonAction {
    NSLog(@"%s", __func__);
    if(_playerView == nil) {
        return;
    }
    [_playerView playVideo];
}

-(void)CancelButtonAction{
    NSLog(@"%s", __func__);
    [self.navigationController popViewControllerAnimated:YES];
    if(_playerView == nil) {
        return;
    }
    [_playerView pausePlay];
    [_playerView destroyPlayer];
    _playerView = nil;
}


-(void)reloadVideo:(VideoObject *)object{
    self.title = object.title;
    self.Videotitle = object.title;
    self.vid = object.uid;
    self.ccode = object.code;
    self.section = 0;
    self.videoPath = object.videoPath;
    if (self.model == 0 || self.videoPath == nil) {
        NSString *cna = getStringFromUserDefaults(kSourceEtag);
        if(cna == nil) {
            [self analysisCookie];
        } else{
            [self analysisUrl:cna id:self.vid];
        }
    } else {
        self.playerView.url = [NSURL URLWithString:self.videoPath];
        [self.playerView playVideo];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)analysisCookie {
    NSURL *url = [NSURL URLWithString:@"https://log.mmstat.com/eg.js"];
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                      NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
                                      NSLog(@"%s--->%@ headers %@", __func__, error, headers);
                                      
                                      NSString *cna = headers[@"Etag"];
                                      NSLog(@"%s--->1 %@ cna %@", __func__, error, cna);
                                      cna = [cna stringByReplacingOccurrencesOfString:@"/" withString:@""];
                                      NSLog(@"%s--->2 %@ cna %@", __func__, error, cna);
                                      
                                      if (error == nil) {
                                          saveObjectToUserDefaults(kSourceEtag, cna);

                                          //6.解析服务器返回的数据
                                          //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
                                          //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                          //NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                          //NSLog(@"--->%@",str);
                                          if(self.vid == nil) {
                                              [self parseHtml:self.htmlUrl];
                                          }
                                          [self analysisUrl:[cna stringByReplacingOccurrencesOfString:@"\"" withString:@""] id:_vid];
                                      } else {
                                          [self alertController];
                                      }
                                  }];
    //5.执行任务
    [dataTask resume];
}

- (void)analysisUrl:(NSString *)cna id:(NSString *)vid {
    cna = [cna stringByReplacingOccurrencesOfString:@"/" withString:@""];
    cna = [cna stringByReplacingOccurrencesOfString:@"\"" withString:@""];
   
    NSString *urlStr;
    if (self.clent_id == nil || self.password == nil) {
        urlStr = [NSString stringWithFormat:@"https://ups.youku.com/ups/get.json?&ccode=%@&client_ip=192.168.2.1&vid=%@&utid=%@&client_ts=%ld", self.ccode, self.vid, cna, time(nil)];
    } else {
        urlStr = [NSString stringWithFormat:@"https://ups.youku.com/ups/get.json?&ccode=%@&client_ip=192.168.2.1&vid=%@&utid=%@&client_ts=%ld&client_id=%@&password=%@", self.ccode, self.vid, cna, time(nil), self.clent_id, self.password];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"urlStr--->%@", urlStr);
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                      if (error == nil) {
                                          //6.解析服务器返回的数据
                                          //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
                                          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                          NSString *dstUrl = dict[@"data"][@"stream"][0][@"m3u8_url"];
                                          NSLog(@"--->dstUrl = %@", dstUrl);
                                          
                                          if(dstUrl == nil) {
                                              NSLog(@"--->dict %@", dict);
                                              [self alertController];
                                          } else {
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                  _playerView.url = [NSURL URLWithString:dstUrl];
                                                  [_playerView playVideo];
                                              });
                                          }
                                         // [_LoadingImage setHidden:YES];
                                         // [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dstUrl]]];
                                      } else {
                                          [self alertController];
                                      }
                                  }];
    //5.执行任务
    [dataTask resume];
}

- (BOOL)parseHtml:(NSString *)htmlString {
    //NSString *htmlString = @"http://e.youku.com/cp/ECONDU4NDQ=/ECHNjE4MDQ0?";
    NSLog(@"---parseHtml: > %@", htmlString);
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:htmlString]];
   // NSLog(@"---htmlData: > %@", htmlData);

    if(htmlData == nil) {
        return NO;
    }
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    if(xpathParser == nil) {
        return NO;
    }
    
    NSArray *itemArray = [xpathParser searchWithXPathQuery:@"//script[@type = 'text/javascript']"];
    if(itemArray == nil) {
        return NO;
    }
    //NSLog(@"---itemArray: > %@", itemArray);

    for(TFHppleElement *element in itemArray) {
        NSString *string = [element content];
        if(![string containsString:@"window.playData"]) {
            continue;
        }
        
        if([string containsString:@"password"]) {
            NSArray *array = [string componentsSeparatedByString:@"password\":\""];
            if(array && [array count] >= 2) {
                array = [array[1] componentsSeparatedByString:@"\"}"];
                if(array && [array count] >= 2) {
                    NSString *password = array[0];
                    self.password = password;
                    NSLog(@"---password: > %@", password);
                }
            }
        }
        if([string containsString:@"clent_id"]) {
            NSArray *array = [string componentsSeparatedByString:@"clent_id\":\""];
            if(array && [array count] >= 2) {
                array = [array[1] componentsSeparatedByString:@"\","];
                if(array && [array count] >= 2) {
                    NSString *clent_id = array[0];
                    self.clent_id = clent_id;
                    NSLog(@"---clent_id> %@", clent_id);
                }
            }
        }
        if([string containsString:@"res"]) {
            NSArray *array = [string componentsSeparatedByString:@"res\":\""];
            if(array && [array count] >= 2) {
                array = [array[1] componentsSeparatedByString:@"\","];
                if(array && [array count] >= 2) {
                    NSString *vid = array[0];
                    self.vid = vid;
                    NSLog(@"---vid> %@", vid);
                }
            }
        }
    }
    return YES;
}


- (void)alertController {
    // 危险操作:弹框提醒
    // 1.UIAlertView
    // 2.UIActionSheet
    // iOS8开始:UIAlertController == UIAlertView + UIActionSheet
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络异常，无法正常播放！" preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    //__weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - AD
- (void)startAdmob {
    // Replace this ad unit ID with your own ad unit ID.
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID = AdUnitID;
    self.bannerView.rootViewController = self;
    [self.view addSubview:self.bannerView];
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    constraint.active = YES;
    self.bannerView.hidden = YES;
    self.bannerView.alpha = 0;

    GADRequest *request = [GADRequest request];
    request.testDevices = @[TestDevice];
    [self.bannerView loadRequest:request];
    
    NSLog(@"----->%s", __func__);
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    bannerView.hidden = NO;
    bannerView.alpha = 0;
    [self.view bringSubviewToFront:self.bannerView];
    [UIView animateWithDuration:1.0 animations:^{
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
    _timer = [NSTimer scheduledTimerWithTimeInterval:90
                                              target:self
                                            selector:@selector(showAds)
                                            userInfo:nil
                                             repeats:NO];
}

- (void)showAds{
    self.bannerView.hidden = NO;
    self.bannerView.alpha = 0;
    [self.view bringSubviewToFront:self.bannerView];
    [UIView animateWithDuration:1.0 animations:^{
        self.bannerView.alpha = 1;
        self.tabBarController.tabBar.hidden=YES;
    }];
}

@end
