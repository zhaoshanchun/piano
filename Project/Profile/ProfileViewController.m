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
#import "ProfileUserTableViewCell.h"
#import "UIActionSheet+Blocks.h"

#define kSectionNumber 3

@interface ProfileViewController () <LoginViewControllerDelegate, RegisterViewControllerDelegate>

@property (strong, nonatomic) ProfileUserTableViewCellModel *userCellModel;

@end

@implementation ProfileViewController

- (id)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO; // 当前页面需要 Bottom Bar
        self.hideNavigationBar = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:localizeString(@"page_title_profile")];
    [self presetData];
    
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:kLanguageDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kRegisterSuccessNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTableView {
    [self.tableView registerClass:[ProfileUserTableViewCell class] forCellReuseIdentifier:kProfileUserTableViewCellIdentifier];
    [self.tableView registerClass:[UIBaseTableViewCell class] forCellReuseIdentifier:kUIBaseTableViewCellIndentifier];
}

- (void)presetData {
    NSData *userModelData = (NSData *)getObjectFromUserDefaults(kLoginedUser);
    if (userModelData) {
        UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:userModelData];
        ProfileUserTableViewCellModel *cellModel = [ProfileUserTableViewCellModel new];
        cellModel.userModel = userModel;
        self.userCellModel = cellModel;
    } else {
        self.userCellModel = [ProfileUserTableViewCellModel new];
    }
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSectionNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
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
        // 历史记录+收藏
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return self.userCellModel.cellHeight;
    }
    return kCellDefaultHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ProfileUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileUserTableViewCellIdentifier forIndexPath:indexPath];
            cell.cellModel = self.userCellModel;
            return cell;
        }
    } else if (indexPath.section == 1) {
        UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.textLabel.attributedText = formatAttributedStringByORFontGuide(@[localizeString(@"profile_evaluate"), @"BR15N"], nil);
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
        } else {
            cell.textLabel.attributedText = formatAttributedStringByORFontGuide(@[localizeString(@"profile_feedBack"), @"BR15N"], nil);
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
        }
        return cell;
    } else {
        UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.textLabel.attributedText = formatAttributedStringByORFontGuide(@[localizeString(@"profile_history"), @"BR15N"], nil);
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
        } else {
            cell.textLabel.attributedText = formatAttributedStringByORFontGuide(@[localizeString(@"profile_bookmark"), @"BR15N"], nil);
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
        }
        return cell;
    }
    UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.userCellModel.userModel) {
                // Logined, go to logout!
                [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"cancel取消" destructiveButtonTitle:nil otherButtonTitles:@[@"退出登陆"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        // Logout
                        saveObjectToUserDefaults(kLoginedUser, nil);
                        self.userCellModel.userModel = nil;
                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                    }
                }];
            } else {
                // Unlogin, go to login page
                LoginViewController *vc = [LoginViewController new];
                vc.delegate = self;
                vc.loginBackVC = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
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



#pragma mark - LoginViewControllerDelegate
- (void)loginSuccess {
    NSData *userModelData = (NSData *)getObjectFromUserDefaults(kLoginedUser);
    if (userModelData) {
        UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:userModelData];
        self.userCellModel.userModel = userModel;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - RegisterViewControllerDelegate
- (void)registerSuccess {
    [self loginSuccess];
}

@end






