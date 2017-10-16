//
//  DownloadSetViewController.m
//  sifakaoshi
//
//  Created by kun on 2017/9/13.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "DownloadSetViewController.h"
#import "DownloadManage.h"

@interface DownloadSetViewController ()
@property DownloadManage *dlManage;
@end

@implementation DownloadSetViewController

- (id)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.hideNavigationBar = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dlManage = [DownloadManage sharedInstance];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton *evaluate = [UIButton new];
    evaluate.backgroundColor = [UIColor whiteColor];
    // evaluate.frame = CGRectMake(0, 20 + rectStatus.size.height + rectNav.size.height, self.view.bounds.size.width, 45);
    evaluate.frame = CGRectMake(0, 10, self.view.bounds.size.width, 45);
    evaluate.tag = 1;
    [evaluate addTarget:self action:@selector(ClickClear:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:evaluate];
    
    
    UILabel *label1 = [UILabel new];
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = localizeString(@"download_title_loaded");
    label1.translatesAutoresizingMaskIntoConstraints = NO;
    label1.textColor = [UIColor blackColor];
    label1.numberOfLines = 0;
    label1.lineBreakMode = NSLineBreakByWordWrapping;
    [evaluate addSubview:label1];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:evaluate attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:evaluate attribute:NSLayoutAttributeLeading multiplier:1 constant:5]];
    UIButton *button1 = [UIButton new];
    button1.tag = 1;
    button1.translatesAutoresizingMaskIntoConstraints = NO;
    [button1 setImage:[UIImage imageNamed:@"common_right_arrow"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(ClickClear:) forControlEvents:UIControlEventTouchUpInside];
    [evaluate addSubview:button1];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:35]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:25]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:evaluate attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:evaluate attribute:NSLayoutAttributeTrailing multiplier:1 constant:-5]];
    
    UILabel *tips = [UILabel new];
    tips.font = [UIFont systemFontOfSize:12];
    tips.text = localizeString(@"download_notice");
    tips.translatesAutoresizingMaskIntoConstraints = NO;
    tips.textColor = [UIColor grayColor];
    tips.numberOfLines = 0;
    tips.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:tips];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tips attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:evaluate attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tips attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tips attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-5]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ClickClear:(UIButton *)bt
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localizeString(@"notice") message:localizeString(@"alert_clean_all_check") preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:localizeString(@"cancel") style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:localizeString(@"confirm") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.dlManage remove_all];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
