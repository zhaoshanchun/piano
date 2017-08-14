//
//  SettingViewController.m
//  zuqiujiaoxue
//
//  Created by kun on 2017/6/6.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "SettingViewController.h"
#import "UserFeedbackViewController.h"
#import "LBToAppStore.h"
#import "HistoryView.h"
#import "PlayerViewController.h"

@interface SettingViewController ()<HistoryViewDelegate>

@property (strong, nonatomic) HistoryView *history;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    //用户好评系统
    LBToAppStore *toAppStore = [[LBToAppStore alloc]init];
    [toAppStore showGotoAppStore:self Rep:YES];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton *evaluate = [UIButton new];
    evaluate.backgroundColor = [UIColor whiteColor];
    evaluate.frame = CGRectMake(0, 20 + rectStatus.size.height + rectNav.size.height, self.view.bounds.size.width, 45);
    evaluate.tag = 1;
    [evaluate addTarget:self action:@selector(buttonClickUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:evaluate];

    
    UILabel *label1 = [UILabel new];
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = @"评价应用";
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
    [button1 setImage:[UIImage imageNamed:@"Next"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonClickUp:) forControlEvents:UIControlEventTouchUpInside];
    [evaluate addSubview:button1];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:35]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:25]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:evaluate attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:evaluate attribute:NSLayoutAttributeTrailing multiplier:1 constant:-5]];
    
    

    UIButton *opinion = [UIButton new];
    opinion.backgroundColor = [UIColor whiteColor];
    opinion.frame = CGRectMake(0, 100 + rectStatus.size.height + rectNav.size.height, self.view.bounds.size.width, 45);
    opinion.tag = 2;
    [opinion addTarget:self action:@selector(buttonClickUp:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:opinion];
 
    UILabel *label2 = [UILabel new];
    label2.font = [UIFont systemFontOfSize:16];
    label2.text = @"意见反馈";
    label2.translatesAutoresizingMaskIntoConstraints = NO;
    label2.textColor = [UIColor blackColor];
    label2.numberOfLines = 0;
    label2.lineBreakMode = NSLineBreakByWordWrapping;
    [opinion addSubview:label2];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:opinion attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:opinion attribute:NSLayoutAttributeLeading multiplier:1 constant:5]];
    
    UIButton *button2 = [UIButton new];
    button2.tag = 2;
    button2.translatesAutoresizingMaskIntoConstraints = NO;
    [button2 setImage:[UIImage imageNamed:@"Next"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonClickUp:) forControlEvents:UIControlEventTouchUpInside];
    [opinion addSubview:button2];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:35]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:25]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:opinion attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:opinion attribute:NSLayoutAttributeTrailing multiplier:1 constant:-5]];
    
    _history = [HistoryView new];
    _history.delegate = self;
   // history.frame = CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.width*0.7);
    _history.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_history];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_history attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_history attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_history attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:opinion attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_history attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:(self.view.bounds.size.width/3)]];
    
    [_history updateConstraints];
    [_history updateConstraintsIfNeeded];

}


-(void)buttonClickUp:(UIButton *)sender{
    NSLog(@"%s tag %ld",__func__, (long)sender.tag);
    
    switch (sender.tag) {
        case 1:
        {
            NSString *str = [NSString stringWithFormat:
                             @"https://itunes.apple.com/cn/app/id%@?mt=8", AppID];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 2:
            [self.navigationController pushViewController:[UserFeedbackViewController new] animated:YES];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    if(_history)
        [_history historyReload];
}

- (void)onClickHistoryView:(VideoObject *)object{
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

@end
