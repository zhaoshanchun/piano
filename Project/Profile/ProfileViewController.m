//
//  ProfileViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/16.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserFeedbackViewController.h"
#import "LoginViewController.h"

#define kSectionNumber 3

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTableView {
    [self.tableView registerClass:[UIBaseTableViewCell class] forCellReuseIdentifier:kUIBaseTableViewCellIndentifier];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSectionNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        // User cell
        return 1;
    } else if (section == 1) {
        // 评价+反馈
        return 2;
    } else {
        // 历史记录
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
            cell.textLabel.text = localizeString(@"登录");
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
            return cell;
        }
    } else if (indexPath.section == 1) {
        UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.textLabel.text = localizeString(@"profile_evaluate");
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
        } else {
            cell.textLabel.text = localizeString(@"profile_feedBack");
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
        }
        return cell;
    } else {
        UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
        cell.textLabel.text = localizeString(@"profile_history");
        return cell;
    }
    UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LoginViewController *vc = [LoginViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSString *str = [NSString stringWithFormat:
                             @"https://itunes.apple.com/cn/app/id%@?mt=8", AppID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        } else {
            [self.navigationController pushViewController:[UserFeedbackViewController new] animated:YES];
        }
    } else {
        
    }
}

@end



