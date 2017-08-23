//
//  LoginViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/22.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "LoginTableViewCell.h"


@interface LoginViewController ()

@property (strong, nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic) UIView *footView;

@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:localizeString(@"login")];

    self.listArray = [NSMutableArray new];
    
    LoginTableViewCellModel *userNameCellModel = [[LoginTableViewCellModel alloc] initWithType:LoginTableViewCellNormal];
    userNameCellModel.isFirstCell = YES;
    userNameCellModel.titleAttriute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_title_user_name"), @"BR15N"], nil);
    [userNameCellModel updateFrame];
    [self.listArray addObject:userNameCellModel];
    
    LoginTableViewCellModel *passWordCellModel = [[LoginTableViewCellModel alloc] initWithType:LoginTableViewCellNormal];
    passWordCellModel.isLastCell = YES;
    passWordCellModel.titleAttriute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_title_password"), @"BR15N"], nil);
    [passWordCellModel updateFrame];
    [self.listArray addObject:passWordCellModel];
}

- (void)setTableView {
    [self.tableView registerClass:[LoginTableViewCell class] forCellReuseIdentifier:kLoginTableViewCellIdentifier];
    self.tableView.tableFooterView = self.footView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArray.count > indexPath.row) {
        LoginTableViewCellModel *cellModel = [self.listArray objectAtIndex:indexPath.row];
        return cellModel.cellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLoginTableViewCellIdentifier forIndexPath:indexPath];
    cell.idnexPath = indexPath;
    if (self.listArray.count > indexPath.row) {
        cell.cellModel = [self.listArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - Action
- (void)loginButtonAction {
    // TODO... 登录
}

- (void)registerButtonAction {
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Factory method
- (UIView *)footView {
    if (_footView == nil) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 120)];
        _footView.backgroundColor = [UIColor clearColor];
        
        UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 20, CGRectGetWidth(self.tableView.frame) - 50*2, 40)];
        [loginButton setFontAndTextColorByKey:@"W15B" forState:UIControlStateNormal];
        [loginButton setTitle:localizeString(@"login") forState:UIControlStateNormal];
        loginButton.backgroundColor = [UIColor orThemeColor];
        loginButton.layer.cornerRadius = 5.f;
        loginButton.layer.masksToBounds = YES;
        [loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:loginButton];
        
        UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(loginButton.frame), CGRectGetMaxY(loginButton.frame) + 10, CGRectGetWidth(loginButton.frame), 30)];
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.alignment = NSTextAlignmentCenter;
        NSAttributedString *attribute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_title_register"), @"O14N"], @[style]);
        [registerButton setAttributedTitle:attribute forState:UIControlStateNormal];
        [registerButton addTarget:self action:@selector(registerButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:registerButton];
    }
    return _footView;
}

@end




