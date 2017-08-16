//
//  ProfileViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/16.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserFeedbackViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTableRegister {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"评价应用";
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"意见反馈";
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
    } else {
        cell.textLabel.text = @"历史观看";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *str = [NSString stringWithFormat:
                         @"https://itunes.apple.com/cn/app/id%@?mt=8", AppID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } else if (indexPath.section == 1) {
        [self.navigationController pushViewController:[UserFeedbackViewController new] animated:YES];
    } else {
        
    }
}

@end
