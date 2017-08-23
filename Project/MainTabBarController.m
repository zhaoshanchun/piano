//
//  MainTabBarController.m
//  base
//
//  Created by kun on 2017/4/20.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "MainCollectionViewController.h"
#import "ProfileViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"MainCollectionViewController",
                                   kTextKey  : localizeString(@"tab_home"),
                                   kTitleKey   : @"",
                                   kImgKey    : @"Home",
                                   kSelImgKey : @"Home"},
                                 
                                 @{kClassKey  : @"HomeViewController",
                                   kTextKey  : @"技巧",
                                   kTitleKey   : @"基础知识、技巧",
                                   kImgKey    : @"Message",
                                   kSelImgKey : @"Message"},
                                 
                                 @{kClassKey  : @"NoteBookViewController",
                                   kTextKey  : @"记录",
                                   kTitleKey   : @"记录-NoteBook",
                                   kImgKey    : @"Book_open",
                                   kSelImgKey : @"Book_open"},
                                 
                                 @{kClassKey  : @"ProfileViewController",
                                   kTitleKey  : localizeString(@"tab_profile"),
                                   kTextKey   : @"我的",
                                   kImgKey    : @"More",
                                   kSelImgKey : @"More"}
                                  ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        vc.title = dict[kTitleKey];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[kTextKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        //item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
       // [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1]} forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // float udAppVersion = [[userDefaults objectForKey:@"appVersion"] intValue];
    [userDefaults setObject:@"0" forKey:@"appOnline"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
    //只支持这一个方向(正常的方向)
}

- (void)checkAppOnline {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com//lookup?id=1231276398"]];
    NSLog(@"%s %@", __func__, url);
    
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
                                          NSNumber *resultCount =  [dict objectForKey:@"resultCount"];
                                          
                                          if([resultCount intValue] == 0) {
                                              NSLog(@"--->online resultCount : %@",resultCount);
                                              return ;
                                          }
                                          
                                          NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                          // float udAppVersion = [[userDefaults objectForKey:@"appVersion"] intValue];
                                          [userDefaults setObject:@"1" forKey:@"appOnline"];
                                          NSLog(@"--->app online ");
                                      } else {
                                      }
                                  }];
    
    //5.执行任务
    [dataTask resume];
}

@end





